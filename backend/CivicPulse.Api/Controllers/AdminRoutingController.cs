using System.Security.Claims;
using CivicPulse.Api.Dtos.AdminRouting;
using CivicPulse.Api.Dtos.Auth;
using CivicPulse.Api.Exceptions;
using CivicPulse.Api.Services.AdminRouting;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CivicPulse.Api.Controllers;

[ApiController]
[Route("api/admin/unmapped-reports")]
[Authorize(Roles = "Admin")]
public class AdminRoutingController : ControllerBase
{
    private readonly IAdminRoutingService _adminRoutingService;

    public AdminRoutingController(IAdminRoutingService adminRoutingService)
    {
        _adminRoutingService = adminRoutingService;
    }

    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<AdminRoutedReportListItemDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    public async Task<ActionResult<IReadOnlyList<AdminRoutedReportListItemDto>>> GetRoutedReports()
    {
        try
        {
            if (!TryGetCurrentUserId(out var currentUserId))
                return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

            var result = await _adminRoutingService.GetRoutedReportsAsync(currentUserId);
            return Ok(result);
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

    [HttpPatch("{id:guid}/reroute")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Reroute(Guid id, [FromBody] RerouteAdminRoutedReportRequestDto request)
    {
        try
        {
            if (!TryGetCurrentUserId(out var currentUserId))
                return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

            await _adminRoutingService.RerouteAsync(currentUserId, id, request);
            return NoContent();
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
        catch (NotFoundException ex)
        {
            return NotFound(new ErrorResponseDto { Message = ex.Message });
        }
    }

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        try
        {
            if (!TryGetCurrentUserId(out var currentUserId))
                return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

            await _adminRoutingService.DeleteAsync(currentUserId, id);
            return NoContent();
        }
        catch (UnauthorizedException ex)
        {
            return Unauthorized(new ErrorResponseDto { Message = ex.Message });
        }
        catch (ForbiddenException ex)
        {
            return StatusCode(StatusCodes.Status403Forbidden, new ErrorResponseDto { Message = ex.Message });
        }
        catch (NotFoundException ex)
        {
            return NotFound(new ErrorResponseDto { Message = ex.Message });
        }
    }

    [HttpGet("/api/admin/reroute-target-municipalities")]
    [ProducesResponseType(typeof(IReadOnlyList<RerouteTargetMunicipalityDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    public async Task<ActionResult<IReadOnlyList<RerouteTargetMunicipalityDto>>> GetRerouteTargetMunicipalities()
    {
        try
        {
            if (!TryGetCurrentUserId(out var currentUserId))
                return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

            var result = await _adminRoutingService.GetRerouteTargetMunicipalitiesAsync(currentUserId);
            return Ok(result);
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

    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(AdminRoutedReportDetailsDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<AdminRoutedReportDetailsDto>> GetRoutedReportById(Guid id)
    {
        try
        {
            if (!TryGetCurrentUserId(out var currentUserId))
                return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

            var result = await _adminRoutingService.GetRoutedReportByIdAsync(currentUserId, id);
            return Ok(result);
        }
        catch (UnauthorizedException ex)
        {
            return Unauthorized(new ErrorResponseDto { Message = ex.Message });
        }
        catch (ForbiddenException ex)
        {
            return StatusCode(StatusCodes.Status403Forbidden, new ErrorResponseDto { Message = ex.Message });
        }
        catch (NotFoundException ex)
        {
            return NotFound(new ErrorResponseDto { Message = ex.Message });
        }
        catch (StorageObjectNotFoundException ex)
        {
            return NotFound(new ErrorResponseDto { Message = ex.Message });
        }
        catch (InvalidOperationException)
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