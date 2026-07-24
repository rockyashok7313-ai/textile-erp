using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Repositories.Maintenance;

public class SparePartRepository : Repository<SparePart>, ISparePartRepository
{
    public SparePartRepository(ApplicationDbContext context) : base(context) { }

    public async Task<SparePart?> GetByCodeAsync(string code, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(s => s.SparePartCode == code && s.CompanyId == companyId);
    }

    public async Task<IEnumerable<SparePart>> GetByCategoryAsync(string category, long companyId)
    {
        return await _dbSet.Where(s => s.Category == category && s.CompanyId == companyId && s.IsActive)
            .OrderBy(s => s.SparePartCode).ToListAsync();
    }

    public async Task<IEnumerable<SparePart>> GetLowStockPartsAsync(long companyId)
    {
        return await _dbSet.Where(s => s.CompanyId == companyId && s.IsActive && s.CurrentStock <= s.ReorderLevel)
            .OrderBy(s => s.CurrentStock).ToListAsync();
    }

    public async Task<IEnumerable<SparePart>> GetCriticalSparesAsync(long companyId)
    {
        return await _dbSet.Where(s => s.CompanyId == companyId && s.IsActive && s.IsCriticalSpare)
            .OrderBy(s => s.SparePartCode).ToListAsync();
    }

    public async Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null)
    {
        return await _dbSet.AnyAsync(s => s.SparePartCode == code && s.CompanyId == companyId &&
            (!excludeId.HasValue || s.Id != excludeId.Value));
    }
}
