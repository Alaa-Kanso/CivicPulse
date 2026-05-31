using CivicPulse.Api.Dtos.AdminOperators;
using CivicPulse.Api.Services.Security;
using CivicPulse.Api.Exceptions;
using CivicPulse.Domain.Entities;
using CivicPulse.Domain.Enums;
using CivicPulse.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CivicPulse.Api.Services.AdminOperators;

public sealed class AdminOperatorsService : IAdminOperatorsService
{
    private readonly CivicPulseDbContext _db;
    private readonly IPasswordHasher _passwordHasher;

    public AdminOperatorsService(
        CivicPulseDbContext db,
        IPasswordHasher passwordHasher)
    {
        _db = db;
        _passwordHasher = passwordHasher;
    }

    public async Task<AdminOperatorDto> CreateOperatorAsync(Guid currentUserId, CreateOperatorRequestDto request)
    {
        await GetValidatedAdminAsync(currentUserId);

        var normalizedEmail = request.Email.Trim().ToLowerInvariant();

        if (string.IsNullOrWhiteSpace(normalizedEmail))
            throw new BadRequestException("Email is required.");

        if (string.IsNullOrWhiteSpace(request.Password))
            throw new BadRequestException("Password is required.");

        if (request.Password.Length < 8)
            throw new BadRequestException("Password must be at least 8 characters.");

        var municipality = await _db.Municipalities
            .AsNoTracking()
            .SingleOrDefaultAsync(m => m.Id == request.AssignedMunicipalityId);

        if (municipality is null)
            throw new BadRequestException("Assigned municipality was not found.");

        var emailExists = await _db.Users
            .AnyAsync(u => u.Email.ToLower() == normalizedEmail);

        if (emailExists)
            throw new BadRequestException("An account with this email already exists.");

        var municipalityAlreadyHasActiveOperator = await _db.Users
            .AnyAsync(u =>
                u.Role == UserRole.Operator &&
                u.AssignedMunicipalityId == request.AssignedMunicipalityId &&
                u.Status == UserStatus.Active);

        if (municipalityAlreadyHasActiveOperator)
            throw new BadRequestException("This municipality already has an assigned operator.");

        var newOperator = new User
        {
            Email = normalizedEmail,
            PasswordHash = _passwordHasher.Hash(request.Password),
            Role = UserRole.Operator,
            Status = UserStatus.Active,
            AssignedMunicipalityId = request.AssignedMunicipalityId,
            SpamStrikes = 0,
            CreatedAtUtc = DateTime.UtcNow
        };

        _db.Users.Add(newOperator);
        await _db.SaveChangesAsync();

        return new AdminOperatorDto
        {
            Id = newOperator.Id,
            Email = newOperator.Email,
            AssignedMunicipalityId = municipality.Id,
            AssignedMunicipalityName = municipality.Adm3Name,
            Status = newOperator.Status.ToString(),
            CreatedAtUtc = newOperator.CreatedAtUtc
        };
    }

    public async Task<IReadOnlyList<AvailableOperatorMunicipalityDto>> GetAvailableMunicipalitiesAsync(Guid currentUserId)
    {
        await GetValidatedAdminAsync(currentUserId);

        return await _db.Municipalities
            .AsNoTracking()
            .Where(m => !_db.Users.Any(u =>
                u.Role == UserRole.Operator &&
                u.AssignedMunicipalityId == m.Id &&
                u.Status == UserStatus.Active))
            .OrderBy(m => m.Adm3Name)
            .Select(m => new AvailableOperatorMunicipalityDto
            {
                Id = m.Id,
                Adm3Name = m.Adm3Name,
                Adm3Pcode = m.Adm3Pcode
            })
            .ToListAsync();
    }

    private async Task<User> GetValidatedAdminAsync(Guid currentUserId)
    {
        var adminUser = await _db.Users
            .SingleOrDefaultAsync(u => u.Id == currentUserId);

        if (adminUser is null)
            throw new UnauthorizedException("User was not found.");

        if (adminUser.Role != UserRole.Admin)
            throw new ForbiddenException("Only admins can access this endpoint.");

        if (adminUser.Status == UserStatus.Banned)
            throw new ForbiddenException("Your account has been blocked.");

        return adminUser;
    }
}