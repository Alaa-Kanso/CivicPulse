namespace CivicPulse.Api.Dtos.Auth;

public sealed class AuthResponseDto
{
    public string AccessToken { get; set; } = default!;
    public string RefreshToken { get; set; } = default!;

    public UserSummaryDto User { get; set; } = default!;
}
