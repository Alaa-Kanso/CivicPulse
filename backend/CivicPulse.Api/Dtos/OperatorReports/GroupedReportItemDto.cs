namespace CivicPulse.Api.Dtos.OperatorReports;

public sealed class GroupedReportItemDto
{
    public Guid Id { get; set; }
    public string Status { get; set; } = string.Empty;
    public bool IsSpam { get; set; }
    public string Description { get; set; } = string.Empty;
    public DateTime CreatedAtUtc { get; set; }
    public double Latitude { get; set; }
    public double Longitude { get; set; }
}