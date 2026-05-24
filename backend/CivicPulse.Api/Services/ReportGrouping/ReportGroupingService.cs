using CivicPulse.Domain.Entities;
using CivicPulse.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Geometries;

namespace CivicPulse.Api.Services.ReportGrouping;

public sealed class ReportGroupingService : IReportGroupingService
{
    private readonly CivicPulseDbContext _db;
    private const double ReportGroupingRadiusMeters = 50;

    public ReportGroupingService(CivicPulseDbContext db)
    {
        _db = db;
    }

    public async Task AssignGroupAsync(Report report)
    {
        // Clear old group assignment first in case this is a rerouted report
        report.ReportGroup = null;
        report.ReportGroupId = null;

        if (report.RequiresAdminRouting || !report.MunicipalityId.HasValue)
            return;

        var municipalityId = report.MunicipalityId.Value;
        var reportTypeId = report.ReportTypeId;
        var point = report.Location;

        var candidateGroups = await _db.ReportGroups
            .AsNoTracking()
            .Where(g =>
                g.MunicipalityId == municipalityId &&
                g.ReportTypeId == reportTypeId)
            .Select(g => new
            {
                g.Id,
                Latitude = g.CenterLocation.Y,
                Longitude = g.CenterLocation.X
            })
            .ToListAsync();

        var nearestGroup = candidateGroups
            .Select(g => new
            {
                g.Id,
                DistanceMeters = CalculateDistanceMeters(
                    point.Y,
                    point.X,
                    g.Latitude,
                    g.Longitude)
            })
            .Where(x => x.DistanceMeters <= ReportGroupingRadiusMeters)
            .OrderBy(x => x.DistanceMeters)
            .FirstOrDefault();

        if (nearestGroup is not null)
        {
            report.ReportGroupId = nearestGroup.Id;
            return;
        }

        var newGroup = new ReportGroup
        {
            MunicipalityId = municipalityId,
            ReportTypeId = reportTypeId,
            CenterLocation = new Point(point.X, point.Y) { SRID = point.SRID },
            CreatedAtUtc = DateTime.UtcNow
        };

        _db.ReportGroups.Add(newGroup);
        report.ReportGroup = newGroup;
    }

    private static double CalculateDistanceMeters(
        double lat1,
        double lon1,
        double lat2,
        double lon2)
    {
        const double EarthRadiusMeters = 6371000;

        static double ToRadians(double degrees) => degrees * Math.PI / 180.0;

        var dLat = ToRadians(lat2 - lat1);
        var dLon = ToRadians(lon2 - lon1);

        var a =
            Math.Pow(Math.Sin(dLat / 2), 2) +
            Math.Cos(ToRadians(lat1)) *
            Math.Cos(ToRadians(lat2)) *
            Math.Pow(Math.Sin(dLon / 2), 2);

        var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
        return EarthRadiusMeters * c;
    }
}