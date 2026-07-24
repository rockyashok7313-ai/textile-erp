using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Repositories.Maintenance;

public class DowntimeRepository : Repository<DowntimeLog>, IDowntimeRepository
{
    public DowntimeRepository(ApplicationDbContext context) : base(context) { }

    public async Task<IEnumerable<DowntimeLog>> GetByMachineAsync(long machineId, DateTime fromDate, DateTime toDate)
    {
        return await _dbSet.Where(d => d.MachineId == machineId &&
            d.StartDateTime >= fromDate && d.StartDateTime <= toDate)
            .OrderByDescending(d => d.StartDateTime).ToListAsync();
    }

    public async Task<IEnumerable<DowntimeLog>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate)
    {
        return await _dbSet.Where(d => d.CompanyId == companyId &&
            d.StartDateTime >= fromDate && d.StartDateTime <= toDate)
            .OrderByDescending(d => d.StartDateTime).ToListAsync();
    }

    public async Task<decimal> GetTotalDowntimeHoursAsync(long machineId, int month, int year)
    {
        var totalMinutes = await _dbSet.Where(d => d.MachineId == machineId &&
            d.StartDateTime.Month == month && d.StartDateTime.Year == year)
            .SumAsync(d => d.DurationMinutes);
        return totalMinutes / 60m;
    }

    public async Task<DowntimeLog?> GetActiveDowntimeAsync(long machineId)
    {
        return await _dbSet.FirstOrDefaultAsync(d => d.MachineId == machineId && d.EndDateTime == null);
    }
}
