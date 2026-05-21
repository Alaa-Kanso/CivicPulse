namespace CivicPulse.Api.Dtos.AdminRouting;

public sealed class AdminRoutedReportListItemDto
{
    public Guid Id { get; set; }

    public int ReportTypeId { get; set; }
    public string ReportTypeName { get; set; } = string.Empty;

    public long? MunicipalityId { get; set; }
    public string? MunicipalityName { get; set; }
    public string? OriginalMunicipalityName { get; set; }

    public string AdminRoutingReason { get; set; } = string.Empty;

    public string ImageKey { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string? AddressDetails { get; set; }

    public double Latitude { get; set; }
    public double Longitude { get; set; }

    public DateTime CreatedAtUtc { get; set; }
}