using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TextileERP.API.DTOs.Maintenance;
using TextileERP.API.Models.Maintenance;
using TextileERP.API.Services.Maintenance;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class DowntimeController : ControllerBase
{
    private readonly IDowntimeService _downtimeService;

    public DowntimeController(IDowntimeService downtimeService)
    {
        _downtimeService = downtimeService;
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<DowntimeDto>> GetById(long id)
    {
        var log = await _downtimeService.GetByIdAsync(id);
        if (log == null) return NotFound();
        return Ok(log);
    }

    [HttpGet("bymachine/{machineId}")]
    public async Task<ActionResult<IEnumerable<DowntimeDto>>> GetByMachine(
        long machineId, [FromQuery] DateTime fromDate, [FromQuery] DateTime toDate)
    {
        var logs = await _downtimeService.GetByMachineAsync(machineId, fromDate, toDate);
        return Ok(logs);
    }

    [HttpGet("active/{machineId}")]
    public async Task<ActionResult<DowntimeDto>> GetActiveDowntime(long machineId)
    {
        var log = await _downtimeService.GetActiveDowntimeAsync(machineId);
        if (log == null) return NotFound(new { message = "No active downtime for this machine" });
        return Ok(log);
    }

    [HttpGet("summary/{machineId}")]
    public async Task<ActionResult> GetDowntimeSummary(
        long machineId, [FromQuery] int month, [FromQuery] int year)
    {
        var totalHours = await _downtimeService.GetTotalDowntimeHoursAsync(machineId, month, year);
        return Ok(new { machineId, month, year, totalDowntimeHours = totalHours });
    }

    [HttpPost("start")]
    public async Task<ActionResult<DowntimeDto>> StartDowntime([FromBody] StartDowntimeRequest request)
    {
        var log = new DowntimeLog
        {
            MachineId = request.MachineId,
            CompanyId = request.CompanyId,
            Reason = request.Reason,
            Category = request.Category,
            IsPlanned = request.IsPlanned,
            WorkOrderId = request.WorkOrderId,
            EstimatedCostImpact = request.EstimatedCostImpact
        };

        var result = await _downtimeService.StartDowntimeAsync(log);
        return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
    }

    [HttpPost("end/{id}")]
    public async Task<IActionResult> EndDowntime(long id)
    {
        try
        {
            var result = await _downtimeService.EndDowntimeAsync(id);
            return Ok(result);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }
}
