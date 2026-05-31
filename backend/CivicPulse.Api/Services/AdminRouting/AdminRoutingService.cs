using CivicPulse.Api.Dtos.AdminRouting;
using CivicPulse.Api.Exceptions;
using CivicPulse.Api.Services.Uploads;
using CivicPulse.Domain.Entities;
using CivicPulse.Domain.Enums;
using CivicPulse.Infrastructure.Data;
using CivicPulse.Api.Services.ReportGrouping;
using Microsoft.EntityFrameworkCore;

namespace CivicPulse.Api.Services.AdminRouting;

public sealed class AdminRoutingService : IAdminRoutingService
{
    private readonly CivicPulseDbContext _db;
    private readonly IReportGroupingService _reportGroupingService;
    private readonly IUploadsService _uploadsService;

    public AdminRoutingService(
        CivicPulseDbContext db,
        IReportGroupingService reportGroupingService,
        IUploadsService uploadsService)
    {
        _db = db;
        _reportGroupingService = reportGroupingService;
        _uploadsService = uploadsService;
    }

    public async Task<IReadOnlyList<AdminRoutedReportListItemDto>> GetRoutedReportsAsync(Guid currentUserId)
    {
        await GetValidatedAdminAsync(currentUserId);

        var reports = await _db.Reports
            .AsNoTracking()
            .Where(r => r.RequiresAdminRouting)
            .OrderByDescending(r => r.CreatedAtUtc)
            .Select(r => new
            {
                r.Id,
                r.ReportTypeId,
                ReportTypeName = r.ReportType.Name,
                r.MunicipalityId,
                MunicipalityName = r.Municipality != null ? r.Municipality.Adm3Name : null,
                r.OriginalMunicipalityName,
                AdminRoutingReason = r.AdminRoutingReason!.ToString(),
                r.ImageKey,
                Description = r.Description ?? string.Empty,
                r.AddressDetails,
                Latitude = r.Location.Y,
                Longitude = r.Location.X,
                r.CreatedAtUtc
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

            return new AdminRoutedReportListItemDto
            {
                Id = r.Id,
                ReportTypeId = r.ReportTypeId,
                ReportTypeName = r.ReportTypeName,
                MunicipalityId = r.MunicipalityId,
                MunicipalityName = r.MunicipalityName,
                OriginalMunicipalityName = r.OriginalMunicipalityName,
                AdminRoutingReason = r.AdminRoutingReason,
                ImageKey = r.ImageKey,
                ImageUrl = imageUrl,
                Description = r.Description,
                AddressDetails = r.AddressDetails,
                Latitude = r.Latitude,
                Longitude = r.Longitude,
                CreatedAtUtc = r.CreatedAtUtc
            };
        }));

        return result;
    }

    public async Task RerouteAsync(Guid currentUserId, Guid reportId, RerouteAdminRoutedReportRequestDto request)
    {
        await GetValidatedAdminAsync(currentUserId);

        var report = await _db.Reports
            .SingleOrDefaultAsync(r => r.Id == reportId && r.RequiresAdminRouting);

        if (report is null)
            throw new NotFoundException("Admin-routed report was not found.");

        var municipality = await _db.Municipalities
            .AsNoTracking()
            .SingleOrDefaultAsync(m => m.Id == request.MunicipalityId);

        if (municipality is null)
            throw new BadRequestException("Assigned municipality was not found.");

        var hasActiveOperator = await _db.Users.AnyAsync(u =>
            u.Role == UserRole.Operator &&
            u.AssignedMunicipalityId == request.MunicipalityId &&
            u.Status == UserStatus.Active);

        if (!hasActiveOperator)
            throw new BadRequestException("Selected municipality has no active operator assigned.");

        report.MunicipalityId = municipality.Id;
        report.RequiresAdminRouting = false;
        report.AdminRoutingReason = null;
        report.OriginalMunicipalityName = municipality.Adm3Name;
        report.UpdatedAtUtc = DateTime.UtcNow;

        await _reportGroupingService.AssignGroupAsync(report);

        await _db.SaveChangesAsync();
    }

    public async Task DeleteAsync(Guid currentUserId, Guid reportId)
    {
        await GetValidatedAdminAsync(currentUserId);

        var report = await _db.Reports
            .SingleOrDefaultAsync(r => r.Id == reportId && r.RequiresAdminRouting);

        if (report is null)
            throw new NotFoundException("Admin-routed report was not found.");

        _db.Reports.Remove(report);
        await _db.SaveChangesAsync();
    }

    public async Task<IReadOnlyList<RerouteTargetMunicipalityDto>> GetRerouteTargetMunicipalitiesAsync(Guid currentUserId)
    {
        await GetValidatedAdminAsync(currentUserId);

        return await _db.Municipalities
        .AsNoTracking()
        .Where(m => _db.Users.Any(u =>
            u.Role == UserRole.Operator &&
            u.Status == UserStatus.Active &&
            u.AssignedMunicipalityId == m.Id))
        .OrderBy(m => m.Adm3Name)
        .Select(m => new RerouteTargetMunicipalityDto
        {
            Id = m.Id,
            Adm3Name = m.Adm3Name,
            Adm3Pcode = m.Adm3Pcode
        })
        .ToListAsync();
    }

    public async Task<AdminRoutedReportDetailsDto> GetRoutedReportByIdAsync(Guid currentUserId, Guid reportId)
    {
        await GetValidatedAdminAsync(currentUserId);

        var report = await _db.Reports
            .AsNoTracking()
            .Where(r => r.Id == reportId && r.RequiresAdminRouting)
            .Include(r => r.ReportType)
            .Include(r => r.Municipality)
            .SingleOrDefaultAsync();

        if (report is null)
            throw new NotFoundException("Admin-routed report was not found.");

        var imageUrl = await _uploadsService.CreateSignedReadUrlAsync(report.ImageKey);

        return new AdminRoutedReportDetailsDto
        {
            Id = report.Id,
            ReportTypeId = report.ReportTypeId,
            ReportTypeName = report.ReportType.Name,
            MunicipalityId = report.MunicipalityId,
            MunicipalityName = report.Municipality != null ? report.Municipality.Adm3Name : null,
            OriginalMunicipalityName = report.OriginalMunicipalityName,
            AdminRoutingReason = report.AdminRoutingReason!.ToString(),
            ImageKey = report.ImageKey,
            ImageUrl = imageUrl,
            Description = report.Description ?? string.Empty,
            AddressDetails = report.AddressDetails,
            CreatedAtUtc = report.CreatedAtUtc,
            UpdatedAtUtc = report.UpdatedAtUtc,
            Latitude = report.Location.Y,
            Longitude = report.Location.X
        };
    }

    private async Task<User> GetValidatedAdminAsync(Guid currentUserId)
    {
        var adminUser = await _db.Users
            .SingleOrDefaultAsync(u => u.Id == currentUserId);

        if (adminUser is null)
            throw new UnauthorizedException("User was not found.");

        if (adminUser.Role != UserRole.Admin)
            throw new ForbiddenException("Only admins can access this endpoint.");

        if (adminUser.Status == UserStatus.Banned)
            throw new ForbiddenException("Your account has been blocked.");

        return adminUser;
    }
}