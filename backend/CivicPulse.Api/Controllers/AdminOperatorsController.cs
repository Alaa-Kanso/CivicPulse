using System.Security.Claims;
using CivicPulse.Api.Dtos.AdminOperators;
using CivicPulse.Api.Dtos.Auth;
using CivicPulse.Api.Exceptions;
using CivicPulse.Api.Services.AdminOperators;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CivicPulse.Api.Controllers;

[ApiController]
[Route("api/admin/operators")]
[Authorize(Roles = "Admin")]
public class AdminOperatorsController : ControllerBase
{
    private readonly IAdminOperatorsService _adminOperatorsService;

    public AdminOperatorsController(IAdminOperatorsService adminOperatorsService)
    {
        _adminOperatorsService = adminOperatorsService;
    }

    [HttpPost]
    [ProducesResponseType(typeof(AdminOperatorDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    public async Task<ActionResult<AdminOperatorDto>> CreateOperator([FromBody] CreateOperatorRequestDto request)
    {
        try
        {
            if (!TryGetCurrentUserId(out var currentUserId))
                return Unauthorized(new ErrorResponseDto { Message = "Invalid user token." });

            var result = await _adminOperatorsService.CreateOperatorAsync(currentUserId, request);
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

    private bool TryGetCurrentUserId(out Guid currentUserId)
    {
        currentUserId = Guid.Empty;

        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out currentUserId);
    }
}