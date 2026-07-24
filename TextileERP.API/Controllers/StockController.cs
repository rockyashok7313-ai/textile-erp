using Microsoft.AspNetCore.Mvc;
using TextileERP.API.Repositories;
using TextileERP.API.Services;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StockController : ControllerBase
{
    private readonly IStockRepository _stockRepository;
    private readonly IStockService _stockService;

    public StockController(IStockRepository stockRepository, IStockService stockService)
    {
        _stockRepository = stockRepository;
        _stockService = stockService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Models.Inventory.StockSummary>>> GetAll([FromQuery] long companyId, [FromQuery] long? itemId = null, [FromQuery] long? godownId = null)
    {
        if (itemId.HasValue)
        {
            var stockByItem = await _stockRepository.GetStockByItemAsync(companyId, itemId.Value);
            return Ok(stockByItem);
        }
        if (godownId.HasValue)
        {
            var stockByGodown = await _stockRepository.GetStockByGodownAsync(companyId, godownId.Value);
            return Ok(stockByGodown);
        }
        var stock = await _stockRepository.FindAsync(s => s.CompanyId == companyId);
        return Ok(stock);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Models.Inventory.StockSummary>> GetById(long id)
    {
        var stock = await _stockRepository.GetByIdAsync(id);
        if (stock == null) return NotFound();
        return Ok(stock);
    }

    [HttpGet("byitem/{itemId}")]
    public async Task<ActionResult<IEnumerable<Models.Inventory.StockSummary>>> GetByItem(long itemId, [FromQuery] long companyId)
    {
        var stock = await _stockRepository.GetStockByItemAsync(companyId, itemId);
        return Ok(stock);
    }

    [HttpGet("lowstock")]
    public async Task<ActionResult<IEnumerable<Models.Inventory.StockSummary>>> GetLowStock([FromQuery] long companyId)
    {
        var stock = await _stockRepository.GetLowStockItemsAsync(companyId);
        return Ok(stock);
    }

    [HttpPost("update")]
    public async Task<IActionResult> UpdateStock([FromBody] StockUpdateRequest request)
    {
        await _stockService.UpdateStockAsync(
            request.CompanyId, 
            request.ItemId, 
            request.GodownId, 
            request.Quantity, 
            request.TransactionType, 
            request.Rate);
        
        return Ok(new { message = "Stock updated successfully" });
    }
}

public class StockUpdateRequest
{
    public long CompanyId { get; set; }
    public long ItemId { get; set; }
    public long GodownId { get; set; }
    public decimal Quantity { get; set; }
    public string TransactionType { get; set; } = string.Empty; // Inward, Outward
    public decimal Rate { get; set; }
}
