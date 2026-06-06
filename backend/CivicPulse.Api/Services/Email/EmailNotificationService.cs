using System.Text.RegularExpressions;
using CivicPulse.Domain.Enums;
using CivicPulse.Domain.Entities;
using CivicPulse.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CivicPulse.Api.Services.Email;

public sealed class EmailNotificationService : IEmailNotificationService
{
    private readonly CivicPulseDbContext _db;
    private readonly IEmailQueue _emailQueue;

    public EmailNotificationService(CivicPulseDbContext db, IEmailQueue emailQueue)
    {
        _db = db;
        _emailQueue = emailQueue;
    }

    public async Task QueueNewReportNotificationAsync(Report report, CancellationToken cancellationToken = default)
    {
        if (!report.MunicipalityId.HasValue)
            return;

        var operatorEmails = await _db.Users
            .AsNoTracking()
            .Where(u =>
                u.Role == UserRole.Operator &&
                u.Status == UserStatus.Active &&
                u.AssignedMunicipalityId == report.MunicipalityId.Value)
            .Select(u => u.Email)
            .ToListAsync(cancellationToken);

        var reportTypeName = await _db.ReportTypes
            .AsNoTracking()
            .Where(rt => rt.Id == report.ReportTypeId)
            .Select(rt => rt.Name)
            .SingleOrDefaultAsync(cancellationToken);

        var formattedStatus = FormatEnumDisplay(report.Status.ToString());

        foreach (var email in operatorEmails.Distinct(StringComparer.OrdinalIgnoreCase))
        {
            await _emailQueue.QueueAsync(new EmailMessage
            {
                ToEmail = email,
                Subject = $"New report submitted: {report.Id}",
                BodyText =
                    $"A new report was submitted in your assigned municipality.\n" +
                    $"Report ID: {report.Id}\n" +
                    $"Type: {reportTypeName ?? "Unknown"}\n" +
                    $"Status: {formattedStatus}"
            }, cancellationToken);
        }
    }

    public async Task QueueReportStatusUpdatedNotificationAsync(Report report, CancellationToken cancellationToken = default)
    {
        var citizenEmail = await _db.Users
            .AsNoTracking()
            .Where(u => u.Id == report.CreatedByUserId)
            .Select(u => u.Email)
            .SingleOrDefaultAsync(cancellationToken);

        if (string.IsNullOrWhiteSpace(citizenEmail))
            return;

        var formattedStatus = FormatEnumDisplay(report.Status.ToString());

        await _emailQueue.QueueAsync(new EmailMessage
        {
            ToEmail = citizenEmail,
            Subject = "Your report status was updated",
            BodyText =
                $"Your report {report.Id} status is now {formattedStatus}."
        }, cancellationToken);
    }

    private static string FormatEnumDisplay(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
            return value;

        return Regex.Replace(value, "([a-z])([A-Z])", "$1 $2");
    }
}