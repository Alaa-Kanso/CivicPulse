using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.OperatorReports;

public sealed class CreateEscalationRequestDto
{
    [Required, MaxLength(500)]
    public string Reason { get; set; } = string.Empty;
}