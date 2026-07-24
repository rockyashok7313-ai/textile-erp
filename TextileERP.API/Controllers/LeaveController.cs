using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TextileERP.API.Services.Payroll;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class LeaveController : ControllerBase
{
    private readonly ILeaveService _leaveService;

    public LeaveController(ILeaveService leaveService)
    {
        _leaveService = leaveService;
    }

    [HttpGet("types/{companyId}")]
    public async Task<ActionResult<IEnumerable<TextileERP.API.Models.Payroll.LeaveType>>> GetLeaveTypes(long companyId)
    {
        var types = await _leaveService.GetLeaveTypesAsync(companyId);
        return Ok(types);
    }

    [HttpGet("balance/{employeeId}")]
    public async Task<ActionResult> GetBalance(long employeeId, [FromQuery] int year)
    {
        var balances = await _leaveService.GetBalancesByEmployeeAsync(employeeId, year);
        return Ok(balances);
    }

    [HttpPost("apply")]
    public async Task<IActionResult> ApplyLeave(
        [FromQuery] long employeeId, [FromQuery] long leaveTypeId,
        [FromQuery] decimal days, [FromQuery] int year)
    {
        try
        {
            var result = await _leaveService.ApplyLeaveAsync(employeeId, leaveTypeId, days, year);
            return Ok(result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("adjust")]
    public async Task<IActionResult> AdjustLeave(
        [FromQuery] long employeeId, [FromQuery] long leaveTypeId,
        [FromQuery] decimal days, [FromQuery] int year)
    {
        var result = await _leaveService.AdjustLeaveAsync(employeeId, leaveTypeId, days, year);
        return Ok(result);
    }
}
