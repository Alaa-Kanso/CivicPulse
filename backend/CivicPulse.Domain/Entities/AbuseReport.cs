using System.ComponentModel.DataAnnotations;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Domain.Entities;

public class AbuseReport
{
    public Guid Id { get; set; } = Guid.NewGuid();

    // The report where the issue was seen (image/content)
    [Required]
    public Guid ReportId { get; set; }
    public Report Report { get; set; } = default!;

    // The citizen being reported
    [Required]
    public Guid ReportedUserId { get; set; }
    public User ReportedUser { get; set; } = default!;

    // The operator who escalated it
    [Required]
    public Guid ReportedByOperatorId { get; set; }
    public User ReportedByOperator { get; set; } = default!;

    [Required, MaxLength(500)]
    public string Reason { get; set; } = default!;

    public AbuseReportStatus Status { get; set; } = AbuseReportStatus.Pending;

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;

    public DateTime? ReviewedAtUtc { get; set; }

    [MaxLength(1000)]
    public string? AdminNotes { get; set; }
}