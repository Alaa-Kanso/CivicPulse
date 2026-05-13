using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.Uploads;

public sealed class InitReportImageUploadRequestDto
{
    [Required, MaxLength(255)]
    public string FileName { get; set; } = string.Empty;

    [Required, MaxLength(100)]
    public string ContentType { get; set; } = string.Empty;
}