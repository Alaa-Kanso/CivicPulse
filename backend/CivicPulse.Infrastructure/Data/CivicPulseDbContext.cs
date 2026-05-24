using Microsoft.EntityFrameworkCore;
using CivicPulse.Domain.Entities;

namespace CivicPulse.Infrastructure.Data;

public class CivicPulseDbContext : DbContext
{
    public CivicPulseDbContext(DbContextOptions<CivicPulseDbContext> options) : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<Municipality> Municipalities => Set<Municipality>();
    public DbSet<ReportType> ReportTypes => Set<ReportType>();
    public DbSet<Report> Reports => Set<Report>();
    public DbSet<ReportGroup> ReportGroups => Set<ReportGroup>();
    public DbSet<EmailBan> EmailBans => Set<EmailBan>();
    public DbSet<AbuseReport> AbuseReports => Set<AbuseReport>();
    public DbSet<RefreshTokenSession> RefreshTokenSessions => Set<RefreshTokenSession>();
    public DbSet<AbuseReportEvidence> AbuseReportEvidences => Set<AbuseReportEvidence>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // USERS
        modelBuilder.Entity<User>(e =>
        {
            e.HasIndex(x => x.Email).IsUnique();
            e.Property(x => x.Email).HasMaxLength(320);

            e.HasOne(x => x.AssignedMunicipality)
             .WithMany(m => m.Operators)
             .HasForeignKey(x => x.AssignedMunicipalityId)
             .OnDelete(DeleteBehavior.Restrict);
        });

        // MUNICIPALITIES
        modelBuilder.Entity<Municipality>(e =>
        {
            e.HasIndex(x => x.Adm3Pcode).IsUnique();
            e.Property(x => x.Geometry).HasColumnType("geometry(MultiPolygon,4326)");
            e.HasIndex(x => x.Geometry).HasMethod("GIST");
        });

        // REPORT TYPES
        modelBuilder.Entity<ReportType>(e =>
        {
            e.HasIndex(x => x.Name).IsUnique();
        });

        // REPORT GROUPS
        modelBuilder.Entity<ReportGroup>(e =>
        {
            e.Property(x => x.CenterLocation).HasColumnType("geometry(Point,4326)");
            e.HasIndex(x => x.CenterLocation).HasMethod("GIST");
            e.HasIndex(x => new { x.MunicipalityId, x.ReportTypeId });

            e.HasOne(x => x.Municipality)
                .WithMany(m => m.ReportGroups)
                .HasForeignKey(x => x.MunicipalityId)
                .OnDelete(DeleteBehavior.Restrict);

            e.HasOne(x => x.ReportType)
                .WithMany(rt => rt.ReportGroups)
                .HasForeignKey(x => x.ReportTypeId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // REPORTS
        modelBuilder.Entity<Report>(e =>
        {
            e.Property(x => x.Location).HasColumnType("geometry(Point,4326)");
            e.HasIndex(x => x.Location).HasMethod("GIST");

            e.HasOne(x => x.CreatedByUser)
             .WithMany(u => u.ReportsCreated)
             .HasForeignKey(x => x.CreatedByUserId)
             .OnDelete(DeleteBehavior.Restrict);

            e.HasOne(x => x.Municipality)
             .WithMany(m => m.Reports)
             .HasForeignKey(x => x.MunicipalityId)
             .OnDelete(DeleteBehavior.Restrict);

            e.HasOne(x => x.ReportType)
             .WithMany()
             .HasForeignKey(x => x.ReportTypeId)
             .OnDelete(DeleteBehavior.Restrict);

            e.HasOne(x => x.ReportGroup)
             .WithMany(g => g.Reports)
             .HasForeignKey(x => x.ReportGroupId)
             .OnDelete(DeleteBehavior.SetNull);
        });

        // EMAIL BANS
        modelBuilder.Entity<EmailBan>(e =>
        {
            e.HasIndex(x => x.Email).IsUnique();
            e.Property(x => x.Email).HasMaxLength(320);

            e.HasOne(x => x.CreatedByAdmin)
             .WithMany()
             .HasForeignKey(x => x.CreatedByAdminId)
             .OnDelete(DeleteBehavior.Restrict);
        });

        // ABUSE REPORTS
        modelBuilder.Entity<AbuseReport>(e =>
        {
            e.HasOne(x => x.Report)
                .WithMany()
                .HasForeignKey(x => x.ReportId)
                .OnDelete(DeleteBehavior.Restrict);

            e.HasOne(x => x.ReportedUser)
                .WithMany()
                .HasForeignKey(x => x.ReportedUserId)
                .OnDelete(DeleteBehavior.Restrict);

            e.HasOne(x => x.ReportedByOperator)
                .WithMany()
                .HasForeignKey(x => x.ReportedByOperatorId)
                .OnDelete(DeleteBehavior.Restrict);
        });

         // ABUSE REPORT EVIDENCE
        modelBuilder.Entity<AbuseReportEvidence>(e =>
        {
            e.HasOne(x => x.AbuseReport)
            .WithMany(x => x.EvidenceReports)
            .HasForeignKey(x => x.AbuseReportId)
            .OnDelete(DeleteBehavior.Cascade);

            e.HasOne(x => x.Report)
            .WithMany()
            .HasForeignKey(x => x.ReportId)
            .OnDelete(DeleteBehavior.Restrict);

            e.HasIndex(x => new { x.AbuseReportId, x.ReportId })
            .IsUnique();
        });

        // REFRESH TOKENS
        modelBuilder.Entity<RefreshTokenSession>(e =>
        {
            e.HasIndex(x => x.RefreshTokenHash).IsUnique();
            e.HasIndex(x => new { x.UserId, x.ClientType });

            e.HasOne(x => x.User)
            .WithMany(u => u.RefreshTokenSessions)
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);
        });
    }
}