using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.Auth;

public sealed class LogoutRequestDto
{
    [Required]
    public string RefreshToken { get; set; } = string.Empty;
}