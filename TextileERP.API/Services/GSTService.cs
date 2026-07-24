using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;

namespace TextileERP.API.Services;

public class GSTService : IGSTService
{
    private readonly ApplicationDbContext _context;

    public GSTService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<(decimal cgst, decimal sgst, decimal igst)> CalculateGSTAsync(long companyId, string? partyStateCode, decimal taxableAmount, decimal gstRate)
    {
        var isInterState = await IsInterStateAsync(companyId, partyStateCode);

        if (isInterState)
        {
            // Inter-state: IGST
            var igst = taxableAmount * gstRate / 100;
            return (0, 0, igst);
        }
        else
        {
            // Intra-state: CGST + SGST
            var cgst = taxableAmount * (gstRate / 2) / 100;
            var sgst = taxableAmount * (gstRate / 2) / 100;
            return (cgst, sgst, 0);
        }
    }

    public async Task<bool> IsInterStateAsync(long companyId, string? partyStateCode)
    {
        var company = await _context.Companies.FindAsync(companyId);
        if (company == null || partyStateCode == null)
            return false;

        return company.StateCode != partyStateCode;
    }
}

public class StockService : IStockService
{
    private readonly ApplicationDbContext _context;

    public StockService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task UpdateStockAsync(long companyId, long itemId, long godownId, decimal quantity, string transactionType, decimal rate)
    {
        var stock = await _context.StockSummary
            .FirstOrDefaultAsync(s => s.CompanyId == companyId && 
                s.ItemId == itemId && s.GodownId == godownId);

        if (stock == null)
        {
            stock = new Models.Inventory.StockSummary
            {
                CompanyId = companyId,
                ItemId = itemId,
                GodownId = godownId,
                CurrentQuantity = 0,
                CurrentValue = 0
            };
            _context.StockSummary.Add(stock);
        }

        if (transactionType == "Inward")
        {
            stock.CurrentQuantity += quantity;
            stock.CurrentValue += quantity * rate;
            stock.InwardQuantity += quantity;
            stock.InwardValue += quantity * rate;
        }
        else if (transactionType == "Outward")
        {
            stock.CurrentQuantity -= quantity;
            stock.CurrentValue -= quantity * rate;
            stock.OutwardQuantity += quantity;
            stock.OutwardValue += quantity * rate;
        }

        stock.LastMovementDate = DateTime.Now;
        stock.ModifiedDate = DateTime.Now;

        await _context.SaveChangesAsync();
    }

    public async Task<Models.Inventory.StockSummary?> GetStockAsync(long companyId, long itemId, long godownId)
    {
        return await _context.StockSummary
            .FirstOrDefaultAsync(s => s.CompanyId == companyId && 
                s.ItemId == itemId && s.GodownId == godownId);
    }

    public async Task<IEnumerable<Models.Inventory.StockSummary>> GetStockByItemAsync(long companyId, long itemId)
    {
        return await _context.StockSummary
            .Where(s => s.CompanyId == companyId && s.ItemId == itemId)
            .ToListAsync();
    }
}

public class DocumentNumberService : IDocumentNumberService
{
    private readonly ApplicationDbContext _context;

    public DocumentNumberService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<string> GetNextDocumentNumberAsync(long companyId, string documentType, string financialYear)
    {
        var sequence = await _context.DocumentSequences
            .FirstOrDefaultAsync(s => s.CompanyId == companyId && 
                s.DocumentType == documentType && 
                s.FinancialYear == financialYear);

        if (sequence == null)
        {
            sequence = new Models.Compliance.DocumentSequence
            {
                CompanyId = companyId,
                DocumentType = documentType,
                FinancialYear = financialYear,
                CurrentNumber = 0,
                MinDigits = 6
            };
            _context.DocumentSequences.Add(sequence);
        }

        sequence.CurrentNumber++;
        sequence.ModifiedDate = DateTime.Now;

        await _context.SaveChangesAsync();

        // Format number with prefix and padding
        var numberStr = sequence.CurrentNumber.ToString().PadLeft(sequence.MinDigits, '0');
        return $"{sequence.Prefix}{numberStr}{sequence.Suffix}";
    }
}

public class TDSService : ITDSService
{
    private readonly ApplicationDbContext _context;

    public TDSService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<(decimal tdsAmount, bool isApplicable)> CalculateTDSAsync(long partyId, decimal amount, string tdsSection)
    {
        var party = await _context.Parties.FindAsync(partyId);
        if (party == null)
            return (0, false);

        var isPANValidated = !string.IsNullOrEmpty(party.PAN) && party.PAN.Length == 10;
        decimal tdsRate;
        decimal threshold;

        switch (tdsSection)
        {
            case "194C":
                tdsRate = isPANValidated ? 1 : 2;
                threshold = 30000;
                break;
            case "194Q":
                tdsRate = isPANValidated ? 0.1m : 2;
                threshold = 5000000; // 50 Lakh
                break;
            case "194J":
                tdsRate = isPANValidated ? 10 : 20;
                threshold = 30000;
                break;
            case "194A":
                tdsRate = isPANValidated ? 10 : 20;
                threshold = 40000;
                break;
            case "194I(a)":
                tdsRate = isPANValidated ? 2 : 20;
                threshold = 240000;
                break;
            case "194I(b)":
                tdsRate = isPANValidated ? 10 : 20;
                threshold = 240000;
                break;
            default:
                tdsRate = 10;
                threshold = 0;
                break;
        }

        if (amount >= threshold)
        {
            var tdsAmount = amount * tdsRate / 100;
            return (tdsAmount, true);
        }

        return (0, false);
    }
}

public class TCSService : ITCSService
{
    private readonly ApplicationDbContext _context;

    public TCSService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<(decimal tcsAmount, bool isApplicable)> CalculateTCSAsync(long partyId, decimal amount, string tcsSection)
    {
        decimal tcsRate;
        decimal threshold;

        switch (tcsSection)
        {
            case "206C(1H)":
                tcsRate = 0.075m;
                threshold = 5000000; // 50 Lakh
                break;
            case "206C(1G)":
                tcsRate = 0.5m;
                threshold = 700000;
                break;
            case "206C(1F)":
                tcsRate = 1;
                threshold = 5000000;
                break;
            default:
                tcsRate = 0.075m;
                threshold = 5000000;
                break;
        }

        if (amount >= threshold)
        {
            var tcsAmount = amount * tcsRate / 100;
            return (tcsAmount, true);
        }

        return (0, false);
    }
}
