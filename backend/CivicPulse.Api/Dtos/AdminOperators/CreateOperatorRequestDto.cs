using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.AdminOperators;

public sealed class CreateOperatorRequestDto
{
    [Required, EmailAddress, MaxLength(255)]
    public string Email { get; set; } = string.Empty;

    [Required, MinLength(8), MaxLength(100)]
    public string Password { get; set; } = string.Empty;

    [Required]
    public long AssignedMunicipalityId { get; set; }
}