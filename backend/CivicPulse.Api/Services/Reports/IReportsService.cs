using CivicPulse.Api.Dtos.Reports;

namespace CivicPulse.Api.Services.Reports;

public interface IReportsService
{
    Task<IReadOnlyList<ReportTypeDto>> GetReportTypesAsync();
    Task<MyReportItemDto> CreateAsync(Guid currentUserId, CreateReportRequestDto request);
    Task<IReadOnlyList<MyReportItemDto>> GetMyReportsAsync(Guid currentUserId);
    Task<ReportDetailsDto> GetByIdAsync(Guid currentUserId, Guid reportId);
}