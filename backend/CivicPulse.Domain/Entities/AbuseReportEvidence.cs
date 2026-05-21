using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Domain.Entities;

public class AbuseReportEvidence
{
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid AbuseReportId { get; set; }
    public AbuseReport AbuseReport { get; set; } = default!;

    [Required]
    public Guid ReportId { get; set; }
    public Report Report { get; set; } = default!;

    public DateTime AddedAtUtc { get; set; } = DateTime.UtcNow;
}