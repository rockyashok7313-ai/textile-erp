using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TextileERP.API.DTOs.Payroll;
using TextileERP.API.Services.Payroll;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AttendanceController : ControllerBase
{
    private readonly IAttendanceService _attendanceService;

    public AttendanceController(IAttendanceService attendanceService)
    {
        _attendanceService = attendanceService;
    }

    [HttpGet("employee/{employeeId}")]
    public async Task<ActionResult<IEnumerable<AttendanceDto>>> GetByEmployee(
        long employeeId, [FromQuery] DateTime fromDate, [FromQuery] DateTime toDate)
    {
        var attendance = await _attendanceService.GetByEmployeeAsync(employeeId, fromDate, toDate);
        return Ok(attendance);
    }

    [HttpGet("date")]
    public async Task<ActionResult<IEnumerable<AttendanceDto>>> GetByDate(
        [FromQuery] long companyId, [FromQuery] DateTime date)
    {
        var attendance = await _attendanceService.GetByDateAsync(companyId, date);
        return Ok(attendance);
    }

    [HttpPost]
    public async Task<ActionResult<AttendanceDto>> MarkAttendance([FromBody] MarkAttendanceRequest request)
    {
        try
        {
            var attendance = new TextileERP.API.Models.Payroll.Attendance
            {
                EmployeeId = request.EmployeeId,
                AttendanceDate = request.AttendanceDate,
                Status = request.Status,
                HalfDayType = request.HalfDayType,
                InTime = request.InTime,
                OutTime = request.OutTime,
                OvertimeHours = request.OvertimeHours,
                Remarks = request.Remarks
            };

            var result = await _attendanceService.MarkAttendanceAsync(attendance);
            return CreatedAtAction(nameof(GetByEmployee), new { employeeId = result.EmployeeId }, result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet("summary/{employeeId}")]
    public async Task<ActionResult> GetSummary(
        long employeeId, [FromQuery] int month, [FromQuery] int year)
    {
        var present = await _attendanceService.GetPresentDaysAsync(employeeId, month, year);
        var absent = await _attendanceService.GetAbsentDaysAsync(employeeId, month, year);
        var overtime = await _attendanceService.GetOvertimeHoursAsync(employeeId, month, year);

        return Ok(new
        {
            employeeId,
            month,
            year,
            daysPresent = present,
            daysAbsent = absent,
            overtimeHours = overtime
        });
    }
}
