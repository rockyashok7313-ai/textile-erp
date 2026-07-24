using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TextileERP.API.DTOs.Payroll;
using TextileERP.API.Services.Payroll;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PayrollController : ControllerBase
{
    private readonly IPayrollService _payrollService;

    public PayrollController(IPayrollService payrollService)
    {
        _payrollService = payrollService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<PayrollDto>>> GetAll([FromQuery] long companyId)
    {
        var payrolls = await _payrollService.GetAllAsync(companyId);
        return Ok(payrolls);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<PayrollDto>> GetById(long id)
    {
        var payroll = await _payrollService.GetByIdAsync(id);
        if (payroll == null) return NotFound();
        return Ok(payroll);
    }

    [HttpPost("process")]
    public async Task<ActionResult<PayrollDto>> ProcessPayroll([FromBody] ProcessPayrollRequest request)
    {
        try
        {
            var payroll = await _payrollService.ProcessPayrollAsync(request.CompanyId, request.PeriodId);
            return CreatedAtAction(nameof(GetById), new { id = payroll.Id }, payroll);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("{id}/approve")]
    public async Task<IActionResult> Approve(long id)
    {
        try
        {
            await _payrollService.ApprovePayrollAsync(id, 0); // TODO: Get userId from claims
            return Ok(new { message = "Payroll approved successfully" });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("{id}/cancel")]
    public async Task<IActionResult> Cancel(long id, [FromBody] string reason)
    {
        try
        {
            await _payrollService.CancelPayrollAsync(id, 0, reason);
            return Ok(new { message = "Payroll cancelled" });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }
}
