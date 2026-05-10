namespace CivicPulse.Api.Dtos.Reports;

public sealed class MyReportItemDto
{
    public Guid Id { get; set; }
    public int ReportTypeId { get; set; }
    public string ReportTypeName { get; set; } = string.Empty;

    public long MunicipalityId { get; set; }
    public string MunicipalityName { get; set; } = string.Empty;

    public string ImageUrl { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string? AddressDetails { get; set; }

    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAtUtc { get; set; }

    public double Latitude { get; set; }
    public double Longitude { get; set; }
}