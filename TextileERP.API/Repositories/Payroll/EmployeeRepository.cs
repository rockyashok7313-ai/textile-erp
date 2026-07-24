using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Repositories.Payroll;

public class EmployeeRepository : Repository<Employee>, IEmployeeRepository
{
    public EmployeeRepository(ApplicationDbContext context) : base(context) { }

    public async Task<Employee?> GetByCodeAsync(string code, long companyId)
    {
        return await _dbSet.FirstOrDefaultAsync(e => e.EmployeeCode == code && e.CompanyId == companyId);
    }

    public async Task<IEnumerable<Employee>> GetByDepartmentAsync(long departmentId)
    {
        return await _dbSet.Where(e => e.DepartmentId == departmentId && e.IsActive).ToListAsync();
    }

    public async Task<IEnumerable<Employee>> GetByDesignationAsync(long designationId)
    {
        return await _dbSet.Where(e => e.DesignationId == designationId && e.IsActive).ToListAsync();
    }

    public async Task<IEnumerable<Employee>> GetActiveEmployeesAsync(long companyId)
    {
        return await _dbSet.Where(e => e.CompanyId == companyId && e.IsActive && !e.IsLocked).ToListAsync();
    }

    public async Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null)
    {
        return await _dbSet.AnyAsync(e => e.EmployeeCode == code && e.CompanyId == companyId &&
            (!excludeId.HasValue || e.Id != excludeId.Value));
    }
}
