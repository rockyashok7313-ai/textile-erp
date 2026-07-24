using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Master;
using TextileERP.API.Models.Inventory;
using TextileERP.API.Models.Sales;
using TextileERP.API.Models.Purchase;

namespace TextileERP.API.Repositories;

public class ItemRepository : Repository<Item>, IItemRepository
{
    public ItemRepository(ApplicationDbContext context) : base(context)
    {
    }

    public async Task<Item?> GetByCodeAsync(string itemCode, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(i => i.ItemCode == itemCode && i.CompanyId == companyId);
    }

    public async Task<Item?> GetByBarcodeAsync(string barcode, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(i => i.Barcode == barcode && i.CompanyId == companyId);
    }

    public async Task<IEnumerable<Item>> GetByCategoryAsync(long categoryId, long companyId)
    {
        return await _dbSet.Where(i => i.CategoryId == categoryId && i.CompanyId == companyId && i.IsActive)
            .OrderBy(i => i.ItemName).ToListAsync();
    }

    public async Task<IEnumerable<Item>> GetTextileItemsAsync(long companyId)
    {
        return await _dbSet.Where(i => i.CompanyId == companyId && i.IsActive && 
            (i.FabricType != null || i.GSM != null || i.Width != null))
            .OrderBy(i => i.ItemName).ToListAsync();
    }

    public async Task<IEnumerable<Item>> GetLowStockItemsAsync(long companyId)
    {
        return await _dbSet.Where(i => i.CompanyId == companyId && i.IsActive && 
            i.MinimumStockLevel > 0)
            .OrderBy(i => i.ItemName).ToListAsync();
    }

    public async Task<bool> IsCodeExistsAsync(string itemCode, long? companyId, long? excludeId = null)
    {
        return await _dbSet.AnyAsync(i => i.ItemCode == itemCode && i.CompanyId == companyId && 
            (!excludeId.HasValue || i.Id != excludeId.Value));
    }
}

public class PartyRepository : Repository<Party>, IPartyRepository
{
    public PartyRepository(ApplicationDbContext context) : base(context)
    {
    }

    public async Task<Party?> GetByCodeAsync(string partyCode, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(p => p.PartyCode == partyCode && p.CompanyId == companyId);
    }

    public async Task<Party?> GetByGSTINAsync(string gstin)
    {
        return await _dbSet.FirstOrDefaultAsync(p => p.GSTIN == gstin);
    }

    public async Task<IEnumerable<Party>> GetByTypeAsync(string partyType, long companyId)
    {
        return await _dbSet.Where(p => (p.PartyType == partyType || p.PartyType == "Both") && 
            p.CompanyId == companyId && p.IsActive)
            .OrderBy(p => p.PartyName).ToListAsync();
    }

    public async Task<IEnumerable<Party>> GetSuppliersAsync(long companyId)
    {
        return await _dbSet.Where(p => (p.PartyType == "Supplier" || p.PartyType == "Both") && 
            p.CompanyId == companyId && p.IsActive)
            .OrderBy(p => p.PartyName).ToListAsync();
    }

    public async Task<IEnumerable<Party>> GetCustomersAsync(long companyId)
    {
        return await _dbSet.Where(p => (p.PartyType == "Customer" || p.PartyType == "Both") && 
            p.CompanyId == companyId && p.IsActive)
            .OrderBy(p => p.PartyName).ToListAsync();
    }

    public async Task<bool> IsCodeExistsAsync(string partyCode, long? companyId, long? excludeId = null)
    {
        return await _dbSet.AnyAsync(p => p.PartyCode == partyCode && p.CompanyId == companyId && 
            (!excludeId.HasValue || p.Id != excludeId.Value));
    }
}

public class StockRepository : Repository<StockSummary>, IStockRepository
{
    public StockRepository(ApplicationDbContext context) : base(context)
    {
    }

    public async Task<StockSummary?> GetStockAsync(long companyId, long itemId, long godownId, string? batchNumber = null)
    {
        return await _dbSet.FirstOrDefaultAsync(s => s.CompanyId == companyId && 
            s.ItemId == itemId && s.GodownId == godownId && 
            (batchNumber == null || s.BatchNumber == batchNumber));
    }

