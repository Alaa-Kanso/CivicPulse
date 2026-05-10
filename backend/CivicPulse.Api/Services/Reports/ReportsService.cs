using CivicPulse.Api.Dtos.Reports;
using CivicPulse.Api.Exceptions;
using CivicPulse.Domain.Entities;
using CivicPulse.Domain.Enums;
using CivicPulse.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Geometries;

namespace CivicPulse.Api.Services.Reports;

public sealed class ReportsService : IReportsService
{
    private readonly CivicPulseDbContext _db;

    public ReportsService(CivicPulseDbContext db)
    {
        _db = db;
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
            .SingleOrDefaultAsync(u => u.Id == currentUserId);

        if (user is null)
            throw new UnauthorizedException("User was not found.");

        if (user.Role != UserRole.Citizen)
            throw new ForbiddenException("Only citizens can create reports.");

        if (user.Status == UserStatus.Banned)
            throw new ForbiddenException("Your account has been blocked.");

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

        if (municipality is null)
            throw new BadRequestException("Could not determine municipality for the selected location.");

        var report = new Report
        {
            CreatedByUserId = currentUserId,
            ReportTypeId = reportType.Id,
            Location = point,
            ImageUrl = request.ImageUrl,
            MunicipalityId = municipality.Id,
            AddressDetails = request.AddressDetails,
            Description = request.Description,
            Status = ReportStatus.Submitted,
            CreatedAtUtc = DateTime.UtcNow
        };

        _db.Reports.Add(report);
        await _db.SaveChangesAsync();

        return new MyReportItemDto
        {
            Id = report.Id,
            ReportTypeId = reportType.Id,
            ReportTypeName = reportType.Name,
            MunicipalityId = municipality.Id,
            MunicipalityName = municipality.Adm3Name,
            ImageUrl = report.ImageUrl,
            Description = report.Description ?? string.Empty,
            AddressDetails = report.AddressDetails,
            Status = report.Status.ToString(),
            CreatedAtUtc = report.CreatedAtUtc,
            Latitude = request.Latitude,
            Longitude = request.Longitude
        };
    }

    public async Task<IReadOnlyList<MyReportItemDto>> GetMyReportsAsync(Guid currentUserId)
    {
        return await _db.Reports
            .AsNoTracking()
            .Where(r => r.CreatedByUserId == currentUserId)
            .Include(r => r.ReportType)
            .Include(r => r.Municipality)
            .OrderByDescending(r => r.CreatedAtUtc)
            .Select(r => new MyReportItemDto
            {
                Id = r.Id,
                ReportTypeId = r.ReportTypeId,
                ReportTypeName = r.ReportType.Name,
                MunicipalityId = r.MunicipalityId,
                MunicipalityName = r.Municipality.Adm3Name,
                ImageUrl = r.ImageUrl,
                Description = r.Description ?? string.Empty,
                AddressDetails = r.AddressDetails,
                Status = r.Status.ToString(),
                CreatedAtUtc = r.CreatedAtUtc,
                Latitude = r.Location.Y,
                Longitude = r.Location.X
            })
            .ToListAsync();
    }
}