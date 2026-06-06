namespace CivicPulse.Api.Services.Email;

public interface IEmailQueue
{
    ValueTask QueueAsync(EmailMessage message, CancellationToken cancellationToken = default);
}