using CivicPulse.Domain.Entities;

namespace CivicPulse.Api.Services.Email;

public interface IEmailNotificationService
{
    Task QueueNewReportNotificationAsync(Report report, CancellationToken cancellationToken = default);
    Task QueueReportStatusUpdatedNotificationAsync(Report report, CancellationToken cancellationToken = default);
}