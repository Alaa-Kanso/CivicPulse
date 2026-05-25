namespace CivicPulse.Api.Dtos.AdminModeration;

public sealed class ModerationEvidenceReportDto
{
    public Guid Id { get; set; }
    public string ReportTypeName { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public bool IsSpam { get; set; }
    public string? SpamReason { get; set; }
    public string? MunicipalityName { get; set; }
    public string? Description { get; set; }
    public DateTime CreatedAtUtc { get; set; }
}