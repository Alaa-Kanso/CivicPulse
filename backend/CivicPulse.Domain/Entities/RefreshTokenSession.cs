using CivicPulse.Domain.Entities;

namespace CivicPulse.Domain.Entities;

public class RefreshTokenSession
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid UserId { get; set; }
    public User User { get; set; } = default!;
    public string RefreshTokenHash { get; set; } = default!;

    public DateTime ExpiresAtUtc { get; set; }

    public DateTime? RevokedAtUtc { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
}
