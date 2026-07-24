using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Repositories.Payroll;

public class PayrollRepository : Repository<PayrollHeader>, IPayrollRepository
{
    private new readonly ApplicationDbContext _context;

    public PayrollRepository(ApplicationDbContext context) : base(context)
    {
        _context = context;
    }

    public async Task<PayrollHeader?> GetWithDetailsAsync(long payrollId)
    {
        return await _dbSet
            .Include(p => p.Period)
            .FirstOrDefaultAsync(p => p.Id == payrollId);
    }

    public async Task<PayrollHeader?> GetByPeriodAsync(long periodId)
    {
        return await _dbSet.FirstOrDefaultAsync(p => p.PeriodId == periodId);
    }

    public async Task<PayrollHeader?> GetByNumberAsync(string payrollNumber, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(p => p.PayrollNumber == payrollNumber && p.CompanyId == companyId);
    }

    public async Task<IEnumerable<PayrollHeader>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate)
    {
        return await _dbSet.Where(p => p.CompanyId == companyId &&
            p.ProcessDate >= fromDate && p.ProcessDate <= toDate)
            .OrderByDescending(p => p.ProcessDate).ToListAsync();
    }

    public async Task<PayrollDetail?> GetDetailByIdAsync(long detailId)
    {
        return await _context.PayrollDetails.FindAsync(detailId);
    }

    public async Task<IEnumerable<PayrollDetail>> GetDetailsByPayrollAsync(long payrollId)
    {
        return await _context.PayrollDetails.Where(d => d.PayrollId == payrollId)
            .OrderBy(d => d.EmployeeCode).ToListAsync();
    }

    public async Task<bool> IsNumberExistsAsync(string payrollNumber, long companyId)
    {
        return await _dbSet.AnyAsync(p => p.PayrollNumber == payrollNumber && p.CompanyId == companyId);
    }
}
