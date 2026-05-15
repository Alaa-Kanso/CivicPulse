using System.Security.Claims;
using CivicPulse.Api.Dtos.Auth;
using CivicPulse.Api.Dtos.Reports;
using CivicPulse.Api.Exceptions;
using CivicPulse.Api.Services.Reports;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CivicPulse.Api.Controllers;

[ApiController]
[Route("api/reports")]
[Authorize(Roles = "Citizen")]
public class ReportsController : ControllerBase
{
    private readonly IReportsService _reportsService;

    public ReportsController(IReportsService reportsService)
    {
        _reportsService = reportsService;
    }

    [HttpPost]
    [ProducesResponseType(typeof(MyReportItemDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    public async Task<ActionResult<MyReportItemDto>> Create([FromBody] CreateReportRequestDto request)
    {
        try
        {
            if (!TryGetCurrentUserId(out var currentUserId))
                return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

            var result = await _reportsService.CreateAsync(currentUserId, request);
            return Ok(result);
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
    }

    [HttpGet("my")]
    [ProducesResponseType(typeof(IReadOnlyList<MyReportItemDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<IReadOnlyList<MyReportItemDto>>> GetMyReports()
    {
        if (!TryGetCurrentUserId(out var currentUserId))
            return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

        var result = await _reportsService.GetMyReportsAsync(currentUserId);
        return Ok(result);
    }

    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(ReportDetailsDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ReportDetailsDto>> GetById(Guid id)
    {
        try
        {
            if (!TryGetCurrentUserId(out var currentUserId))
                return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

            var result = await _reportsService.GetByIdAsync(currentUserId, id);
            return Ok(result);
        }
        catch (StorageObjectNotFoundException ex)
        {
            return NotFound(new ErrorResponseDto { Message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return StatusCode(StatusCodes.Status500InternalServerError,
                new ErrorResponseDto { Message = "Failed to generate image access URL." });
        }
    }

    private bool TryGetCurrentUserId(out Guid currentUserId)
    {
        currentUserId = Guid.Empty;

        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out currentUserId);
    }
}