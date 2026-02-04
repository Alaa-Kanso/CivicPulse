namespace CivicPulse.Domain.Enums;

public enum UserRole { Citizen = 0, Operator = 1, Admin = 2 }
public enum UserStatus { Active = 0, Blocked = 1 }
public enum AuthProvider { Local = 0, Google = 1 }

public enum ReportStatus { InReview = 0, InProgress = 1, Done = 2, Spam = 3 }

public enum NotificationType { StatusChanged = 0 }