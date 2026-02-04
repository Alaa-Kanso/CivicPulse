using System.ComponentModel.DataAnnotations;
using CivicPulse.Domain.Enums;

namespace CivicPulse.Domain.Entities;

public class Notification
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid UserId { get; set; }
    public User User { get; set; } = default!;

    public Guid ReportId { get; set; }
    public Report Report { get; set; } = default!;

    public NotificationType Type { get; set; } = NotificationType.StatusChanged;

    [Required, MaxLength(300)]
    public string Message { get; set; } = default!;

    public bool IsRead { get; set; } = false;

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
}
