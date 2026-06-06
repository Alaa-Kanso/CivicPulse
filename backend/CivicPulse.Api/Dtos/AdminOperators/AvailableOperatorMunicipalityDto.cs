namespace CivicPulse.Api.Dtos.AdminOperators;

public sealed class AvailableOperatorMunicipalityDto
{
    public long Id { get; set; }
    public string Adm3Name { get; set; } = string.Empty;
    public string Adm3Pcode { get; set; } = string.Empty;
}