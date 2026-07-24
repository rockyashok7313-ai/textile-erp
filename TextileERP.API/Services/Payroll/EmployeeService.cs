using TextileERP.API.Models.Payroll;
using TextileERP.API.Repositories.Payroll;

namespace TextileERP.API.Services.Payroll;

public class EmployeeService : IEmployeeService
{
    private readonly IEmployeeRepository _repository;

    public EmployeeService(IEmployeeRepository repository)
    {
        _repository = repository;
    }

    public async Task<Employee?> GetByIdAsync(long id) => await _repository.GetByIdAsync(id);

    public async Task<IEnumerable<Employee>> GetAllAsync(long companyId)
    {
        return await _repository.FindAsync(e => e.CompanyId == companyId);
    }

    public async Task<IEnumerable<Employee>> GetActiveEmployeesAsync(long companyId)
    {
        return await _repository.GetActiveEmployeesAsync(companyId);
    }

    public async Task<IEnumerable<Employee>> GetByDepartmentAsync(long departmentId)
    {
        return await _repository.GetByDepartmentAsync(departmentId);
    }

    public async Task<Employee> CreateAsync(Employee employee)
    {
        employee.GrossSalary = employee.BasicSalary + employee.HRA + employee.DA +
            employee.ConveyanceAllowance + employee.MedicalAllowance +
            employee.SpecialAllowance + employee.OtherAllowance;
        employee.AnnualCTC = employee.GrossSalary * 12;
        return await _repository.AddAsync(employee);
    }

    public async Task UpdateAsync(Employee employee)
    {
        employee.GrossSalary = employee.BasicSalary + employee.HRA + employee.DA +
            employee.ConveyanceAllowance + employee.MedicalAllowance +
            employee.SpecialAllowance + employee.OtherAllowance;
        employee.AnnualCTC = employee.GrossSalary * 12;
        await _repository.UpdateAsync(employee);
    }

    public async Task DeleteAsync(long id) => await _repository.DeleteAsync(id);

    public async Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null)
    {
        return await _repository.IsCodeExistsAsync(code, companyId, excludeId);
    }
}
