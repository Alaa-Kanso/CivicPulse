using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.Reports;

public sealed class CreateReportRequestDto
{
    [Required]
    public int ReportTypeId { get; set; }

    [Required]
    public double Latitude { get; set; }

    [Required]
    public double Longitude { get; set; }

    [Required, MaxLength(1000)]
    public string ImageUrl { get; set; } = string.Empty;

    [Required, MaxLength(2000)]
    public string Description { get; set; } = string.Empty;

    [MaxLength(300)]
    public string? AddressDetails { get; set; }
}