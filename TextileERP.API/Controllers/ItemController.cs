using Microsoft.AspNetCore.Mvc;
using TextileERP.API.Models.Master;
using TextileERP.API.Repositories;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ItemController : ControllerBase
{
    private readonly IItemRepository _itemRepository;

    public ItemController(IItemRepository itemRepository)
    {
        _itemRepository = itemRepository;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Item>>> GetAll([FromQuery] long companyId)
    {
        var items = await _itemRepository.FindAsync(i => i.CompanyId == companyId);
        return Ok(items);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Item>> GetById(long id)
    {
        var item = await _itemRepository.GetByIdAsync(id);
        if (item == null) return NotFound();
        return Ok(item);
    }

    [HttpGet("bycode/{code}")]
    public async Task<ActionResult<Item>> GetByCode(string code, [FromQuery] long companyId)
    {
        var item = await _itemRepository.GetByCodeAsync(code, companyId);
        if (item == null) return NotFound();
        return Ok(item);
    }

    [HttpGet("bybarcode/{barcode}")]
    public async Task<ActionResult<Item>> GetByBarcode(string barcode, [FromQuery] long companyId)
    {
        var item = await _itemRepository.GetByBarcodeAsync(barcode, companyId);
        if (item == null) return NotFound();
        return Ok(item);
    }

    [HttpGet("bycategory/{categoryId}")]
    public async Task<ActionResult<IEnumerable<Item>>> GetByCategory(long categoryId, [FromQuery] long companyId)
    {
        var items = await _itemRepository.GetByCategoryAsync(categoryId, companyId);
        return Ok(items);
    }

    [HttpGet("textile")]
    public async Task<ActionResult<IEnumerable<Item>>> GetTextileItems([FromQuery] long companyId)
    {
        var items = await _itemRepository.GetTextileItemsAsync(companyId);
        return Ok(items);
    }

    [HttpGet("lowstock")]
    public async Task<ActionResult<IEnumerable<Item>>> GetLowStockItems([FromQuery] long companyId)
    {
        var items = await _itemRepository.GetLowStockItemsAsync(companyId);
        return Ok(items);
    }

    [HttpPost]
    public async Task<ActionResult<Item>> Create([FromBody] Item item)
    {
        if (await _itemRepository.IsCodeExistsAsync(item.ItemCode, item.CompanyId))
            return BadRequest("Item code already exists");

        var created = await _itemRepository.AddAsync(item);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] Item item)
    {
        if (id != item.Id) return BadRequest();

        if (await _itemRepository.IsCodeExistsAsync(item.ItemCode, item.CompanyId, id))
            return BadRequest("Item code already exists");

        await _itemRepository.UpdateAsync(item);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        await _itemRepository.DeleteAsync(id);
        return NoContent();
    }
}
