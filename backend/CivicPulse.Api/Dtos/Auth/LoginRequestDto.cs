using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.Auth;

public sealed class LoginRequestDto
{
    [Required, EmailAddress, MaxLength(320)]
    public string Email { get; set; } = default!;

    [Required, MinLength(8), MaxLength(100)]
    public string Password { get; set; } = default!;
}