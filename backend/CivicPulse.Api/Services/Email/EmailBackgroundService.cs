using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace CivicPulse.Api.Services.Email;

public sealed class EmailBackgroundService : BackgroundService
{
    private readonly EmailQueue _queue;
    private readonly IEmailSender _emailSender;
    private readonly ILogger<EmailBackgroundService> _logger;

    public EmailBackgroundService(
        EmailQueue queue,
        IEmailSender emailSender,
        ILogger<EmailBackgroundService> logger)
    {
        _queue = queue;
        _emailSender = emailSender;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        await foreach (var message in _queue.ReadAllAsync(stoppingToken))
        {
            try
            {
                await _emailSender.SendAsync(message, stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(
                    ex,
                    "Failed to send email to {ToEmail} with subject {Subject}",
                    message.ToEmail,
                    message.Subject);
            }
        }
    }
}