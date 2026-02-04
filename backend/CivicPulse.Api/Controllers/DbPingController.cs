using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CivicPulse.Infrastructure.Data;

namespace CivicPulse.Api.Controllers;

[ApiController]
[Route("api/db-ping")]
public class DbPingController : ControllerBase
{
    private readonly CivicPulseDbContext _db;

    public DbPingController(CivicPulseDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        try
        {
            //Connectivity check
            var canConnect = await _db.Database.CanConnectAsync();

            //Ensure DB exists
            return Ok(new
            {
                status = canConnect ? "ok" : "error",
                canConnect,
                database = _db.Database.GetDbConnection().Database,
                timestampUtc = DateTime.UtcNow
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new
            {
                status = "error",
                message = "Database connection failed",
                details = ex.Message
            });
        }
    }
}
