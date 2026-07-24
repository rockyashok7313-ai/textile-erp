using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TextileERP.API.DTOs.Maintenance;
using TextileERP.API.Models.Maintenance;
using TextileERP.API.Services.Maintenance;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MachineController : ControllerBase
{
    private readonly IMachineService _machineService;

    public MachineController(IMachineService machineService)
    {
        _machineService = machineService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<MachineDto>>> GetAll([FromQuery] long companyId)
    {
        var machines = await _machineService.GetAllAsync(companyId);
        return Ok(machines);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<MachineDto>> GetById(long id)
    {
        var machine = await _machineService.GetByIdAsync(id);
        if (machine == null) return NotFound();
        return Ok(machine);
    }

    [HttpGet("bytype/{type}")]
    public async Task<ActionResult<IEnumerable<MachineDto>>> GetByType(string type, [FromQuery] long companyId)
    {
        var machines = await _machineService.GetByTypeAsync(type, companyId);
        return Ok(machines);
    }

    [HttpGet("bystatus/{status}")]
    public async Task<ActionResult<IEnumerable<MachineDto>>> GetByStatus(string status, [FromQuery] long companyId)
    {
        var machines = await _machineService.GetByStatusAsync(status, companyId);
        return Ok(machines);
    }

    [HttpPost]
    public async Task<ActionResult<MachineDto>> Create([FromBody] CreateMachineRequest request)
    {
        if (await _machineService.IsCodeExistsAsync(request.MachineCode, request.CompanyId))
            return BadRequest("Machine code already exists");

        var machine = new Machine
        {
            MachineCode = request.MachineCode,
            MachineName = request.MachineName,
            MachineType = request.MachineType,
            Make = request.Make,
            Model = request.Model,
            SerialNumber = request.SerialNumber,
            Capacity = request.Capacity,
            LoomCount = request.LoomCount,
            Location = request.Location,
            BayNumber = request.BayNumber,
            InstallationDate = request.InstallationDate,
            EstimatedValue = request.EstimatedValue
        };

        var created = await _machineService.CreateAsync(machine);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] Machine machine)
    {
        if (id != machine.Id) return BadRequest();
        if (await _machineService.IsCodeExistsAsync(machine.MachineCode, machine.CompanyId, id))
            return BadRequest("Machine code already exists");

        await _machineService.UpdateAsync(machine);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        await _machineService.DeleteAsync(id);
        return NoContent();
    }
}
