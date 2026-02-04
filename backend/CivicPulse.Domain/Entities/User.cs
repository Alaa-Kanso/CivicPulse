using System.ComponentModel.DataAnnotations;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Domain.Entities;

public class User
{
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required, MaxLength(320)]
    public string Email { get; set; } = default!;

    // For Local auth, null for Google-only users
    public string? PasswordHash { get; set; }

    public UserRole Role { get; set; } = UserRole.Citizen;
    public UserStatus Status { get; set; } = UserStatus.Active;

    // Citizen only
    public int SpamStrikes { get; set; } = 0;

    // Operator only
    [MaxLength(100)]
    public string? AssignedCity { get; set; }

    [MaxLength(150)]
    public string? AssignedRegion { get; set; }

    // Auth provider support
    public AuthProvider AuthProvider { get; set; } = AuthProvider.Local;

    // Google "sub" (unique per Google account), only if Google user
    [MaxLength(200)]
    public string? GoogleSubjectId { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? LastLoginAtUtc { get; set; }

    public ICollection<Report> ReportsCreated { get; set; } = new List<Report>();
    public ICollection<Notification> Notifications { get; set; } = new List<Notification>();
    public ICollection<RefreshTokenSession> RefreshTokenSessions { get; set; } = new List<RefreshTokenSession>();
}
