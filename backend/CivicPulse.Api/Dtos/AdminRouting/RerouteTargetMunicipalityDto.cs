namespace CivicPulse.Api.Dtos.AdminRouting;

public sealed class RerouteTargetMunicipalityDto
{
    public long Id { get; set; }
    public string Adm3Name { get; set; } = string.Empty;
    public string Adm3Pcode { get; set; } = string.Empty;
}