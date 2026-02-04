using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Api.Dtos.Auth;

public sealed class GoogleAuthRequestDto
{
    //Google ID token
    [Required]
    public string IdToken { get; set; } = default!;
}
