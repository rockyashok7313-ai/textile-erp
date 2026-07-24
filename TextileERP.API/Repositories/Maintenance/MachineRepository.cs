using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Repositories.Maintenance;

public class MachineRepository : Repository<Machine>, IMachineRepository
{
    public MachineRepository(ApplicationDbContext context) : base(context) { }

    public async Task<Machine?> GetByCodeAsync(string code, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(m => m.MachineCode == code && m.CompanyId == companyId);
    }

    public async Task<IEnumerable<Machine>> GetByTypeAsync(string machineType, long companyId)
    {
        return await _dbSet.Where(m => m.MachineType == machineType && m.CompanyId == companyId && m.IsActive)
            .OrderBy(m => m.MachineCode).ToListAsync();
    }

    public async Task<IEnumerable<Machine>> GetByStatusAsync(string status, long companyId)
    {
        return await _dbSet.Where(m => m.Status == status && m.CompanyId == companyId && m.IsActive)
            .OrderBy(m => m.MachineCode).ToListAsync();
    }

    public async Task<IEnumerable<Machine>> GetActiveMachinesAsync(long companyId)
    {
        return await _dbSet.Where(m => m.CompanyId == companyId && m.IsActive)
            .OrderBy(m => m.MachineCode).ToListAsync();
    }

    public async Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null)
    {
        return await _dbSet.AnyAsync(m => m.MachineCode == code && m.CompanyId == companyId &&
            (!excludeId.HasValue || m.Id != excludeId.Value));
    }
}
