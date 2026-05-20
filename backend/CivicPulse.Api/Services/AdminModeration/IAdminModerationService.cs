using CivicPulse.Api.Dtos.AdminModeration;

namespace CivicPulse.Api.Services.AdminModeration;

public interface IAdminModerationService
{
    Task<IReadOnlyList<AdminModerationCaseListItemDto>> GetPendingCasesAsync(Guid currentUserId);
    Task<AdminModerationCaseDetailsDto> GetCaseByIdAsync(Guid currentUserId, Guid abuseReportId);
    Task DismissCaseAsync(Guid currentUserId, Guid abuseReportId, ResolveModerationCaseRequestDto request);
    Task BlockUserAsync(Guid currentUserId, Guid abuseReportId, ResolveModerationCaseRequestDto request);
}