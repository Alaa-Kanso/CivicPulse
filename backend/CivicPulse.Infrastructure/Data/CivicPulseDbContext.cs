using Microsoft.EntityFrameworkCore;
using CivicPulse.Domain.Entities;

namespace  CivicPulse.Infrastructure.Data;

public class CivicPulseDbContext : DbContext
{
    public CivicPulseDbContext(DbContextOptions<CivicPulseDbContext> options) : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<Report> Reports => Set<Report>();
    public DbSet<Notification> Notifications => Set<Notification>();
    public DbSet<RefreshTokenSession> RefreshTokenSessions => Set<RefreshTokenSession>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // -------------------------
        // USER
        // -------------------------
        modelBuilder.Entity<User>(e =>
        {
            e.HasIndex(x => x.Email).IsUnique();

            // Unique GoogleSubjectId only when not null
            e.HasIndex(x => x.GoogleSubjectId)
             .IsUnique()
             .HasFilter("\"GoogleSubjectId\" IS NOT NULL");

            e.HasIndex(x => new { x.Role, x.AssignedCity, x.AssignedRegion });

            e.Property(x => x.Email).HasMaxLength(320);
        });

        // -------------------------
        // REPORT
        // -------------------------
        modelBuilder.Entity<Report>(e =>
        {
            e.HasOne(r => r.CreatedByUser)
             .WithMany(u => u.ReportsCreated)
             .HasForeignKey(r => r.CreatedByUserId)
             .OnDelete(DeleteBehavior.Restrict);

            e.HasOne(r => r.StatusUpdatedByUser)
             .WithMany()
             .HasForeignKey(r => r.StatusUpdatedByUserId)
             .OnDelete(DeleteBehavior.Restrict);

            // Citizen "My reports" list
            e.HasIndex(r => new { r.CreatedByUserId, r.CreatedAtUtc });

            // Operator regional queue
            e.HasIndex(r => new { r.City, r.Region, r.Status, r.CreatedAtUtc });

            // to filter by status only
            e.HasIndex(r => new { r.Status, r.CreatedAtUtc });
        });

        // -------------------------
        // NOTIFICATION
        // -------------------------
        modelBuilder.Entity<Notification>(e =>
        {
            e.HasOne(n => n.User)
             .WithMany(u => u.Notifications)
             .HasForeignKey(n => n.UserId)
             .OnDelete(DeleteBehavior.Cascade);

            e.HasOne(n => n.Report)
             .WithMany(r => r.Notifications)
             .HasForeignKey(n => n.ReportId)
             .OnDelete(DeleteBehavior.Cascade);

            // Fetch user's notifications newest first
            e.HasIndex(n => new { n.UserId, n.CreatedAtUtc });

            // Unread filter/count
            e.HasIndex(n => new { n.UserId, n.IsRead, n.CreatedAtUtc });
        });

        // -------------------------
        // REFRESH TOKEN SESSION
        // -------------------------
        modelBuilder.Entity<RefreshTokenSession>(e =>
        {
            e.HasOne(s => s.User)
             .WithMany(u => u.RefreshTokenSessions)
             .HasForeignKey(s => s.UserId)
             .OnDelete(DeleteBehavior.Cascade);

            e.HasIndex(s => new { s.UserId });

            //useful during refresh
            e.HasIndex(s => new { s.RefreshTokenHash }).IsUnique(false);
        });

        base.OnModelCreating(modelBuilder);
    }
}
