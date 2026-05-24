using CivicPulse.Domain.Entities;

namespace CivicPulse.Api.Services.ReportGrouping;

public interface IReportGroupingService
{
    Task AssignGroupAsync(Report report);
}