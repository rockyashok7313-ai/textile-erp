using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Repositories.Payroll;

public class LeaveRepository : Repository<LeaveType>, ILeaveRepository
{
    private new readonly ApplicationDbContext _context;

    public LeaveRepository(ApplicationDbContext context) : base(context)
    {
        _context = context;
    }

    public async Task<IEnumerable<LeaveType>> GetActiveLeaveTypesAsync(long companyId)
    {
        return await _dbSet.Where(l => l.CompanyId == companyId && l.IsActive)
            .OrderBy(l => l.SortOrder).ToListAsync();
    }

    public async Task<LeaveBalance?> GetBalanceAsync(long employeeId, long leaveTypeId, int year)
    {
        return await _context.LeaveBalances.FirstOrDefaultAsync(
            lb => lb.EmployeeId == employeeId && lb.LeaveTypeId == leaveTypeId && lb.LeaveYear == year);
    }

    public async Task<IEnumerable<LeaveBalance>> GetBalancesByEmployeeAsync(long employeeId, int year)
    {
        return await _context.LeaveBalances
            .Include(lb => lb.LeaveType)
            .Where(lb => lb.EmployeeId == employeeId && lb.LeaveYear == year)
            .ToListAsync();
    }

    public async Task<IEnumerable<LeaveBalance>> GetBalancesByCompanyAsync(long companyId, int year)
    {
        return await _context.LeaveBalances
            .Include(lb => lb.Employee)
            .Include(lb => lb.LeaveType)
            .Where(lb => lb.Employee!.CompanyId == companyId && lb.LeaveYear == year)
            .ToListAsync();
    }
}
