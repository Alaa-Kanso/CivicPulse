using CivicPulse.Api.Dtos.AdminRouting;

namespace CivicPulse.Api.Services.AdminRouting;

public interface IAdminRoutingService
{
    Task<IReadOnlyList<AdminRoutedReportListItemDto>> GetRoutedReportsAsync(Guid currentUserId);
    Task RerouteAsync(Guid currentUserId, Guid reportId, RerouteAdminRoutedReportRequestDto request);
    Task DeleteAsync(Guid currentUserId, Guid reportId);
    Task<IReadOnlyList<RerouteTargetMunicipalityDto>> GetRerouteTargetMunicipalitiesAsync(Guid currentUserId);
}