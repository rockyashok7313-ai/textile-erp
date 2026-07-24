using Microsoft.AspNetCore.Mvc;
using TextileERP.API.Models.Purchase;
using TextileERP.API.Repositories;
using TextileERP.API.Services;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PurchaseInvoiceController : ControllerBase
{
    private readonly IPurchaseInvoiceRepository _invoiceRepository;
    private readonly IGSTService _gstService;
    private readonly IStockService _stockService;
    private readonly IDocumentNumberService _documentNumberService;

    public PurchaseInvoiceController(
        IPurchaseInvoiceRepository invoiceRepository,
        IGSTService gstService,
        IStockService stockService,
        IDocumentNumberService documentNumberService)
    {
        _invoiceRepository = invoiceRepository;
        _gstService = gstService;
        _stockService = stockService;
        _documentNumberService = documentNumberService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<PurchaseInvoice>>> GetAll([FromQuery] long companyId, [FromQuery] DateTime? fromDate = null, [FromQuery] DateTime? toDate = null)
    {
        if (fromDate.HasValue && toDate.HasValue)
        {
            var invoices = await _invoiceRepository.GetByDateRangeAsync(companyId, fromDate.Value, toDate.Value);
            return Ok(invoices);
        }
        var allInvoices = await _invoiceRepository.FindAsync(i => i.CompanyId == companyId);
        return Ok(allInvoices);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<PurchaseInvoice>> GetById(long id)
    {
        var invoice = await _invoiceRepository.GetWithDetailsAsync(id);
        if (invoice == null) return NotFound();
        return Ok(invoice);
    }

    [HttpGet("bynumber/{number}")]
    public async Task<ActionResult<PurchaseInvoice>> GetByNumber(string number, [FromQuery] long companyId)
    {
        var invoice = await _invoiceRepository.GetByNumberAsync(number, companyId);
        if (invoice == null) return NotFound();
        return Ok(invoice);
    }

    [HttpGet("bysupplier/{supplierId}")]
    public async Task<ActionResult<IEnumerable<PurchaseInvoice>>> GetBySupplier(long supplierId, [FromQuery] long companyId)
    {
        var invoices = await _invoiceRepository.GetBySupplierAsync(supplierId, companyId);
        return Ok(invoices);
    }

    [HttpPost]
    public async Task<ActionResult<PurchaseInvoice>> Create([FromBody] PurchaseInvoice invoice)
    {
        // Generate invoice number
        var invoiceNumber = await _documentNumberService.GetNextDocumentNumberAsync(
            invoice.CompanyId, "PurchaseInvoice", DateTime.Now.ToString("yyyy-yy"));
        
        invoice.InvoiceNumber = invoiceNumber;
        invoice.InvoiceStatus = "Draft";

        // Calculate GST for each detail
        if (invoice.Details != null)
        {
            foreach (var detail in invoice.Details)
            {
                var (cgst, sgst, igst) = await _gstService.CalculateGSTAsync(
                    invoice.CompanyId, invoice.SupplierStateCode, detail.BasicAmount, detail.GSTRate);
                
                detail.CGSTAmount = cgst;
                detail.SGSTAmount = sgst;
                detail.IGSTAmount = igst;
                detail.TaxableAmount = detail.BasicAmount;
                detail.TotalAmount = detail.BasicAmount + cgst + sgst + igst + detail.CessAmount;
            }

            // Calculate totals
            invoice.TotalQuantity = invoice.Details.Sum(d => d.Quantity);
            invoice.TotalAmount = invoice.Details.Sum(d => d.BasicAmount);
            invoice.TotalTaxableAmount = invoice.Details.Sum(d => d.TaxableAmount);
            invoice.TotalCGST = invoice.Details.Sum(d => d.CGSTAmount);
            invoice.TotalSGST = invoice.Details.Sum(d => d.SGSTAmount);
            invoice.TotalIGST = invoice.Details.Sum(d => d.IGSTAmount);
            invoice.TotalCess = invoice.Details.Sum(d => d.CessAmount);
            invoice.NetAmount = invoice.Details.Sum(d => d.TotalAmount);
        }

        var created = await _invoiceRepository.AddAsync(invoice);
        return CreatedAtAction(nameof(GetById), new { id = created.PurchaseInvoiceId }, created);
    }

    [HttpPost("{id}/post")]
    public async Task<IActionResult> Post(long id)
    {
        var invoice = await _invoiceRepository.GetWithDetailsAsync(id);
        if (invoice == null) return NotFound();

        // Update stock for each item
        if (invoice.Details != null)
        {
            foreach (var detail in invoice.Details)
            {
                await _stockService.UpdateStockAsync(
                    invoice.CompanyId, 
                    detail.ItemId, 
                    invoice.ReceivedGodownId ?? 0, 
                    detail.Quantity, 
                    "Inward", 
                    detail.Rate);
            }
        }

        invoice.InvoiceStatus = "Posted";
        invoice.PostedDate = DateTime.Now;
        await _invoiceRepository.UpdateAsync(invoice);

        return Ok(new { message = "Invoice posted successfully" });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] PurchaseInvoice invoice)
    {
        if (id != invoice.PurchaseInvoiceId) return BadRequest();
        await _invoiceRepository.UpdateAsync(invoice);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        await _invoiceRepository.DeleteAsync(id);
        return NoContent();
    }
}
