using CivicPulse.Api.Dtos.OperatorReports;
using CivicPulse.Api.Exceptions;
using CivicPulse.Api.Services.Uploads;
using CivicPulse.Domain.Entities;
using CivicPulse.Domain.Enums;
using CivicPulse.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CivicPulse.Api.Services.OperatorReports;

public sealed class OperatorReportsService : IOperatorReportsService
{
    private readonly CivicPulseDbContext _db;
    private readonly IUploadsService _uploadsService;
    private const int SpamStrikeRestrictionThreshold = 3;

    public OperatorReportsService(
        CivicPulseDbContext db,
        IUploadsService uploadsService)
    {
        _db = db;
        _uploadsService = uploadsService;
    }

    public async Task<IReadOnlyList<OperatorReportListItemDto>> GetAssignedReportsAsync(
        Guid currentUserId,
        OperatorReportsFilterDto filter)
    {
        var operatorUser = await GetValidatedOperatorAsync(currentUserId);

        var query = _db.Reports
            .AsNoTracking()
            .Where(r => r.MunicipalityId == operatorUser.AssignedMunicipalityId!.Value)
            .AsQueryable();

        if (filter.IsSpam.HasValue)
        {
            query = query.Where(r => r.IsSpam == filter.IsSpam.Value);
        }

        var reports = await query
            .OrderByDescending(r => r.CreatedAtUtc)
            .Select(r => new
            {
                r.Id,
                r.ReportTypeId,
                ReportTypeName = r.ReportType.Name,
                MunicipalityId = r.MunicipalityId!.Value,
                MunicipalityName = r.Municipality!.Adm3Name,
                r.ImageKey,
                Status = r.Status.ToString(),
                r.CreatedAtUtc,
                r.AddressDetails,
                Description = r.Description ?? string.Empty,
                r.IsSpam,

                ReportedUserUnderReview = _db.AbuseReports.Any(a =>
                    a.ReportedUserId == r.CreatedByUserId &&
                    a.Status == AbuseReportStatus.Pending),

                ReportedUserIsRestricted = r.CreatedByUser.Status == UserStatus.Restricted,

                HasPendingManualEscalation = _db.AbuseReports.Any(a =>
                    a.ReportedUserId == r.CreatedByUserId &&
                    a.Status == AbuseReportStatus.Pending &&
                    a.Type == AbuseReportType.ManualEscalation),

                HasPendingTooManySpamCase = _db.AbuseReports.Any(a =>
                    a.ReportedUserId == r.CreatedByUserId &&
                    a.Status == AbuseReportStatus.Pending &&
                    a.Type == AbuseReportType.TooManySpammedReports),

                r.ReportGroupId,
                GroupedReportsCount = r.ReportGroupId != null
                    ? _db.Reports.Count(x => x.ReportGroupId == r.ReportGroupId)
                    : 0
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

            return new OperatorReportListItemDto
            {
                Id = r.Id,
                ReportTypeId = r.ReportTypeId,
                ReportTypeName = r.ReportTypeName,
                MunicipalityId = r.MunicipalityId,
                MunicipalityName = r.MunicipalityName,
                ImageKey = r.ImageKey,
                ImageUrl = imageUrl,
                Status = r.Status,
                CreatedAtUtc = r.CreatedAtUtc,
                AddressDetails = r.AddressDetails,
                Description = r.Description,
                IsSpam = r.IsSpam,
                ReportedUserUnderReview = r.ReportedUserUnderReview,
                ReportedUserIsRestricted = r.ReportedUserIsRestricted,
                HasPendingManualEscalation = r.HasPendingManualEscalation,
                HasPendingTooManySpamCase = r.HasPendingTooManySpamCase,
                ReportGroupId = r.ReportGroupId,
                GroupedReportsCount = r.GroupedReportsCount
            };
        }));

