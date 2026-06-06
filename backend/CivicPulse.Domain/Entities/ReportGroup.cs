using System.ComponentModel.DataAnnotations;
using NetTopologySuite.Geometries;

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

    [Required]
    public Point CenterLocation { get; set; } = default!;

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAtUtc { get; set; }

    public ICollection<Report> Reports { get; set; } = new List<Report>();
}