namespace CivicPulse.Api.Settings;

public sealed class StorageSettings
{
    public string BucketName { get; set; } = string.Empty;
    public string SupabaseUrl { get; set; } = string.Empty;
    public string SupabaseSecretKey { get; set; } = string.Empty;
    public int SignedUploadUrlExpiresInSeconds { get; set; } = 3600;
    public int SignedReadUrlExpiresInSeconds { get; set; } = 3600;
}