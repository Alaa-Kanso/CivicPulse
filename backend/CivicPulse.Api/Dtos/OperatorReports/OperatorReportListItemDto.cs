namespace CivicPulse.Api.Dtos.OperatorReports;

public sealed class OperatorReportListItemDto
{
    public Guid Id { get; set; }

    public int ReportTypeId { get; set; }
    public string ReportTypeName { get; set; } = string.Empty;

    public long MunicipalityId { get; set; }
    public string MunicipalityName { get; set; } = string.Empty;

    public string ImageKey { get; set; } = string.Empty;
    public string? ImageUrl { get; set; }

    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAtUtc { get; set; }

    public string? AddressDetails { get; set; }
    public string Description { get; set; } = string.Empty;

    public bool IsSpam { get; set; }

    public bool ReportedUserUnderReview { get; set; }
    public bool ReportedUserIsRestricted { get; set; }
    public bool HasPendingManualEscalation { get; set; }
    public bool HasPendingTooManySpamCase { get; set; }

    public Guid? ReportGroupId { get; set; }
    public int GroupedReportsCount { get; set; }
}