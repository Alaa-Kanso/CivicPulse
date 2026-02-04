using System.ComponentModel.DataAnnotations;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Domain.Entities;

public class Report
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid CreatedByUserId { get; set; }
    public User CreatedByUser { get; set; } = default!;

    [Required, MaxLength(120)]
    public string Title { get; set; } = default!;

    [Required, MaxLength(2000)]
    public string Description { get; set; } = default!;

    [Required, MaxLength(100)]
    public string Category { get; set; } = default!;

    [Required, MaxLength(100)]
    public string City { get; set; } = default!;

    [Required, MaxLength(150)]
    public string Region { get; set; } = default!;

    [MaxLength(250)]
    public string? StreetText { get; set; }

    // Location
    public double Lat { get; set; }
    public double Lng { get; set; }

    // File storage URL
    [Required, MaxLength(1000)]
    public string PhotoUrl { get; set; } = default!;

    public ReportStatus Status { get; set; } = ReportStatus.InReview;

    public Guid? StatusUpdatedByUserId { get; set; }
    public User? StatusUpdatedByUser { get; set; }
    public DateTime? StatusUpdatedAtUtc { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAtUtc { get; set; } = DateTime.UtcNow;

    public ICollection<Notification> Notifications { get; set; } = new List<Notification>();
}
