using System.ComponentModel.DataAnnotations;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Api.Dtos.Auth;

public sealed class RefreshTokenRequestDto
{
    [Required]
    public string RefreshToken { get; set; } = string.Empty;

    [Required]
    public AuthClientType ClientType { get; set; }
}