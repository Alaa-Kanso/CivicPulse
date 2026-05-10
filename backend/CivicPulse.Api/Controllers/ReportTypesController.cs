using CivicPulse.Api.Dtos.Reports;
using CivicPulse.Api.Services.Reports;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CivicPulse.Api.Controllers;

[ApiController]
[Route("api/report-types")]
[Authorize]
public class ReportTypesController : ControllerBase
{
    private readonly IReportsService _reportsService;

    public ReportTypesController(IReportsService reportsService)
    {
        _reportsService = reportsService;
    }

    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<ReportTypeDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyList<ReportTypeDto>>> Get()
    {
        var result = await _reportsService.GetReportTypesAsync();
        return Ok(result);
    }
}