using CivicPulse.Api.Dtos.AdminOperators;

namespace CivicPulse.Api.Services.AdminOperators;

public interface IAdminOperatorsService
{
    Task<AdminOperatorDto> CreateOperatorAsync(Guid currentUserId, CreateOperatorRequestDto request);
    Task<IReadOnlyList<AvailableOperatorMunicipalityDto>> GetAvailableMunicipalitiesAsync(Guid currentUserId);
}