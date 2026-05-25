using CivicPulse.Api.Dtos.AdminModeration;
using CivicPulse.Api.Exceptions;
using CivicPulse.Domain.Entities;
using CivicPulse.Domain.Enums;
using CivicPulse.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CivicPulse.Api.Services.AdminModeration;

public sealed class AdminModerationService : IAdminModerationService
{
    private readonly CivicPulseDbContext _db;

    public AdminModerationService(CivicPulseDbContext db)
    {
        _db = db;
    }

    public async Task<IReadOnlyList<AdminModerationCaseListItemDto>> GetPendingCasesAsync(Guid currentUserId)
    {
        await GetValidatedAdminAsync(currentUserId);

        return await _db.AbuseReports
            .AsNoTracking()
            .Where(a => a.Status == AbuseReportStatus.Pending)
            .OrderByDescending(a => a.CreatedAtUtc)
            .Select(a => new AdminModerationCaseListItemDto
            {
                Id = a.Id,
                Type = a.Type.ToString(),
                Reason = a.Reason,
                ModerationStatus = a.Status.ToString(),
                CreatedAtUtc = a.CreatedAtUtc,

                ReportedUserId = a.ReportedUserId,
                ReportedUserEmail = a.ReportedUser.Email,
                ReportedUserStatus = a.ReportedUser.Status.ToString(),
                ReportedUserSpamStrikes = a.ReportedUser.SpamStrikes,

                ReportedByOperatorId = a.ReportedByOperatorId,
                ReportedByOperatorEmail = a.ReportedByOperator.Email,

                TriggerReportId = a.ReportId,
                TriggerReportStatus = a.Report.Status.ToString(),
                TriggerMunicipalityName = a.Report.Municipality != null
                    ? a.Report.Municipality.Adm3Name
                    : a.Report.OriginalMunicipalityName,

                EvidenceReportsCount = a.EvidenceReports.Count
            })
            .ToListAsync();
    }

    public async Task<AdminModerationCaseDetailsDto> GetCaseByIdAsync(Guid currentUserId, Guid abuseReportId)
    {
        await GetValidatedAdminAsync(currentUserId);

        var abuseReport = await _db.AbuseReports
            .AsNoTracking()
            .Include(a => a.Report)
                .ThenInclude(r => r.ReportType)
            .Include(a => a.Report)
                .ThenInclude(r => r.Municipality)
            .Include(a => a.ReportedUser)
            .Include(a => a.ReportedByOperator)
            .Include(a => a.EvidenceReports)
                .ThenInclude(e => e.Report)
                    .ThenInclude(r => r.ReportType)
            .Include(a => a.EvidenceReports)
                .ThenInclude(e => e.Report)
                    .ThenInclude(r => r.Municipality)
            .SingleOrDefaultAsync(a => a.Id == abuseReportId);

        if (abuseReport is null)
            throw new NotFoundException("Moderation case was not found.");

        return new AdminModerationCaseDetailsDto
        {
            Id = abuseReport.Id,
            Type = abuseReport.Type.ToString(),
            Reason = abuseReport.Reason,
            ModerationStatus = abuseReport.Status.ToString(),
            CreatedAtUtc = abuseReport.CreatedAtUtc,
            ReviewedAtUtc = abuseReport.ReviewedAtUtc,
            AdminNotes = abuseReport.AdminNotes,

            ReportedUserId = abuseReport.ReportedUserId,
            ReportedUserEmail = abuseReport.ReportedUser.Email,
            ReportedUserStatus = abuseReport.ReportedUser.Status.ToString(),
            ReportedUserSpamStrikes = abuseReport.ReportedUser.SpamStrikes,

            ReportedByOperatorId = abuseReport.ReportedByOperatorId,
            ReportedByOperatorEmail = abuseReport.ReportedByOperator.Email,

            TriggerReportId = abuseReport.ReportId,
            TriggerReport = new ModerationEvidenceReportDto
            {
                Id = abuseReport.Report.Id,
                ReportTypeName = abuseReport.Report.ReportType.Name,
                Status = abuseReport.Report.Status.ToString(),
                IsSpam = abuseReport.Report.IsSpam,
                SpamReason = abuseReport.Report.SpamReason,
                MunicipalityName = abuseReport.Report.Municipality != null
                    ? abuseReport.Report.Municipality.Adm3Name
                    : abuseReport.Report.OriginalMunicipalityName,
                Description = abuseReport.Report.Description,
                CreatedAtUtc = abuseReport.Report.CreatedAtUtc
            },

            EvidenceReports = abuseReport.EvidenceReports
                .OrderByDescending(e => e.AddedAtUtc)
                .Select(e => new ModerationEvidenceReportDto
                {
                    Id = e.Report.Id,
                    ReportTypeName = e.Report.ReportType.Name,
                    Status = e.Report.Status.ToString(),
                    IsSpam = e.Report.IsSpam,
                    SpamReason = e.Report.SpamReason,
                    MunicipalityName = e.Report.Municipality != null
                        ? e.Report.Municipality.Adm3Name
                        : e.Report.OriginalMunicipalityName,
                    Description = e.Report.Description,
                    CreatedAtUtc = e.Report.CreatedAtUtc
                })
                .ToList()
        };
    }

