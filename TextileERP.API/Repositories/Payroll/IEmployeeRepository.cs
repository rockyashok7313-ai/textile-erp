using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Repositories.Payroll;

public interface IEmployeeRepository : IRepository<Employee>
{
    Task<Employee?> GetByCodeAsync(string code, long companyId);
    Task<IEnumerable<Employee>> GetByDepartmentAsync(long departmentId);
    Task<IEnumerable<Employee>> GetByDesignationAsync(long designationId);
    Task<IEnumerable<Employee>> GetActiveEmployeesAsync(long companyId);
    Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null);
}
