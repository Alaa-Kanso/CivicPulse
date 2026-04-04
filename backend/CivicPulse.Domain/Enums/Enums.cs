namespace CivicPulse.Domain.Enums;

public enum UserRole
{
    Citizen = 0,
    Operator = 1,
    Admin = 2
}

public enum UserStatus
{
    Active = 0,
    Restricted = 1, //strikes (spams)
    Banned = 2  //blocked
}

public enum ReportStatus
{
    Submitted = 0,
    InReview = 1,
    InProgress = 2,
    Resolved = 3,
    Rejected = 4
}

public enum AbuseReportStatus
{
    Pending = 0,     // waiting admin review
    ActionTaken = 1, // admin banned user
    Dismissed = 2    // admin decided it wasn't abuse
}