    public async Task DismissCaseAsync(Guid currentUserId, Guid abuseReportId, ResolveModerationCaseRequestDto request)
    {
        await GetValidatedAdminAsync(currentUserId);

        var abuseReport = await _db.AbuseReports
            .Include(a => a.ReportedUser)
            .SingleOrDefaultAsync(a => a.Id == abuseReportId);

        if (abuseReport is null)
            throw new NotFoundException("Moderation case was not found.");

        if (abuseReport.Status != AbuseReportStatus.Pending)
            throw new BadRequestException("This moderation case is already resolved.");

        abuseReport.Status = AbuseReportStatus.Dismissed;
        abuseReport.ReviewedAtUtc = DateTime.UtcNow;
        abuseReport.AdminNotes = string.IsNullOrWhiteSpace(request.AdminNotes)
            ? null
            : request.AdminNotes.Trim();

        if (abuseReport.Type == AbuseReportType.TooManySpammedReports)
        {
            abuseReport.ReportedUser.Status = UserStatus.Active;
            abuseReport.ReportedUser.SpamStrikes = 0;
        }

        await _db.SaveChangesAsync();
    }

    public async Task BlockUserAsync(Guid currentUserId, Guid abuseReportId, ResolveModerationCaseRequestDto request)
    {
        await GetValidatedAdminAsync(currentUserId);

        var abuseReport = await _db.AbuseReports
            .Include(a => a.ReportedUser)
            .SingleOrDefaultAsync(a => a.Id == abuseReportId);

        if (abuseReport is null)
            throw new NotFoundException("Moderation case was not found.");

        if (abuseReport.Status != AbuseReportStatus.Pending)
            throw new BadRequestException("This moderation case is already resolved.");

        var userId = abuseReport.ReportedUserId;
        var now = DateTime.UtcNow;
        var primaryNotes = string.IsNullOrWhiteSpace(request.AdminNotes)
            ? null
            : request.AdminNotes.Trim();

        var pendingCasesForUser = await _db.AbuseReports
            .Where(a =>
                a.ReportedUserId == userId &&
                a.Status == AbuseReportStatus.Pending)
            .ToListAsync();

        foreach (var pendingCase in pendingCasesForUser)
        {
            pendingCase.Status = AbuseReportStatus.UserBlocked;
            pendingCase.ReviewedAtUtc = now;

            if (pendingCase.Id == abuseReportId)
            {
                pendingCase.AdminNotes = primaryNotes;
            }
            else if (string.IsNullOrWhiteSpace(pendingCase.AdminNotes))
            {
                pendingCase.AdminNotes = "Resolved because the user was blocked from a related moderation case.";
            }
        }

        abuseReport.ReportedUser.Status = UserStatus.Banned;

        await _db.SaveChangesAsync();
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