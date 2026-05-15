using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using CivicPulse.Api.Dtos.Uploads;
using CivicPulse.Api.Exceptions;
using CivicPulse.Api.Settings;
using CivicPulse.Domain.Enums;
using CivicPulse.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace CivicPulse.Api.Services.Uploads;

public sealed class UploadsService : IUploadsService
{
    private static readonly HashSet<string> AllowedContentTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        "image/jpeg",
        "image/png",
        "image/webp"
    };

    private readonly CivicPulseDbContext _db;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly StorageSettings _storageSettings;

    public UploadsService(
        CivicPulseDbContext db,
        IHttpClientFactory httpClientFactory,
        IOptions<StorageSettings> storageOptions)
    {
        _db = db;
        _httpClientFactory = httpClientFactory;
        _storageSettings = storageOptions.Value;
    }

    public async Task<InitReportImageUploadResponseDto> InitReportImageUploadAsync(
        Guid currentUserId,
        InitReportImageUploadRequestDto request)
    {
        var user = await _db.Users
            .AsNoTracking()
            .SingleOrDefaultAsync(u => u.Id == currentUserId);

        if (user is null)
            throw new UnauthorizedException("User was not found.");

        if (user.Role != UserRole.Citizen)
            throw new ForbiddenException("Only citizens can upload report images.");

        if (user.Status == UserStatus.Banned)
            throw new ForbiddenException("Your account has been blocked.");

        if (!AllowedContentTypes.Contains(request.ContentType))
            throw new BadRequestException("Unsupported image type.");

        var extension = GetSafeExtension(request.FileName, request.ContentType);
        var imageKey = $"reports/{currentUserId}/{Guid.NewGuid():N}{extension}";

        var uploadUrl = await CreateSignedUploadUrlAsync(imageKey);

        return new InitReportImageUploadResponseDto
        {
            ImageKey = imageKey,
            UploadUrl = uploadUrl
        };
    }

    private async Task<string> CreateSignedUploadUrlAsync(string imageKey)
    {
        var client = _httpClientFactory.CreateClient();

        client.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue("Bearer", _storageSettings.SupabaseSecretKey);

        client.DefaultRequestHeaders.Add("apikey", _storageSettings.SupabaseSecretKey);

        var requestUrl =
            $"{_storageSettings.SupabaseUrl.TrimEnd('/')}/storage/v1/object/upload/sign/{_storageSettings.BucketName}/{imageKey}";

        var payload = new
        {
            upsert = false
        };

        var json = JsonSerializer.Serialize(payload);
        using var content = new StringContent(json, Encoding.UTF8, "application/json");

        using var response = await client.PostAsync(requestUrl, content);
        var responseBody = await response.Content.ReadAsStringAsync();

        if (!response.IsSuccessStatusCode)
            throw new InvalidOperationException(
                $"Supabase signed upload URL creation failed. Status: {(int)response.StatusCode}. Body: {responseBody}");

        var result = JsonSerializer.Deserialize<CreateSignedUploadUrlResult>(
            responseBody,
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

        if (result is null || string.IsNullOrWhiteSpace(result.Url))
            throw new InvalidOperationException($"Supabase did not return an upload URL. Raw body: {responseBody}");

        // full upload URL the client can use directly.
        return $"{_storageSettings.SupabaseUrl.TrimEnd('/')}/storage/v1{result.Url}";
    }

    private static string GetSafeExtension(string fileName, string contentType)
    {
        var extension = Path.GetExtension(fileName)?.ToLowerInvariant();

        if (!string.IsNullOrWhiteSpace(extension))
        {
            if (extension is ".jpg" or ".jpeg" or ".png" or ".webp")
                return extension == ".jpeg" ? ".jpg" : extension;
        }

        return contentType.ToLowerInvariant() switch
        {
            "image/jpeg" => ".jpg",
            "image/png" => ".png",
            "image/webp" => ".webp",
            _ => throw new BadRequestException("Unsupported image type.")
        };
    }

    private sealed class CreateSignedUploadUrlResult
    {
        public string Url { get; set; } = string.Empty;
        public string Token { get; set; } = string.Empty;
    }
}