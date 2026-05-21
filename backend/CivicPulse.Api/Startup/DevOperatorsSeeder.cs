using CivicPulse.Domain.Entities;
using CivicPulse.Domain.Enums;
using CivicPulse.Infrastructure.Data;
using CivicPulse.Api.Services.Security;
using CivicPulse.Api.Settings;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace CivicPulse.Api.Startup;

public static class DevOperatorsSeeder
{
    private sealed record OperatorSeed(
        string Email,
        long MunicipalityId);

    private static readonly OperatorSeed[] Seeds =
    [
        new("operator.marfaa@test.com", 1),
        new("operator.saifeh@test.com", 2),
        new("operator.ainelmreisseh@test.com", 3),
        new("operator.remeil@test.com", 4),
        new("operator.rasbeyrouth@test.com", 6),
        new("operator.medawar@test.com", 7),
        new("operator.zoukakelblatt@test.com", 13),
        new("operator.beirutcentral@test.com", 15)
    ];

    public static async Task SeedAsync(IServiceProvider services)
    {
        using var scope = services.CreateScope();

        var db = scope.ServiceProvider.GetRequiredService<CivicPulseDbContext>();
        var passwordHasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher>();
        var settings = scope.ServiceProvider.GetRequiredService<IOptions<DevOperatorSeedSettings>>().Value;

        if (string.IsNullOrWhiteSpace(settings.DefaultPassword))
            throw new InvalidOperationException("Dev operator seed password is missing. Set DevOperatorSeed:DefaultPassword in development config or user secrets.");

        foreach (var seed in Seeds)
        {
            var municipalityExists = await db.Municipalities
                .AsNoTracking()
                .AnyAsync(m => m.Id == seed.MunicipalityId);

            if (!municipalityExists)
                continue;

            var existingUser = await db.Users
                .SingleOrDefaultAsync(u => u.Email == seed.Email);

            if (existingUser is not null)
                continue;

            var municipalityAlreadyHasActiveOperator = await db.Users
                .AnyAsync(u =>
                    u.Role == UserRole.Operator &&
                    u.AssignedMunicipalityId == seed.MunicipalityId &&
                    u.Status == UserStatus.Active);

            if (municipalityAlreadyHasActiveOperator)
                continue;

            var user = new User
            {
                Email = seed.Email,
                PasswordHash = passwordHasher.Hash(settings.DefaultPassword),
                Role = UserRole.Operator,
                Status = UserStatus.Active,
                AssignedMunicipalityId = seed.MunicipalityId,
                SpamStrikes = 0,
                CreatedAtUtc = DateTime.UtcNow
            };

            db.Users.Add(user);
        }

        await db.SaveChangesAsync();
    }
}