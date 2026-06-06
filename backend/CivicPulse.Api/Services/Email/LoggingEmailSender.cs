using Microsoft.Extensions.Logging;

namespace CivicPulse.Api.Services.Email;

public sealed class LoggingEmailSender : IEmailSender
{
    private readonly ILogger<LoggingEmailSender> _logger;

    public LoggingEmailSender(ILogger<LoggingEmailSender> logger)
    {
        _logger = logger;
    }

    public Task SendAsync(EmailMessage message, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation(
            "EMAIL (logging sender) -> To: {ToEmail}, Subject: {Subject}, Body: {Body}",
            message.ToEmail,
            message.Subject,
            message.BodyText);

        return Task.CompletedTask;
    }
}