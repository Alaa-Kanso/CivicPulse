using System.ComponentModel.DataAnnotations;

namespace CivicPulse.Domain.Entities;

public class EmailBan
{
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required, MaxLength(320)]
    public string Email { get; set; } = default!;

    [MaxLength(500)]
    public string? Reason { get; set; }

    [Required]
    public Guid CreatedByAdminId { get; set; }
    public User CreatedByAdmin { get; set; } = default!;

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
}