        return result;
    }

    public async Task<OperatorReportDetailsDto> GetAssignedReportByIdAsync(Guid currentUserId, Guid reportId)
    {
        var operatorUser = await GetValidatedOperatorAsync(currentUserId);

        var report = await _db.Reports
            .AsNoTracking()
            .Where(r =>
                r.Id == reportId &&
                r.MunicipalityId == operatorUser.AssignedMunicipalityId!.Value)
            .Include(r => r.ReportType)
            .Include(r => r.Municipality)
            .Include(r => r.CreatedByUser)
            .SingleOrDefaultAsync();

        if (report is null)
            throw new NotFoundException("Report was not found.");

        var imageUrl = await _uploadsService.CreateSignedReadUrlAsync(report.ImageKey);

        var reportedUserUnderReview = await _db.AbuseReports
            .AnyAsync(a =>
                a.ReportedUserId == report.CreatedByUserId &&
                a.Status == AbuseReportStatus.Pending);

        var hasPendingManualEscalation = await _db.AbuseReports
            .AnyAsync(a =>
                a.ReportedUserId == report.CreatedByUserId &&
                a.Status == AbuseReportStatus.Pending &&
                a.Type == AbuseReportType.ManualEscalation);

        var hasPendingTooManySpamCase = await _db.AbuseReports
            .AnyAsync(a =>
                a.ReportedUserId == report.CreatedByUserId &&
                a.Status == AbuseReportStatus.Pending &&
                a.Type == AbuseReportType.TooManySpammedReports);

        return new OperatorReportDetailsDto
        {
            Id = report.Id,
            ReportTypeId = report.ReportTypeId,
            ReportTypeName = report.ReportType.Name,
            MunicipalityId = report.MunicipalityId!.Value,
            MunicipalityName = report.Municipality!.Adm3Name,
            ImageKey = report.ImageKey,
            ImageUrl = imageUrl,
            Description = report.Description ?? string.Empty,
            AddressDetails = report.AddressDetails,
            Status = report.Status.ToString(),
            CreatedAtUtc = report.CreatedAtUtc,
            UpdatedAtUtc = report.UpdatedAtUtc,
            Latitude = report.Location.Y,
            Longitude = report.Location.X,

            IsSpam = report.IsSpam,
            SpamReason = report.SpamReason,
            SpamMarkedAtUtc = report.SpamMarkedAtUtc,

            ReportedUserUnderReview = reportedUserUnderReview,
            ReportedUserIsRestricted = report.CreatedByUser.Status == UserStatus.Restricted,
            HasPendingManualEscalation = hasPendingManualEscalation,
            HasPendingTooManySpamCase = hasPendingTooManySpamCase,

            ReportGroupId = report.ReportGroupId,
            GroupedReportsCount = report.ReportGroupId != null
                ? await _db.Reports.CountAsync(x => x.ReportGroupId == report.ReportGroupId)
                : 0,
        };
    }

    public async Task UpdateStatusAsync(Guid currentUserId, Guid reportId, UpdateReportStatusRequestDto request)
    {
        var operatorUser = await GetValidatedOperatorAsync(currentUserId);

        var report = await _db.Reports
            .SingleOrDefaultAsync(r =>
                r.Id == reportId &&
                r.MunicipalityId == operatorUser.AssignedMunicipalityId!.Value) ?? throw new NotFoundException("Report was not found.");
                
        if (string.IsNullOrWhiteSpace(request.Status))
            throw new BadRequestException("Status is required.");

        var normalizedStatus = NormalizeStatus(request.Status);

        if (!Enum.TryParse<ReportStatus>(normalizedStatus, ignoreCase: true, out var newStatus))
            throw new BadRequestException(
                "Invalid status. Allowed values: InReview, InProgress, Resolved, Rejected.");

        if (!IsAllowedOperatorStatus(newStatus))
            throw new BadRequestException(
                "Invalid status. Allowed values: InReview, InProgress, Resolved, Rejected.");

        if (report.Status == newStatus)
            throw new BadRequestException($"Report is already in status {newStatus}.");

        if (!IsValidTransition(report.Status, newStatus))
            throw new BadRequestException(
                $"Cannot change report status from {report.Status} to {newStatus}.");

        report.Status = newStatus;
        report.UpdatedAtUtc = DateTime.UtcNow;

        await _db.SaveChangesAsync();
    }

    public async Task MarkReportAsSpamAsync(Guid currentUserId, Guid reportId, MarkReportAsSpamRequestDto request)
    {
        var operatorUser = await GetValidatedOperatorAsync(currentUserId);

        var report = await _db.Reports
            .SingleOrDefaultAsync(r =>
                r.Id == reportId &&
                r.MunicipalityId == operatorUser.AssignedMunicipalityId!.Value);

        if (report is null)
            throw new NotFoundException("Report was not found.");

        if (report.IsSpam)
            throw new BadRequestException("Report is already marked as spam.");

        if (report.Status is ReportStatus.Resolved or ReportStatus.Rejected)
            throw new BadRequestException($"Reports in status {report.Status} cannot be marked as spam.");

        if (string.IsNullOrWhiteSpace(request.Reason))
            throw new BadRequestException("Reason is required.");

        report.IsSpam = true;
        report.SpamReason = request.Reason.Trim();
        report.SpamMarkedAtUtc = DateTime.UtcNow;
        report.SpamMarkedByOperatorId = currentUserId;
        report.Status = ReportStatus.Rejected;
        report.UpdatedAtUtc = DateTime.UtcNow;

        var citizenUser = await _db.Users
            .SingleOrDefaultAsync(u => u.Id == report.CreatedByUserId);

        if (citizenUser is not null)
        {
            var previousSpamStrikes = citizenUser.SpamStrikes;
            citizenUser.SpamStrikes += 1;

            var reachedRestrictionThreshold =
                previousSpamStrikes < SpamStrikeRestrictionThreshold &&
                citizenUser.SpamStrikes >= SpamStrikeRestrictionThreshold;

            var pendingTooManySpamCase = await _db.AbuseReports
                .SingleOrDefaultAsync(a =>
                    a.ReportedUserId == citizenUser.Id &&
                    a.Status == AbuseReportStatus.Pending &&
                    a.Type == AbuseReportType.TooManySpammedReports);

            if (reachedRestrictionThreshold)
            {
                citizenUser.Status = UserStatus.Restricted;

                if (pendingTooManySpamCase is null)
                {
                    pendingTooManySpamCase = new AbuseReport
                    {
                        ReportId = report.Id,
                        ReportedUserId = citizenUser.Id,
                        ReportedByOperatorId = currentUserId,
                        Type = AbuseReportType.TooManySpammedReports,
                        Reason = "Too many spammed reports from this user.",
                        Status = AbuseReportStatus.Pending,
                        CreatedAtUtc = DateTime.UtcNow
                    };

                    _db.AbuseReports.Add(pendingTooManySpamCase);
                }
            }

            if (pendingTooManySpamCase is not null)
            {
                List<Guid> evidenceReportIds;

                if (reachedRestrictionThreshold)
                {
                    evidenceReportIds = await _db.Reports
                        .AsNoTracking()
                        .Where(r => r.CreatedByUserId == citizenUser.Id && r.IsSpam)
                        .Select(r => r.Id)
                        .ToListAsync();

                    // Include the current report explicitly because the DB query above
                    // may not yet "see" this in-memory spam update before SaveChanges.
                    evidenceReportIds.Add(report.Id);
                }
                else
                {
                    evidenceReportIds = new List<Guid> { report.Id };
                }

                await AddMissingEvidenceReportsAsync(pendingTooManySpamCase.Id, evidenceReportIds);
            }
        }

        await _db.SaveChangesAsync();
    }

    public async Task EscalateReportAsync(Guid currentUserId, Guid reportId, CreateEscalationRequestDto request)
    {
        var operatorUser = await GetValidatedOperatorAsync(currentUserId);

        var report = await _db.Reports
            .AsNoTracking()
            .SingleOrDefaultAsync(r =>
                r.Id == reportId &&
                r.MunicipalityId == operatorUser.AssignedMunicipalityId!.Value);

        if (report is null)
            throw new NotFoundException("Report was not found.");

        if (report.Status == ReportStatus.Resolved)
            throw new BadRequestException("Resolved reports cannot be escalated.");

        if (string.IsNullOrWhiteSpace(request.Reason))
            throw new BadRequestException("Reason is required.");

        var existingPendingManualCase = await _db.AbuseReports
            .AnyAsync(a =>
                a.ReportedUserId == report.CreatedByUserId &&
                a.Status == AbuseReportStatus.Pending &&
                a.Type == AbuseReportType.ManualEscalation);

        if (existingPendingManualCase)
            throw new BadRequestException("This user already has a pending manual moderation case.");

        var abuseReport = new AbuseReport
        {
            ReportId = report.Id,
            ReportedUserId = report.CreatedByUserId,
            ReportedByOperatorId = currentUserId,
            Type = AbuseReportType.ManualEscalation,
            Reason = request.Reason.Trim(),
            Status = AbuseReportStatus.Pending,
            CreatedAtUtc = DateTime.UtcNow
        };

        _db.AbuseReports.Add(abuseReport);

        await AddMissingEvidenceReportsAsync(abuseReport.Id, new[] { report.Id });

        await _db.SaveChangesAsync();
    }

    public async Task<IReadOnlyList<GroupedReportItemDto>> GetGroupedReportsAsync(Guid currentUserId, Guid reportGroupId)
    {
        var operatorUser = await GetValidatedOperatorAsync(currentUserId);

        var groupExistsInOperatorMunicipality = await _db.ReportGroups
            .AnyAsync(g =>
                g.Id == reportGroupId &&
                g.MunicipalityId == operatorUser.AssignedMunicipalityId!.Value);

        if (!groupExistsInOperatorMunicipality)
            throw new NotFoundException("Report group was not found.");

        return await _db.Reports
            .AsNoTracking()
            .Where(r => r.ReportGroupId == reportGroupId)
            .OrderByDescending(r => r.CreatedAtUtc)
            .Select(r => new GroupedReportItemDto
            {
                Id = r.Id,
                Status = r.Status.ToString(),
                IsSpam = r.IsSpam,
                Description = r.Description ?? string.Empty,
                CreatedAtUtc = r.CreatedAtUtc,
                Latitude = r.Location.Y,
                Longitude = r.Location.X
            })
            .ToListAsync();
    }

    private async Task<User> GetValidatedOperatorAsync(Guid currentUserId)
    {
        var operatorUser = await _db.Users
            .SingleOrDefaultAsync(u => u.Id == currentUserId);

        if (operatorUser is null)
            throw new UnauthorizedException("User was not found.");

        if (operatorUser.Role != UserRole.Operator)
            throw new ForbiddenException("Only operators can access this endpoint.");

        if (operatorUser.Status == UserStatus.Banned)
            throw new ForbiddenException("Your account has been blocked.");

        if (operatorUser.AssignedMunicipalityId is null)
            throw new ForbiddenException("Operator is not assigned to a municipality.");

        return operatorUser;
    }

    private static bool IsAllowedOperatorStatus(ReportStatus status)
    {
        return status is ReportStatus.InReview
            or ReportStatus.InProgress
            or ReportStatus.Resolved
            or ReportStatus.Rejected;
    }

    private static bool IsValidTransition(ReportStatus currentStatus, ReportStatus newStatus)
    {
        return currentStatus switch
        {
            ReportStatus.Submitted => newStatus is ReportStatus.InReview or ReportStatus.Rejected,
            ReportStatus.InReview => newStatus is ReportStatus.InProgress or ReportStatus.Rejected,
            ReportStatus.InProgress => newStatus is ReportStatus.Resolved or ReportStatus.Rejected,
            ReportStatus.Resolved => false,
            ReportStatus.Rejected => false,
            _ => false
        };
    }

    private static string NormalizeStatus(string status)
    {
        return status
            .Trim()
            .Replace(" ", "", StringComparison.OrdinalIgnoreCase)
            .Replace("-", "", StringComparison.OrdinalIgnoreCase)
            .Replace("_", "", StringComparison.OrdinalIgnoreCase);
    }

    private async Task AddMissingEvidenceReportsAsync(Guid abuseReportId, IEnumerable<Guid> reportIds)
    {
        var uniqueReportIds = reportIds
            .Where(id => id != Guid.Empty)
            .Distinct()
            .ToList();

        if (uniqueReportIds.Count == 0)
            return;

        var existingTracked = _db.AbuseReportEvidences.Local
            .Where(x => x.AbuseReportId == abuseReportId)
            .Select(x => x.ReportId)
            .ToHashSet();

        var existingInDatabase = await _db.AbuseReportEvidences
            .AsNoTracking()
            .Where(x => x.AbuseReportId == abuseReportId && uniqueReportIds.Contains(x.ReportId))
            .Select(x => x.ReportId)
            .ToListAsync();

        var alreadyExists = existingInDatabase
            .Concat(existingTracked)
            .ToHashSet();

        foreach (var evidenceReportId in uniqueReportIds)
        {
            if (alreadyExists.Contains(evidenceReportId))
                continue;

            _db.AbuseReportEvidences.Add(new AbuseReportEvidence
            {
                AbuseReportId = abuseReportId,
                ReportId = evidenceReportId,
                AddedAtUtc = DateTime.UtcNow
            });

            alreadyExists.Add(evidenceReportId);
        }
    }
}