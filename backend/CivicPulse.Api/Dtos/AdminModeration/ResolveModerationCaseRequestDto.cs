using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.AdminModeration;

public sealed class ResolveModerationCaseRequestDto
{
    [MaxLength(1000)]
    public string? AdminNotes { get; set; }
}