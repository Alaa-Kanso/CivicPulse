using System.ComponentModel.DataAnnotations;
using NetTopologySuite.Geometries;
namespace CivicPulse.Domain.Entities;

public class Municipality
{
    public long Id { get; set; }

    // Stable unique code from ADM3 (e.g., admin3Pcod / adm3_pcode)
    [Required, MaxLength(50)]
    public string Adm3Pcode { get; set; } = default!;

    [Required, MaxLength(200)]
    public string Adm3Name { get; set; } = default!;

    [MaxLength(50)]
    public string? Adm2Pcode { get; set; }

    [MaxLength(200)]
    public string? Adm2Name { get; set; }

    [MaxLength(50)]
    public string? Adm1Pcode { get; set; }

    [MaxLength(200)]
    public string? Adm1Name { get; set; }

    public double? CenterLat { get; set; }
    public double? CenterLon { get; set; }
    public double? AreaSqkm { get; set; }

    // Spatial boundary polygon for point-in-polygon routing
    [Required]
    public MultiPolygon Geometry { get; set; } = default!;

    // Navigation
    public ICollection<User> Operators { get; set; } = new List<User>();
    public ICollection<Report> Reports { get; set; } = new List<Report>();
}