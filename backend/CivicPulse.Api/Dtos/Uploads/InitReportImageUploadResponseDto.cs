namespace CivicPulse.Api.Dtos.Uploads;

public sealed class InitReportImageUploadResponseDto
{
    public string ImageKey { get; set; } = string.Empty;
    public string UploadUrl { get; set; } = string.Empty;
}