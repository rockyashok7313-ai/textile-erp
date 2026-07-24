using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Services.Payroll;

public interface IPayrollService
{
    Task<PayrollHeader?> GetByIdAsync(long id);
    Task<IEnumerable<PayrollHeader>> GetAllAsync(long companyId);
    Task<PayrollHeader?> GetByPeriodAsync(long periodId);
    Task<PayrollHeader> ProcessPayrollAsync(long companyId, long periodId);
    Task ApprovePayrollAsync(long payrollId, long approvedBy);
    Task CancelPayrollAsync(long payrollId, long cancelledBy, string reason);
    Task UpdateStatusAsync(long payrollId, string status);
    Task<bool> IsNumberExistsAsync(string payrollNumber, long companyId);
}
