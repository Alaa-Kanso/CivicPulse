using CivicPulse.Api.Dtos.Uploads;

namespace CivicPulse.Api.Services.Uploads;

public interface IUploadsService
{
    Task<InitReportImageUploadResponseDto> InitReportImageUploadAsync(
        Guid currentUserId,
        InitReportImageUploadRequestDto request);
}