using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.OperatorReports;

public sealed class UpdateReportStatusRequestDto
{
    [Required]
    public string Status { get; set; } = string.Empty;
}