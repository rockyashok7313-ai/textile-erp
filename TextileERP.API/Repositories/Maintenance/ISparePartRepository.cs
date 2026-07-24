using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Repositories.Maintenance;

public interface ISparePartRepository : IRepository<SparePart>
{
    Task<SparePart?> GetByCodeAsync(string code, long companyId);
    Task<IEnumerable<SparePart>> GetByCategoryAsync(string category, long companyId);
    Task<IEnumerable<SparePart>> GetLowStockPartsAsync(long companyId);
    Task<IEnumerable<SparePart>> GetCriticalSparesAsync(long companyId);
    Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null);
}
