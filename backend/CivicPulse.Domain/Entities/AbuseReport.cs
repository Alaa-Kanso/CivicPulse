using System.ComponentModel.DataAnnotations;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Domain.Entities;

public class AbuseReport
{
    public Guid Id { get; set; } = Guid.NewGuid();

    // Trigger report that caused the case to be created
    [Required]
    public Guid ReportId { get; set; }
    public Report Report { get; set; } = default!;

    [Required]
    public Guid ReportedUserId { get; set; }
    public User ReportedUser { get; set; } = default!;

    [Required]
    public Guid ReportedByOperatorId { get; set; }
    public User ReportedByOperator { get; set; } = default!;

    public AbuseReportType Type { get; set; } = AbuseReportType.ManualEscalation;

    [Required, MaxLength(500)]
    public string Reason { get; set; } = default!;

    public AbuseReportStatus Status { get; set; } = AbuseReportStatus.Pending;

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? ReviewedAtUtc { get; set; }

    [MaxLength(1000)]
    public string? AdminNotes { get; set; }

    public ICollection<AbuseReportEvidence> EvidenceReports { get; set; } = new List<AbuseReportEvidence>();
}