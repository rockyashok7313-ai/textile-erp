namespace TextileERP.API.Services;

public interface IGSTService
{
    Task<(decimal cgst, decimal sgst, decimal igst)> CalculateGSTAsync(long companyId, string? partyStateCode, decimal taxableAmount, decimal gstRate);
    Task<bool> IsInterStateAsync(long companyId, string? partyStateCode);
}

public interface IStockService
{
    Task UpdateStockAsync(long companyId, long itemId, long godownId, decimal quantity, string transactionType, decimal rate);
    Task<Models.Inventory.StockSummary?> GetStockAsync(long companyId, long itemId, long godownId);
    Task<IEnumerable<Models.Inventory.StockSummary>> GetStockByItemAsync(long companyId, long itemId);
}

public interface IDocumentNumberService
{
    Task<string> GetNextDocumentNumberAsync(long companyId, string documentType, string financialYear);
}

public interface ITDSService
{
    Task<(decimal tdsAmount, bool isApplicable)> CalculateTDSAsync(long partyId, decimal amount, string tdsSection);
}

public interface ITCSService
{
    Task<(decimal tcsAmount, bool isApplicable)> CalculateTCSAsync(long partyId, decimal amount, string tcsSection);
}
