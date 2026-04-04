using Microsoft.EntityFrameworkCore;
using CivicPulse.Domain.Entities;
using CivicPulse.Infrastructure.Data;

namespace CivicPulse.Api.Startup;

public static class ReportTypesSeeder
{
    public static async Task SeedAsync(IServiceProvider services)
    {
        using var scope = services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<CivicPulseDbContext>();

        var seeds = new[]
        {
            new { Name = "Pothole",       Description = "Road potholes and damaged pavement.",            SortOrder = 1 },
            new { Name = "Streetlight",   Description = "Broken or non-functioning street lighting.",    SortOrder = 2 },
            new { Name = "Blocked Sewage",Description = "Blocked sewage and overflow issues.",  SortOrder = 3 },
            new { Name = "Fallen Tree",   Description = "Fallen trees or hazardous branches on roads.",  SortOrder = 4 },
        };

        var existing = await db.ReportTypes
            .ToDictionaryAsync(rt => rt.Name.ToLower());

        var now = DateTime.UtcNow;
        var changed = false;

        foreach (var s in seeds)
        {
            var key = s.Name.ToLower();

            if (!existing.TryGetValue(key, out var rt))
            {
                db.ReportTypes.Add(new ReportType
                {
                    Name = s.Name,
                    Description = s.Description,
                    IsActive = true,
                    SortOrder = s.SortOrder,
                    CreatedAtUtc = now
                });

                changed = true;
                continue;
            }

            if (rt.Description != s.Description) { rt.Description = s.Description; changed = true; }
            if (rt.SortOrder != s.SortOrder)     { rt.SortOrder = s.SortOrder;     changed = true; }
            if (!rt.IsActive)                    { rt.IsActive = true;            changed = true; }
        }

        if (changed)
            await db.SaveChangesAsync();
    }
}