using System.ComponentModel.DataAnnotations;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Domain.Entities;

public class User
{
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required, MaxLength(320)]
    public string Email { get; set; } = default!;

    [Required]
    public string PasswordHash { get; set; } = default!;

    public UserRole Role { get; set; } = UserRole.Citizen;
    public UserStatus Status { get; set; } = UserStatus.Active;

    public int SpamStrikes { get; set; } = 0;

    public long? AssignedMunicipalityId { get; set; }
    public Municipality? AssignedMunicipality { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? LastLoginAtUtc { get; set; }

    // Navigation
    public ICollection<Report> ReportsCreated { get; set; } = new List<Report>();
    public ICollection<RefreshTokenSession> RefreshTokenSessions { get; set; } = new List<RefreshTokenSession>();
}