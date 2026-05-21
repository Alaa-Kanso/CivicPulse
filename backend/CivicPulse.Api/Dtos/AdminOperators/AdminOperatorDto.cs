namespace CivicPulse.Api.Dtos.AdminOperators;

public sealed class AdminOperatorDto
{
    public Guid Id { get; set; }
    public string Email { get; set; } = string.Empty;

    public long AssignedMunicipalityId { get; set; }
    public string AssignedMunicipalityName { get; set; } = string.Empty;

    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAtUtc { get; set; }
}