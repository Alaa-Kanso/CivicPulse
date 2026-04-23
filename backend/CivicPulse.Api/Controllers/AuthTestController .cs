using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CivicPulse.Api.Controllers;

[ApiController]
[Route("api/auth-test")]
public class AuthTestController : ControllerBase
{
    [HttpGet("any-authenticated")]
    [Authorize]
    public IActionResult AnyAuthenticated()
    {
        return Ok(new
        {
            message = "You are authenticated.",
            userId = User.FindFirstValue(ClaimTypes.NameIdentifier),
            email = User.FindFirstValue(ClaimTypes.Email),
            role = User.FindFirstValue(ClaimTypes.Role)
        });
    }

    [HttpGet("citizen-only")]
    [Authorize(Roles = "Citizen")]
    public IActionResult CitizenOnly()
    {
        return Ok(new
        {
            message = "You are a citizen."
        });
    }

    [HttpGet("operator-or-admin")]
    [Authorize(Roles = "Operator,Admin")]
    public IActionResult OperatorOrAdmin()
    {
        return Ok(new
        {
            message = "You are an operator or admin."
        });
    }
}