using System.ComponentModel.DataAnnotations;
using NetTopologySuite.Geometries;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Domain.Entities;

public class ReportGroup
{
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public int ReportTypeId { get; set; }
    public ReportType ReportType { get; set; } = default!;

    [Required]
    public long MunicipalityId { get; set; }
    public Municipality Municipality { get; set; } = default!;

    // Center point of the cluster
    [Required]
    public Point Center { get; set; } = default!;

    public double RadiusMeters { get; set; } = 50;

    public ReportStatus Status { get; set; } = ReportStatus.Submitted;

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAtUtc { get; set; }

    public ICollection<Report> Reports { get; set; } = new List<Report>();
}