using System.Net;
using System.Net.Mail;
using CivicPulse.Api.Settings;
using Microsoft.Extensions.Options;

namespace CivicPulse.Api.Services.Email;

public sealed class SmtpEmailSender : IEmailSender
{
    private readonly EmailSettings _settings;

    public SmtpEmailSender(IOptions<EmailSettings> options)
    {
        _settings = options.Value;
    }

    public async Task SendAsync(EmailMessage message, CancellationToken cancellationToken = default)
    {
        if (!_settings.Enabled)
            return;

        if (string.IsNullOrWhiteSpace(_settings.SmtpHost))
            throw new InvalidOperationException("Email SMTP host is not configured.");

        if (string.IsNullOrWhiteSpace(_settings.FromEmail))
            throw new InvalidOperationException("Email FromEmail is not configured.");

        using var smtpClient = new SmtpClient(_settings.SmtpHost, _settings.SmtpPort)
        {
            EnableSsl = _settings.UseSsl
        };

        if (!string.IsNullOrWhiteSpace(_settings.SmtpUsername))
        {
            smtpClient.Credentials = new NetworkCredential(
                _settings.SmtpUsername,
                _settings.SmtpPassword);
        }

        using var mailMessage = new MailMessage
        {
            From = new MailAddress(_settings.FromEmail, _settings.FromName),
            Subject = message.Subject,
            Body = message.BodyText
        };

        mailMessage.To.Add(message.ToEmail);

        await smtpClient.SendMailAsync(mailMessage, cancellationToken);
    }
}