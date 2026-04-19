using CivicPulse.Api.Dtos.Auth;
using CivicPulse.Api.Exceptions;
using CivicPulse.Api.Services.Auth;
using Microsoft.AspNetCore.Mvc;

namespace CivicPulse.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("register")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status409Conflict)]
    public async Task<ActionResult<AuthResponseDto>> Register([FromBody] RegisterRequestDto request)
    {
        try
        {
            var response = await _authService.RegisterAsync(request);
            return Ok(response);
        }
        catch (ConflictException ex)
        {
            return Conflict(new ErrorResponseDto { Message = ex.Message });
        }
        catch (ForbiddenException ex)
        {
            return StatusCode(StatusCodes.Status403Forbidden, new ErrorResponseDto { Message = ex.Message });
        }
    }

    [HttpPost("app/login")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    public async Task<ActionResult<AuthResponseDto>> LoginForApp([FromBody] LoginRequestDto request)
    {
        try
        {
            var response = await _authService.LoginForAppAsync(request);
            return Ok(response);
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

    [HttpPost("web/login")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    public async Task<ActionResult<AuthResponseDto>> LoginForWeb([FromBody] LoginRequestDto request)
    {
        try
        {
            var response = await _authService.LoginForWebAsync(request);
            return Ok(response);
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

    [HttpPost("app/refresh")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    public async Task<ActionResult<AuthResponseDto>> RefreshForApp([FromBody] RefreshTokenRequestDto request)
    {
        try
        {
            var response = await _authService.RefreshForAppAsync(request);
            return Ok(response);
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

    [HttpPost("web/refresh")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status403Forbidden)]
    public async Task<ActionResult<AuthResponseDto>> RefreshForWeb([FromBody] RefreshTokenRequestDto request)
    {
        try
        {
            var response = await _authService.RefreshForWebAsync(request);
            return Ok(response);
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

    [HttpPost("app/logout")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> LogoutFromApp([FromBody] LogoutRequestDto request)
    {
        await _authService.LogoutFromAppAsync(request);
        return NoContent();
    }

    [HttpPost("web/logout")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ErrorResponseDto), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> LogoutFromWeb([FromBody] LogoutRequestDto request)
    {
        await _authService.LogoutFromWebAsync(request);
        return NoContent();
    }
}