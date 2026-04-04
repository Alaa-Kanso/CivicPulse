using System.ComponentModel.DataAnnotations;
using NetTopologySuite.Geometries;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Domain.Entities;

public class Report
{
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid CreatedByUserId { get; set; }
    public User CreatedByUser { get; set; } = default!;

    [Required]
    public int ReportTypeId { get; set; }
    public ReportType ReportType { get; set; } = default!;

    // Location pin
    [Required]
    public Point Location { get; set; } = default!;

    [Required, MaxLength(1000)]
    public string ImageUrl { get; set; } = default!;

    [Required]
    public long MunicipalityId { get; set; }
    public Municipality Municipality { get; set; } = default!;

    [MaxLength(300)]
    public string? AddressDetails { get; set; }

    [MaxLength(2000)]
    public string? Description { get; set; }

    public ReportStatus Status { get; set; } = ReportStatus.Submitted;

    // Aggregation (50m)
    public Guid? ReportGroupId { get; set; }
    public ReportGroup? ReportGroup { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAtUtc { get; set; }
}