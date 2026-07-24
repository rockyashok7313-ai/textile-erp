using Microsoft.AspNetCore.Mvc;
using TextileERP.API.Models.Sales;
using TextileERP.API.Repositories;
using TextileERP.API.Services;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SalesInvoiceController : ControllerBase
{
    private readonly ISalesInvoiceRepository _invoiceRepository;
    private readonly IGSTService _gstService;
    private readonly IStockService _stockService;
    private readonly IDocumentNumberService _documentNumberService;

    public SalesInvoiceController(
        ISalesInvoiceRepository invoiceRepository,
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
    public async Task<ActionResult<IEnumerable<SalesInvoice>>> GetAll([FromQuery] long companyId, [FromQuery] DateTime? fromDate = null, [FromQuery] DateTime? toDate = null)
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
    public async Task<ActionResult<SalesInvoice>> GetById(long id)
    {
        var invoice = await _invoiceRepository.GetWithDetailsAsync(id);
        if (invoice == null) return NotFound();
        return Ok(invoice);
    }

    [HttpGet("bynumber/{number}")]
    public async Task<ActionResult<SalesInvoice>> GetByNumber(string number, [FromQuery] long companyId)
    {
        var invoice = await _invoiceRepository.GetByNumberAsync(number, companyId);
        if (invoice == null) return NotFound();
        return Ok(invoice);
    }

    [HttpGet("bycustomer/{customerId}")]
    public async Task<ActionResult<IEnumerable<SalesInvoice>>> GetByCustomer(long customerId, [FromQuery] long companyId)
    {
        var invoices = await _invoiceRepository.GetByCustomerAsync(customerId, companyId);
        return Ok(invoices);
    }

    [HttpPost]
    public async Task<ActionResult<SalesInvoice>> Create([FromBody] SalesInvoice invoice)
    {
        // Generate invoice number
        var invoiceNumber = await _documentNumberService.GetNextDocumentNumberAsync(
            invoice.CompanyId, "SalesInvoice", DateTime.Now.ToString("yyyy-yy"));
        
        invoice.InvoiceNumber = invoiceNumber;
        invoice.InvoiceStatus = "Draft";

        // Calculate GST for each detail
        if (invoice.Details != null)
        {
            foreach (var detail in invoice.Details)
            {
                var (cgst, sgst, igst) = await _gstService.CalculateGSTAsync(
                    invoice.CompanyId, invoice.CustomerStateCode, detail.BasicAmount, detail.GSTRate);
                
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
        return CreatedAtAction(nameof(GetById), new { id = created.SalesInvoiceId }, created);
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
                    invoice.DispatchGodownId ?? 0, 
                    detail.Quantity, 
                    "Outward", 
                    detail.Rate);
            }
        }

        invoice.InvoiceStatus = "Posted";
        invoice.PostedDate = DateTime.Now;
        await _invoiceRepository.UpdateAsync(invoice);

        return Ok(new { message = "Invoice posted successfully" });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] SalesInvoice invoice)
    {
        if (id != invoice.SalesInvoiceId) return BadRequest();
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
