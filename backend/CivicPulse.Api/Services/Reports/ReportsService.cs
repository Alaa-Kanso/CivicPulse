using CivicPulse.Api.Dtos.Reports;
using CivicPulse.Api.Exceptions;
using CivicPulse.Domain.Entities;
using CivicPulse.Domain.Enums;
using CivicPulse.Infrastructure.Data;
using CivicPulse.Api.Services.Uploads;
using CivicPulse.Api.Services.ReportGrouping;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Geometries;

namespace CivicPulse.Api.Services.Reports;

public sealed class ReportsService : IReportsService
{
    private readonly CivicPulseDbContext _db;
    private readonly IUploadsService _uploadsService;
    private readonly IReportGroupingService _reportGroupingService;

    private const double ReportGroupingRadiusMeters = 50;

    public ReportsService(
        CivicPulseDbContext db,
        IUploadsService uploadsService,
        IReportGroupingService reportGroupingService)
    {
        _db = db;
        _uploadsService = uploadsService;
        _reportGroupingService = reportGroupingService;
    }

    public async Task<IReadOnlyList<ReportTypeDto>> GetReportTypesAsync()
    {
        return await _db.ReportTypes
            .AsNoTracking()
            .Where(rt => rt.IsActive)
            .OrderBy(rt => rt.SortOrder)
            .ThenBy(rt => rt.Name)
            .Select(rt => new ReportTypeDto
            {
                Id = rt.Id,
                Name = rt.Name,
                Description = rt.Description
            })
            .ToListAsync();
    }

    public async Task<MyReportItemDto> CreateAsync(Guid currentUserId, CreateReportRequestDto request)
    {
        var user = await _db.Users
            .SingleOrDefaultAsync(u => u.Id == currentUserId)
            ?? throw new UnauthorizedException("User was not found.");

        if (user.Role != UserRole.Citizen)
            throw new ForbiddenException("Only citizens can create reports.");

        if (user.Status == UserStatus.Banned)
            throw new ForbiddenException("Your account has been blocked.");

        if (user.Status == UserStatus.Restricted)
            throw new ForbiddenException("Your account is temporarily restricted from creating reports while under review.");

        if (request.Latitude < -90 || request.Latitude > 90)
            throw new BadRequestException("Latitude must be between -90 and 90.");

        if (request.Longitude < -180 || request.Longitude > 180)
            throw new BadRequestException("Longitude must be between -180 and 180.");

        var reportType = await _db.ReportTypes
            .AsNoTracking()
            .SingleOrDefaultAsync(rt => rt.Id == request.ReportTypeId && rt.IsActive);

        if (reportType is null)
            throw new BadRequestException("The selected report type is invalid.");

        var point = new Point(request.Longitude, request.Latitude) { SRID = 4326 };

        var municipality = await _db.Municipalities
            .AsNoTracking()
            .SingleOrDefaultAsync(m => m.Geometry.Contains(point));

        bool requiresAdminRouting = false;
        AdminRoutingReason? adminRoutingReason = null;
        long? municipalityId = null;
        string? municipalityName = null;
        string? originalMunicipalityName = null;

        if (municipality is null)
        {
            requiresAdminRouting = true;
            adminRoutingReason = AdminRoutingReason.UnsupportedMunicipality;
        }
        else
        {
            municipalityId = municipality.Id;
            municipalityName = municipality.Adm3Name;
            originalMunicipalityName = municipality.Adm3Name;

            var hasActiveOperator = await _db.Users
                .AnyAsync(u =>
                    u.Role == UserRole.Operator &&
                    u.AssignedMunicipalityId == municipality.Id &&
                    u.Status == UserStatus.Active);

            if (!hasActiveOperator)
            {
                requiresAdminRouting = true;
                adminRoutingReason = AdminRoutingReason.NoActiveOperatorAssigned;
            }
        }

        var report = new Report
        {
            CreatedByUserId = currentUserId,
            ReportTypeId = reportType.Id,
            Location = point,
            ImageKey = request.ImageKey,
            MunicipalityId = municipalityId,
            AddressDetails = request.AddressDetails,
            Description = request.Description,
            Status = ReportStatus.Submitted,
            RequiresAdminRouting = requiresAdminRouting,
            AdminRoutingReason = adminRoutingReason,
            OriginalMunicipalityName = originalMunicipalityName,
            CreatedAtUtc = DateTime.UtcNow
        };

        await _reportGroupingService.AssignGroupAsync(report);

        _db.Reports.Add(report);
        await _db.SaveChangesAsync();

        return new MyReportItemDto
        {
            Id = report.Id,
            ReportTypeId = reportType.Id,
            ReportTypeName = reportType.Name,
            MunicipalityId = report.MunicipalityId,
            MunicipalityName = municipalityName ?? originalMunicipalityName,
            ImageKey = report.ImageKey,
            ImageUrl = null,
            Description = report.Description ?? string.Empty,
            AddressDetails = report.AddressDetails,
            Status = report.Status.ToString(),
            CreatedAtUtc = report.CreatedAtUtc,
            Latitude = request.Latitude,
            Longitude = request.Longitude,
            RequiresAdminRouting = report.RequiresAdminRouting,
            AdminRoutingReason = report.AdminRoutingReason?.ToString(),
            ReportGroupId = report.ReportGroupId
        };
    }

