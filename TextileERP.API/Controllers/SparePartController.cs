using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TextileERP.API.DTOs.Maintenance;
using TextileERP.API.Models.Maintenance;
using TextileERP.API.Services.Maintenance;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class SparePartController : ControllerBase
{
    private readonly ISparePartService _sparePartService;

    public SparePartController(ISparePartService sparePartService)
    {
        _sparePartService = sparePartService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<SparePartDto>>> GetAll([FromQuery] long companyId)
    {
        var parts = await _sparePartService.GetAllAsync(companyId);
        return Ok(parts);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<SparePartDto>> GetById(long id)
    {
        var part = await _sparePartService.GetByIdAsync(id);
        if (part == null) return NotFound();
        return Ok(part);
    }

    [HttpGet("bycategory/{category}")]
    public async Task<ActionResult<IEnumerable<SparePartDto>>> GetByCategory(string category, [FromQuery] long companyId)
    {
        var parts = await _sparePartService.GetByCategoryAsync(category, companyId);
        return Ok(parts);
    }

    [HttpGet("lowstock")]
    public async Task<ActionResult<IEnumerable<SparePartDto>>> GetLowStock([FromQuery] long companyId)
    {
        var parts = await _sparePartService.GetLowStockPartsAsync(companyId);
        return Ok(parts);
    }

    [HttpPost]
    public async Task<ActionResult<SparePartDto>> Create([FromBody] CreateSparePartRequest request)
    {
        if (await _sparePartService.IsCodeExistsAsync(request.SparePartCode, request.CompanyId))
            return BadRequest("Spare part code already exists");

        var part = new SparePart
        {
            SparePartCode = request.SparePartCode,
            SparePartName = request.SparePartName,
            Description = request.Description,
            Category = request.Category,
            UnitId = request.UnitId,
            MinStock = request.MinStock,
            MaxStock = request.MaxStock,
            ReorderLevel = request.ReorderLevel,
            UnitCost = request.UnitCost,
            LeadTimeDays = request.LeadTimeDays,
            CompatibleMachineTypes = request.CompatibleMachineTypes,
            Manufacturer = request.Manufacturer,
            PartNumber = request.PartNumber,
            IsCriticalSpare = request.IsCriticalSpare
        };

        var created = await _sparePartService.CreateAsync(part);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] SparePart part)
    {
        if (id != part.Id) return BadRequest();
        if (await _sparePartService.IsCodeExistsAsync(part.SparePartCode, part.CompanyId, id))
            return BadRequest("Spare part code already exists");

        await _sparePartService.UpdateAsync(part);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        await _sparePartService.DeleteAsync(id);
        return NoContent();
    }

    [HttpPost("{id}/consume")]
    public async Task<IActionResult> ConsumeStock(long id, [FromQuery] decimal quantity)
    {
        try
        {
            await _sparePartService.ConsumeStockAsync(id, quantity);
            return Ok(new { message = "Stock consumed successfully" });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("{id}/restock")]
    public async Task<IActionResult> Restock(long id, [FromQuery] decimal quantity)
    {
        await _sparePartService.RestockAsync(id, quantity);
        return Ok(new { message = "Stock restocked successfully" });
    }
}
