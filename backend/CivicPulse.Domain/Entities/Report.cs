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

    [Required]
    public Point Location { get; set; } = default!;

    [Required, MaxLength(1000)]
    public string ImageKey { get; set; } = default!;

    // Nullable because admin-routed reports may not yet have a supported municipality assigned
    public long? MunicipalityId { get; set; }
    public Municipality? Municipality { get; set; }

    [MaxLength(300)]
    public string? AddressDetails { get; set; }

    [MaxLength(2000)]
    public string? Description { get; set; }

    public ReportStatus Status { get; set; } = ReportStatus.Submitted;

    public bool IsSpam { get; set; } = false;

    [MaxLength(500)]
    public string? SpamReason { get; set; }
    public DateTime? SpamMarkedAtUtc { get; set; }
    public Guid? SpamMarkedByOperatorId { get; set; }

    // Admin routing queue
    public bool RequiresAdminRouting { get; set; } = false;
    public AdminRoutingReason? AdminRoutingReason { get; set; }

    [MaxLength(200)]
    public string? OriginalMunicipalityName { get; set; }

    public Guid? ReportGroupId { get; set; }
    public ReportGroup? ReportGroup { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAtUtc { get; set; }
}