    public async Task<IReadOnlyList<MyReportItemDto>> GetMyReportsAsync(Guid currentUserId)
    {
        var user = await _db.Users
            .AsNoTracking()
            .SingleOrDefaultAsync(u => u.Id == currentUserId);

        if (user is null)
            throw new UnauthorizedException("User was not found.");

        if (user.Role != UserRole.Citizen)
            throw new ForbiddenException("Only citizens can access this endpoint.");

        var reports = await _db.Reports
            .AsNoTracking()
            .Where(r => r.CreatedByUserId == currentUserId)
            .OrderByDescending(r => r.CreatedAtUtc)
            .Select(r => new
            {
                r.Id,
                r.ReportTypeId,
                ReportTypeName = r.ReportType.Name,
                r.MunicipalityId,
                MunicipalityName = r.Municipality != null
                    ? r.Municipality.Adm3Name
                    : r.OriginalMunicipalityName,
                r.ImageKey,
                Description = r.Description ?? string.Empty,
                r.AddressDetails,
                Status = r.Status.ToString(),
                r.CreatedAtUtc,
                Latitude = r.Location.Y,
                Longitude = r.Location.X,
                r.RequiresAdminRouting,
                AdminRoutingReason = r.AdminRoutingReason != null
                    ? r.AdminRoutingReason.ToString()
                    : null,
                r.ReportGroupId
            })
            .ToListAsync();

        var result = await Task.WhenAll(reports.Select(async r =>
        {
            string? imageUrl = null;

            try
            {
                imageUrl = await _uploadsService.CreateSignedReadUrlAsync(r.ImageKey);
            }
            catch (StorageObjectNotFoundException)
            {
                imageUrl = null;
            }
            catch (InvalidOperationException)
            {
                imageUrl = null;
            }

            return new MyReportItemDto
            {
                Id = r.Id,
                ReportTypeId = r.ReportTypeId,
                ReportTypeName = r.ReportTypeName,
                MunicipalityId = r.MunicipalityId,
                MunicipalityName = r.MunicipalityName,
                ImageKey = r.ImageKey,
                ImageUrl = imageUrl,
                Description = r.Description,
                AddressDetails = r.AddressDetails,
                Status = r.Status,
                CreatedAtUtc = r.CreatedAtUtc,
                Latitude = r.Latitude,
                Longitude = r.Longitude,
                RequiresAdminRouting = r.RequiresAdminRouting,
                AdminRoutingReason = r.AdminRoutingReason,
                ReportGroupId = r.ReportGroupId
            };
        }));

        return result;
    }

    public async Task<ReportDetailsDto> GetByIdAsync(Guid currentUserId, Guid reportId)
    {
        var user = await _db.Users
            .AsNoTracking()
            .SingleOrDefaultAsync(u => u.Id == currentUserId);

        if (user is null)
            throw new UnauthorizedException("User was not found.");

        if (user.Role != UserRole.Citizen)
            throw new ForbiddenException("Only citizens can access this endpoint.");

        var report = await _db.Reports
            .AsNoTracking()
            .Where(r => r.Id == reportId && r.CreatedByUserId == currentUserId)
            .Include(r => r.ReportType)
            .Include(r => r.Municipality)
            .SingleOrDefaultAsync();

        if (report is null)
            throw new NotFoundException("Report was not found.");

        var imageUrl = await _uploadsService.CreateSignedReadUrlAsync(report.ImageKey);

        return new ReportDetailsDto
        {
            Id = report.Id,
            ReportTypeId = report.ReportTypeId,
            ReportTypeName = report.ReportType.Name,
            MunicipalityId = report.MunicipalityId,
            MunicipalityName = report.Municipality != null
                ? report.Municipality.Adm3Name
                : report.OriginalMunicipalityName,
            ImageKey = report.ImageKey,
            ImageUrl = imageUrl,
            Description = report.Description ?? string.Empty,
            AddressDetails = report.AddressDetails,
            Status = report.Status.ToString(),
            CreatedAtUtc = report.CreatedAtUtc,
            Latitude = report.Location.Y,
            Longitude = report.Location.X,
            RequiresAdminRouting = report.RequiresAdminRouting,
            AdminRoutingReason = report.AdminRoutingReason?.ToString(),
            ReportGroupId = report.ReportGroupId
        };
    }

    private async Task<ReportGroup?> FindNearbyReportGroupAsync(long municipalityId, int reportTypeId, Point point)
    {
        var candidateGroups = await _db.ReportGroups
            .AsNoTracking()
            .Where(g =>
                g.MunicipalityId == municipalityId &&
                g.ReportTypeId == reportTypeId)
            .Select(g => new
            {
                Group = g,
                Latitude = g.CenterLocation.Y,
                Longitude = g.CenterLocation.X
            })
            .ToListAsync();

        var targetLatitude = point.Y;
        var targetLongitude = point.X;

        var nearest = candidateGroups
            .Select(x => new
            {
                x.Group,
                DistanceMeters = CalculateDistanceMeters(
                    targetLatitude,
                    targetLongitude,
                    x.Latitude,
                    x.Longitude)
            })
            .Where(x => x.DistanceMeters <= ReportGroupingRadiusMeters)
            .OrderBy(x => x.DistanceMeters)
            .FirstOrDefault();

        return nearest?.Group;
    }

    private static double CalculateDistanceMeters(
        double lat1,
        double lon1,
        double lat2,
        double lon2)
    {
        const double earthRadiusMeters = 6371000;

        static double ToRadians(double degrees) => degrees * Math.PI / 180.0;

        var dLat = ToRadians(lat2 - lat1);
        var dLon = ToRadians(lon2 - lon1);

        var a =
            Math.Pow(Math.Sin(dLat / 2), 2) +
            Math.Cos(ToRadians(lat1)) *
            Math.Cos(ToRadians(lat2)) *
            Math.Pow(Math.Sin(dLon / 2), 2);

        var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
        return earthRadiusMeters * c;
    }
}