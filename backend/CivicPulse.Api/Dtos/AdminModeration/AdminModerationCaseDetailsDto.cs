namespace CivicPulse.Api.Dtos.AdminModeration;

public sealed class AdminModerationCaseDetailsDto
{
    public Guid Id { get; set; }
    public string Type { get; set; } = string.Empty;
    public string Reason { get; set; } = string.Empty;
    public string ModerationStatus { get; set; } = string.Empty;
    public DateTime CreatedAtUtc { get; set; }
    public DateTime? ReviewedAtUtc { get; set; }
    public string? AdminNotes { get; set; }

    public Guid ReportedUserId { get; set; }
    public string ReportedUserEmail { get; set; } = string.Empty;
    public string ReportedUserStatus { get; set; } = string.Empty;
    public int ReportedUserSpamStrikes { get; set; }

    public Guid ReportedByOperatorId { get; set; }
    public string ReportedByOperatorEmail { get; set; } = string.Empty;

    public Guid TriggerReportId { get; set; }
    public ModerationEvidenceReportDto TriggerReport { get; set; } = default!;

    public IReadOnlyList<ModerationEvidenceReportDto> EvidenceReports { get; set; } = [];
}