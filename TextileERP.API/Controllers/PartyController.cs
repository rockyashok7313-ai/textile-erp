using Microsoft.AspNetCore.Mvc;
using TextileERP.API.Models.Master;
using TextileERP.API.Repositories;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PartyController : ControllerBase
{
    private readonly IPartyRepository _partyRepository;

    public PartyController(IPartyRepository partyRepository)
    {
        _partyRepository = partyRepository;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Party>>> GetAll([FromQuery] long companyId, [FromQuery] string? type = null)
    {
        if (!string.IsNullOrEmpty(type))
        {
            var partiesByType = await _partyRepository.GetByTypeAsync(type, companyId);
            return Ok(partiesByType);
        }
        var parties = await _partyRepository.FindAsync(p => p.CompanyId == companyId);
        return Ok(parties);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Party>> GetById(long id)
    {
        var party = await _partyRepository.GetByIdAsync(id);
        if (party == null) return NotFound();
        return Ok(party);
    }

    [HttpGet("bycode/{code}")]
    public async Task<ActionResult<Party>> GetByCode(string code, [FromQuery] long companyId)
    {
        var party = await _partyRepository.GetByCodeAsync(code, companyId);
        if (party == null) return NotFound();
        return Ok(party);
    }

    [HttpGet("bygstin/{gstin}")]
    public async Task<ActionResult<Party>> GetByGSTIN(string gstin)
    {
        var party = await _partyRepository.GetByGSTINAsync(gstin);
        if (party == null) return NotFound();
        return Ok(party);
    }

    [HttpGet("customers")]
    public async Task<ActionResult<IEnumerable<Party>>> GetCustomers([FromQuery] long companyId)
    {
        var customers = await _partyRepository.GetCustomersAsync(companyId);
        return Ok(customers);
    }

    [HttpGet("suppliers")]
    public async Task<ActionResult<IEnumerable<Party>>> GetSuppliers([FromQuery] long companyId)
    {
        var suppliers = await _partyRepository.GetSuppliersAsync(companyId);
        return Ok(suppliers);
    }

    [HttpPost]
    public async Task<ActionResult<Party>> Create([FromBody] Party party)
    {
        if (await _partyRepository.IsCodeExistsAsync(party.PartyCode, party.CompanyId))
            return BadRequest("Party code already exists");

        var created = await _partyRepository.AddAsync(party);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] Party party)
    {
        if (id != party.Id) return BadRequest();

        if (await _partyRepository.IsCodeExistsAsync(party.PartyCode, party.CompanyId, id))
            return BadRequest("Party code already exists");

        await _partyRepository.UpdateAsync(party);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        await _partyRepository.DeleteAsync(id);
        return NoContent();
    }
}
