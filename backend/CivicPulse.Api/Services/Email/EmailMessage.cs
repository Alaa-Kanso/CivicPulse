namespace CivicPulse.Api.Services.Email;

public sealed class EmailMessage
{
    public string ToEmail { get; set; } = string.Empty;
    public string Subject { get; set; } = string.Empty;
    public string BodyText { get; set; } = string.Empty;
}