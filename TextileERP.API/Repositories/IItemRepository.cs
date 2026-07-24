using TextileERP.API.Models.Master;
using TextileERP.API.Models.Inventory;
using TextileERP.API.Models.Sales;
using TextileERP.API.Models.Purchase;

namespace TextileERP.API.Repositories;

public interface IItemRepository : IRepository<Item>
{
    Task<Item?> GetByCodeAsync(string itemCode, long companyId);
    Task<Item?> GetByBarcodeAsync(string barcode, long companyId);
    Task<IEnumerable<Item>> GetByCategoryAsync(long categoryId, long companyId);
    Task<IEnumerable<Item>> GetTextileItemsAsync(long companyId);
    Task<IEnumerable<Item>> GetLowStockItemsAsync(long companyId);
    Task<bool> IsCodeExistsAsync(string itemCode, long? companyId, long? excludeId = null);
}

public interface IPartyRepository : IRepository<Party>
{
    Task<Party?> GetByCodeAsync(string partyCode, long companyId);
    Task<Party?> GetByGSTINAsync(string gstin);
    Task<IEnumerable<Party>> GetByTypeAsync(string partyType, long companyId);
    Task<IEnumerable<Party>> GetSuppliersAsync(long companyId);
    Task<IEnumerable<Party>> GetCustomersAsync(long companyId);
    Task<bool> IsCodeExistsAsync(string partyCode, long? companyId, long? excludeId = null);
}

public interface IStockRepository : IRepository<StockSummary>
{
    Task<StockSummary?> GetStockAsync(long companyId, long itemId, long godownId, string? batchNumber = null);
    Task<IEnumerable<StockSummary>> GetStockByItemAsync(long companyId, long itemId);
    Task<IEnumerable<StockSummary>> GetStockByGodownAsync(long companyId, long godownId);
    Task<IEnumerable<StockSummary>> GetLowStockItemsAsync(long companyId);
    Task UpdateStockAsync(long companyId, long itemId, long godownId, decimal quantity, string transactionType, decimal rate);
}

public interface ISalesInvoiceRepository : IRepository<SalesInvoice>
{
    Task<SalesInvoice?> GetByNumberAsync(string invoiceNumber, long companyId);
    Task<IEnumerable<SalesInvoice>> GetByCustomerAsync(long customerId, long companyId);
    Task<IEnumerable<SalesInvoice>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate);
    Task<SalesInvoice?> GetWithDetailsAsync(long invoiceId);
}

public interface IPurchaseInvoiceRepository : IRepository<PurchaseInvoice>
{
    Task<PurchaseInvoice?> GetByNumberAsync(string invoiceNumber, long companyId);
    Task<IEnumerable<PurchaseInvoice>> GetBySupplierAsync(long supplierId, long companyId);
    Task<IEnumerable<PurchaseInvoice>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate);
    Task<PurchaseInvoice?> GetWithDetailsAsync(long invoiceId);
}
