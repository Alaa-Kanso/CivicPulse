using System.Security.Claims;
using CivicPulse.Api.Dtos.Auth;
using CivicPulse.Api.Dtos.Uploads;
using CivicPulse.Api.Exceptions;
using CivicPulse.Api.Services.Uploads;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CivicPulse.Api.Controllers;

[ApiController]
[Route("api/uploads")]
[Authorize(Roles = "Citizen")]
public class UploadsController : ControllerBase
{
    private readonly IUploadsService _uploadsService;

    public UploadsController(IUploadsService uploadsService)
    {
        _uploadsService = uploadsService;
    }

    [HttpPost("report-image/init")]
    [ProducesResponseType(typeof(InitReportImageUploadResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult<InitReportImageUploadResponseDto>> InitReportImageUpload(
        [FromBody] InitReportImageUploadRequestDto request)
    {
        try
        {
            if (!TryGetCurrentUserId(out var currentUserId))
                return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

            var response = await _uploadsService.InitReportImageUploadAsync(currentUserId, request);
            return Ok(response);
        }
        catch (BadRequestException ex)
        {
            return BadRequest(new ErrorResponseDto { Message = ex.Message });
        }
        catch (UnauthorizedException ex)
        {
            return Unauthorized(new ErrorResponseDto { Message = ex.Message });
        }
        catch (ForbiddenException ex)
        {
            return StatusCode(StatusCodes.Status403Forbidden, new ErrorResponseDto { Message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return StatusCode(StatusCodes.Status500InternalServerError,
                new ErrorResponseDto { Message = ex.Message });
        }
    }

    private bool TryGetCurrentUserId(out Guid currentUserId)
    {
        currentUserId = Guid.Empty;

        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out currentUserId);
    }
}