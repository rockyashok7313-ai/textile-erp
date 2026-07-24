using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Repositories.Payroll;

public interface IPayrollRepository : IRepository<PayrollHeader>
{
    Task<PayrollHeader?> GetWithDetailsAsync(long payrollId);
    Task<PayrollHeader?> GetByPeriodAsync(long periodId);
    Task<PayrollHeader?> GetByNumberAsync(string payrollNumber, long companyId);
    Task<IEnumerable<PayrollHeader>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate);
    Task<PayrollDetail?> GetDetailByIdAsync(long detailId);
    Task<IEnumerable<PayrollDetail>> GetDetailsByPayrollAsync(long payrollId);
    Task<bool> IsNumberExistsAsync(string payrollNumber, long companyId);
}
