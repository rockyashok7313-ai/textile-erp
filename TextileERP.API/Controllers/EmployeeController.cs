using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TextileERP.API.DTOs.Payroll;
using TextileERP.API.Models.Payroll;
using TextileERP.API.Services.Payroll;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class EmployeeController : ControllerBase
{
    private readonly IEmployeeService _employeeService;

    public EmployeeController(IEmployeeService employeeService)
    {
        _employeeService = employeeService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<EmployeeDto>>> GetAll([FromQuery] long companyId)
    {
        var employees = await _employeeService.GetAllAsync(companyId);
        return Ok(employees);
    }

    [HttpGet("active")]
    public async Task<ActionResult<IEnumerable<EmployeeDto>>> GetActive([FromQuery] long companyId)
    {
        var employees = await _employeeService.GetActiveEmployeesAsync(companyId);
        return Ok(employees);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<EmployeeDto>> GetById(long id)
    {
        var employee = await _employeeService.GetByIdAsync(id);
        if (employee == null) return NotFound();
        return Ok(employee);
    }

    [HttpGet("bydepartment/{departmentId}")]
    public async Task<ActionResult<IEnumerable<EmployeeDto>>> GetByDepartment(long departmentId)
    {
        var employees = await _employeeService.GetByDepartmentAsync(departmentId);
        return Ok(employees);
    }

    [HttpPost]
    public async Task<ActionResult<EmployeeDto>> Create([FromBody] CreateEmployeeRequest request)
    {
        if (await _employeeService.IsCodeExistsAsync(request.EmployeeCode, request.CompanyId))
            return BadRequest("Employee code already exists");

        var employee = new Employee
        {
            EmployeeCode = request.EmployeeCode,
            FirstName = request.FirstName,
            LastName = request.LastName,
            MiddleName = request.MiddleName,
            FatherName = request.FatherName,
            DateOfBirth = request.DateOfBirth,
            DateOfJoining = request.DateOfJoining,
            Gender = request.Gender,
            DepartmentId = request.DepartmentId,
            DesignationId = request.DesignationId,
            EmploymentType = request.EmploymentType,
            PAN = request.PAN,
            AadhaarNumber = request.AadhaarNumber,
            PFNumber = request.PFNumber,
            ESINumber = request.ESINumber,
            UAN = request.UAN,
            IsPFApplicable = request.IsPFApplicable,
            IsESIApplicable = request.IsESIApplicable,
            IsPTApplicable = request.IsPTApplicable,
            Mobile = request.Mobile,
            PersonalEmail = request.PersonalEmail,
            BankName = request.BankName,
            BankIFSC = request.BankIFSC,
            BankAccountNumber = request.BankAccountNumber,
            BasicSalary = request.BasicSalary,
            HRA = request.HRA,
            DA = request.DA,
            ConveyanceAllowance = request.ConveyanceAllowance,
            MedicalAllowance = request.MedicalAllowance,
            SpecialAllowance = request.SpecialAllowance,
            OtherAllowance = request.OtherAllowance
        };

        var created = await _employeeService.CreateAsync(employee);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] Employee employee)
    {
        if (id != employee.Id) return BadRequest();
        if (await _employeeService.IsCodeExistsAsync(employee.EmployeeCode, employee.CompanyId, id))
            return BadRequest("Employee code already exists");

        await _employeeService.UpdateAsync(employee);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        await _employeeService.DeleteAsync(id);
        return NoContent();
    }
}
