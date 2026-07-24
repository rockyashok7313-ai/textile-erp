using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Services.Maintenance;

public interface ISparePartService
{
    Task<SparePart?> GetByIdAsync(long id);
    Task<IEnumerable<SparePart>> GetAllAsync(long companyId);
    Task<IEnumerable<SparePart>> GetByCategoryAsync(string category, long companyId);
    Task<IEnumerable<SparePart>> GetLowStockPartsAsync(long companyId);
    Task<SparePart> CreateAsync(SparePart sparePart);
    Task UpdateAsync(SparePart sparePart);
    Task DeleteAsync(long id);
    Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null);
    Task ConsumeStockAsync(long sparePartId, decimal quantity);
    Task RestockAsync(long sparePartId, decimal quantity);
}
