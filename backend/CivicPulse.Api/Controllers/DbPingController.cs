using CivicPulse.Infrastructure.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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
        var canConnect = await _db.Database.CanConnectAsync();
        var municipalities = await _db.Municipalities.CountAsync();
        var reports = await _db.Reports.CountAsync();

        return Ok(new { canConnect, municipalities, reports });
    }
}