using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Domain.Entities;

public class ReportType
{
    public int Id { get; set; }

    [Required, MaxLength(100)]
    public string Name { get; set; } = default!;

    [MaxLength(200)]
    public string? Description { get; set; }

    public bool IsActive { get; set; } = true;

    public int SortOrder { get; set; } = 0;

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public ICollection<ReportGroup> ReportGroups { get; set; } = new List<ReportGroup>();
}