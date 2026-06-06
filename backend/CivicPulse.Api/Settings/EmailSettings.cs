namespace CivicPulse.Api.Settings;

public sealed class EmailSettings
{
    public bool Enabled { get; set; } = false;

    // Logging or Smtp
    public string Provider { get; set; } = "Logging";

    public string FromEmail { get; set; } = string.Empty;
    public string FromName { get; set; } = "CivicPulse";

    public string? SmtpHost { get; set; }
    public int SmtpPort { get; set; } = 25;
    public string? SmtpUsername { get; set; }
    public string? SmtpPassword { get; set; }
    public bool UseSsl { get; set; } = false;
}