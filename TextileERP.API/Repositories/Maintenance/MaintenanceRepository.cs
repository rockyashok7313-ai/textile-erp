using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Repositories.Maintenance;

public class MaintenanceRepository : Repository<MaintenanceRequest>, IMaintenanceRepository
{
    private new readonly ApplicationDbContext _context;

    public MaintenanceRepository(ApplicationDbContext context) : base(context)
    {
        _context = context;
    }

    public async Task<MaintenanceRequest?> GetByNumberAsync(string requestNumber, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(r => r.RequestNumber == requestNumber && r.CompanyId == companyId);
    }

    public async Task<IEnumerable<MaintenanceRequest>> GetByMachineAsync(long machineId)
    {
        return await _dbSet.Where(r => r.MachineId == machineId)
            .OrderByDescending(r => r.RequestDate).ToListAsync();
    }

    public async Task<IEnumerable<MaintenanceRequest>> GetByStatusAsync(string status, long companyId)
    {
        return await _dbSet.Where(r => r.Status == status && r.CompanyId == companyId)
            .OrderByDescending(r => r.RequestDate).ToListAsync();
    }

    public async Task<WorkOrder?> GetWorkOrderByIdAsync(long workOrderId)
    {
        return await _context.WorkOrders.FindAsync(workOrderId);
    }

    public async Task<WorkOrder?> GetWorkOrderByNumberAsync(string workOrderNumber, long companyId)
    {
        return await _context.WorkOrders.FirstOrDefaultAsync(w => w.WorkOrderNumber == workOrderNumber && w.CompanyId == companyId);
    }

    public async Task<IEnumerable<WorkOrder>> GetWorkOrdersByMachineAsync(long machineId)
    {
        return await _context.WorkOrders.Where(w => w.MachineId == machineId)
            .OrderByDescending(w => w.StartDate).ToListAsync();
    }

    public async Task<IEnumerable<WorkOrder>> GetActiveWorkOrdersAsync(long companyId)
    {
        return await _context.WorkOrders.Where(w => w.CompanyId == companyId &&
            (w.Status == "Open" || w.Status == "InProgress"))
            .OrderByDescending(w => w.StartDate).ToListAsync();
    }

    public async Task<bool> IsRequestNumberExistsAsync(string requestNumber, long companyId)
    {
        return await _dbSet.AnyAsync(r => r.RequestNumber == requestNumber && r.CompanyId == companyId);
    }

    public async Task<bool> IsWorkOrderNumberExistsAsync(string workOrderNumber, long companyId)
    {
        return await _context.WorkOrders.AnyAsync(w => w.WorkOrderNumber == workOrderNumber && w.CompanyId == companyId);
    }
}
