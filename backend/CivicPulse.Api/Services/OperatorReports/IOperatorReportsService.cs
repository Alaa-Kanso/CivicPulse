using CivicPulse.Api.Dtos.OperatorReports;

namespace CivicPulse.Api.Services.OperatorReports;

public interface IOperatorReportsService
{
    Task<IReadOnlyList<OperatorReportListItemDto>> GetAssignedReportsAsync(
        Guid currentUserId,
        OperatorReportsFilterDto filter);
    Task<OperatorReportDetailsDto> GetAssignedReportByIdAsync(Guid currentUserId, Guid reportId);
    Task UpdateStatusAsync(Guid currentUserId, Guid reportId, UpdateReportStatusRequestDto request);
    Task MarkReportAsSpamAsync(Guid currentUserId, Guid reportId, MarkReportAsSpamRequestDto request);
    Task EscalateReportAsync(Guid currentUserId, Guid reportId, CreateEscalationRequestDto request);
}