using System.Security.Cryptography;
using System.Text;
using CivicPulse.Api.Dtos.Auth;
using CivicPulse.Api.Exceptions;
using CivicPulse.Api.Services.Security;
using CivicPulse.Api.Settings;
using CivicPulse.Domain.Entities;
using CivicPulse.Domain.Enums;
using CivicPulse.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace CivicPulse.Api.Services.Auth;

public sealed class AuthService : IAuthService
{
    private readonly CivicPulseDbContext _db;
    private readonly IPasswordHasher _passwordHasher;
    private readonly ITokenService _tokenService;
    private readonly JwtSettings _jwtSettings;

    public AuthService(
        CivicPulseDbContext db,
        IPasswordHasher passwordHasher,
        ITokenService tokenService,
        IOptions<JwtSettings> jwtOptions)
    {
        _db = db;
        _passwordHasher = passwordHasher;
        _tokenService = tokenService;
        _jwtSettings = jwtOptions.Value;
    }

    public Task<AuthResponseDto> RegisterAsync(RegisterRequestDto request)
        => RegisterInternalAsync(request);

    public Task<AuthResponseDto> LoginAsync(LoginRequestDto request)
        => LoginInternalAsync(request, request.ClientType);

    public Task<AuthResponseDto> RefreshTokenAsync(RefreshTokenRequestDto request)
        => RefreshInternalAsync(request, request.ClientType);

    public Task LogoutAsync(LogoutRequestDto request)
        => LogoutInternalAsync(request, request.ClientType);

    private async Task<AuthResponseDto> RegisterInternalAsync(RegisterRequestDto request)
    {
        if (request.ClientType != AuthClientType.App)
            throw new ForbiddenException("Registration is only available through the app.");
    
        var email = NormalizeEmail(request.Email);

        var userExists = await _db.Users.AnyAsync(u => u.Email == email);
        if (userExists)
            throw new ConflictException("An account with this email already exists.");

        var bannedEmail = await _db.EmailBans.AnyAsync(b => b.Email == email);
        if (bannedEmail)
            throw new ForbiddenException("This email is not allowed to register.");

        var now = DateTime.UtcNow;

        var user = new User
        {
            Email = email,
            PasswordHash = _passwordHasher.Hash(request.Password),
            Role = UserRole.Citizen,
            Status = UserStatus.Active,
            CreatedAtUtc = now,
            LastLoginAtUtc = now
        };

        _db.Users.Add(user);

        var response = IssueAuthTokens(user, request.ClientType);

        await _db.SaveChangesAsync();
        return response;
    }

    private async Task<AuthResponseDto> LoginInternalAsync(
        LoginRequestDto request,
        AuthClientType clientType)
    {
        var email = NormalizeEmail(request.Email);

        var user = await _db.Users.SingleOrDefaultAsync(u => u.Email == email);

        if (user is null || !_passwordHasher.Verify(request.Password, user.PasswordHash))
            throw new UnauthorizedException("Invalid email or password.");

        if (user.Status == UserStatus.Banned)
            throw new ForbiddenException("Your account has been blocked.");

        EnforceClientAccess(user, clientType);

        user.LastLoginAtUtc = DateTime.UtcNow;

        var response = IssueAuthTokens(user, clientType);

        await _db.SaveChangesAsync();
        return response;
    }

    private async Task<AuthResponseDto> RefreshInternalAsync(
        RefreshTokenRequestDto request,
        AuthClientType clientType)
    {
        var refreshTokenHash = HashRefreshToken(request.RefreshToken);

        var session = await _db.RefreshTokenSessions
            .Include(s => s.User)
            .SingleOrDefaultAsync(s =>
                s.RefreshTokenHash == refreshTokenHash &&
                s.ClientType == clientType);

        if (session is null || session.RevokedAtUtc is not null || session.ExpiresAtUtc <= DateTime.UtcNow)
            throw new UnauthorizedException("Invalid or expired refresh token.");

        if (session.User.Status == UserStatus.Banned)
            throw new ForbiddenException("Your account has been blocked.");

        EnforceClientAccess(session.User, clientType);

        session.RevokedAtUtc = DateTime.UtcNow;
        session.RevokedReason = "Refresh token rotated";

        session.User.LastLoginAtUtc = DateTime.UtcNow;

        var response = IssueAuthTokens(session.User, clientType);

        await _db.SaveChangesAsync();
        return response;
    }

    private async Task LogoutInternalAsync(
        LogoutRequestDto request,
        AuthClientType clientType)
    {
        var refreshTokenHash = HashRefreshToken(request.RefreshToken);

        var session = await _db.RefreshTokenSessions
            .SingleOrDefaultAsync(s =>
                s.RefreshTokenHash == refreshTokenHash &&
                s.ClientType == clientType);

        if (session is null || session.RevokedAtUtc is not null)
            return;

        session.RevokedAtUtc = DateTime.UtcNow;
        session.RevokedReason = "User logged out";

        await _db.SaveChangesAsync();
    }

    private AuthResponseDto IssueAuthTokens(
        User user,
        AuthClientType clientType)
    {
        var now = DateTime.UtcNow;
        var accessTokenExpiresAtUtc = _tokenService.GetAccessTokenExpiresAtUtc();
        var accessToken = _tokenService.GenerateAccessToken(user);
        var refreshToken = _tokenService.GenerateRefreshToken();

        var refreshSession = new RefreshTokenSession
        {
            UserId = user.Id,
            RefreshTokenHash = HashRefreshToken(refreshToken),
            ClientType = clientType,
            CreatedAtUtc = now,
            ExpiresAtUtc = now.AddDays(_jwtSettings.RefreshTokenDays)
        };

        _db.RefreshTokenSessions.Add(refreshSession);

        return new AuthResponseDto
        {
            AccessToken = accessToken,
            RefreshToken = refreshToken,
            AccessTokenExpiresAtUtc = accessTokenExpiresAtUtc
        };
    }

    private static void EnforceClientAccess(User user, AuthClientType clientType)
    {
        var appAllowed = user.Role == UserRole.Citizen;
        var webAllowed = user.Role == UserRole.Operator || user.Role == UserRole.Admin;

        if (clientType == AuthClientType.App && !appAllowed)
            throw new ForbiddenException("This account is not allowed to log in on the app.");

        if (clientType == AuthClientType.Web && !webAllowed)
            throw new ForbiddenException("This account is not allowed to log in on the web portal.");
    }

    private static string NormalizeEmail(string email)
        => email.Trim().ToLowerInvariant();

    private static string HashRefreshToken(string refreshToken)
    {
        var bytes = SHA256.HashData(Encoding.UTF8.GetBytes(refreshToken));
        return Convert.ToHexString(bytes);
    }
}