    public async Task<IEnumerable<StockSummary>> GetStockByItemAsync(long companyId, long itemId)
    {
        return await _dbSet.Where(s => s.CompanyId == companyId && s.ItemId == itemId)
            .ToListAsync();
    }

    public async Task<IEnumerable<StockSummary>> GetStockByGodownAsync(long companyId, long godownId)
    {
        return await _dbSet.Where(s => s.CompanyId == companyId && s.GodownId == godownId)
            .ToListAsync();
    }

    public async Task<IEnumerable<StockSummary>> GetLowStockItemsAsync(long companyId)
    {
        return await _context.StockSummary
            .Join(_context.Items, s => s.ItemId, i => i.Id, (s, i) => new { Stock = s, Item = i })
            .Where(x => x.Stock.CompanyId == companyId && 
                x.Item.MinimumStockLevel > 0 && 
                x.Stock.CurrentQuantity < x.Item.MinimumStockLevel)
            .Select(x => x.Stock)
            .ToListAsync();
    }

    public async Task UpdateStockAsync(long companyId, long itemId, long godownId, decimal quantity, string transactionType, decimal rate)
    {
        var stock = await GetStockAsync(companyId, itemId, godownId);
        
        if (stock == null)
        {
            stock = new StockSummary
            {
                CompanyId = companyId,
                ItemId = itemId,
                GodownId = godownId,
                CurrentQuantity = 0,
                CurrentValue = 0
            };
            _dbSet.Add(stock);
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
}

public class SalesInvoiceRepository : Repository<SalesInvoice>, ISalesInvoiceRepository
{
    public SalesInvoiceRepository(ApplicationDbContext context) : base(context)
    {
    }

    public async Task<SalesInvoice?> GetByNumberAsync(string invoiceNumber, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(i => i.InvoiceNumber == invoiceNumber && i.CompanyId == companyId);
    }

    public async Task<IEnumerable<SalesInvoice>> GetByCustomerAsync(long customerId, long companyId)
    {
        return await _dbSet.Where(i => i.CustomerId == customerId && i.CompanyId == companyId)
            .OrderByDescending(i => i.InvoiceDate).ToListAsync();
    }

    public async Task<IEnumerable<SalesInvoice>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate)
    {
        return await _dbSet.Where(i => i.CompanyId == companyId && 
            i.InvoiceDate >= fromDate && i.InvoiceDate <= toDate)
            .OrderByDescending(i => i.InvoiceDate).ToListAsync();
    }

    public async Task<SalesInvoice?> GetWithDetailsAsync(long invoiceId)
    {
        return await _dbSet
            .Include(i => i.Details)
            .Include(i => i.Customer)
            .FirstOrDefaultAsync(i => i.SalesInvoiceId == invoiceId);
    }
}

public class PurchaseInvoiceRepository : Repository<PurchaseInvoice>, IPurchaseInvoiceRepository
{
    public PurchaseInvoiceRepository(ApplicationDbContext context) : base(context)
    {
    }

    public async Task<PurchaseInvoice?> GetByNumberAsync(string invoiceNumber, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(i => i.InvoiceNumber == invoiceNumber && i.CompanyId == companyId);
    }

    public async Task<IEnumerable<PurchaseInvoice>> GetBySupplierAsync(long supplierId, long companyId)
    {
        return await _dbSet.Where(i => i.SupplierId == supplierId && i.CompanyId == companyId)
            .OrderByDescending(i => i.InvoiceDate).ToListAsync();
    }

    public async Task<IEnumerable<PurchaseInvoice>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate)
    {
        return await _dbSet.Where(i => i.CompanyId == companyId && 
            i.InvoiceDate >= fromDate && i.InvoiceDate <= toDate)
            .OrderByDescending(i => i.InvoiceDate).ToListAsync();
    }

    public async Task<PurchaseInvoice?> GetWithDetailsAsync(long invoiceId)
    {
        return await _dbSet
            .Include(i => i.Details)
            .Include(i => i.Supplier)
            .FirstOrDefaultAsync(i => i.PurchaseInvoiceId == invoiceId);
    }
}
