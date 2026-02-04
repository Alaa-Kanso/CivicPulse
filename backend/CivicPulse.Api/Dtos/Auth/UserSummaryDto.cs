namespace CivicPulse.Api.Dtos.Auth;

public sealed class UserSummaryDto
{
    public Guid Id { get; set; }

    public string Email { get; set; } = default!;
    public string Role { get; set; } = default!;    // "Citizen" || "Operator" || "Admin"
    public string Status { get; set; } = default!;  // "Active" || "Blocked"
}
