using System.ComponentModel.DataAnnotations;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Domain.Entities;

public class RefreshTokenSession
{
     public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }
    public User User { get; set; } = default!;

    [Required, MaxLength(200)]
    public string RefreshTokenHash { get; set; } = default!;

    [Required]
    public AuthClientType ClientType { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime ExpiresAtUtc { get; set; }

    public DateTime? RevokedAtUtc { get; set; }
    public string? RevokedReason { get; set; }
}