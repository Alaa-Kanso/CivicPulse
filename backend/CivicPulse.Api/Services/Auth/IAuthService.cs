using CivicPulse.Api.Dtos.Auth;

namespace CivicPulse.Api.Services.Auth;

public interface IAuthService
{
    Task<AuthResponseDto> RegisterAsync(RegisterRequestDto request);

    Task<AuthResponseDto> LoginForAppAsync(LoginRequestDto request);
    Task<AuthResponseDto> LoginForWebAsync(LoginRequestDto request);

    Task<AuthResponseDto> RefreshForAppAsync(RefreshTokenRequestDto request);
    Task<AuthResponseDto> RefreshForWebAsync(RefreshTokenRequestDto request);

    Task LogoutFromAppAsync(LogoutRequestDto request);
    Task LogoutFromWebAsync(LogoutRequestDto request);
}