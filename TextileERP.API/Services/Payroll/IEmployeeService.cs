using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Services.Payroll;

public interface IEmployeeService
{
    Task<Employee?> GetByIdAsync(long id);
    Task<IEnumerable<Employee>> GetAllAsync(long companyId);
    Task<IEnumerable<Employee>> GetActiveEmployeesAsync(long companyId);
    Task<IEnumerable<Employee>> GetByDepartmentAsync(long departmentId);
    Task<Employee> CreateAsync(Employee employee);
    Task UpdateAsync(Employee employee);
    Task DeleteAsync(long id);
    Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null);
}
