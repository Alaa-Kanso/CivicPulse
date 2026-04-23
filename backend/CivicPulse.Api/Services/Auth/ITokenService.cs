using CivicPulse.Domain.Entities;

namespace CivicPulse.Api.Services.Auth;

public interface ITokenService
{
    string GenerateAccessToken(User user);
    string GenerateRefreshToken();
    DateTime GetAccessTokenExpiresAtUtc();
}