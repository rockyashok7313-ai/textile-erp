using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Repositories.Payroll;

public interface ILeaveRepository : IRepository<LeaveType>
{
    Task<IEnumerable<LeaveType>> GetActiveLeaveTypesAsync(long companyId);
    Task<LeaveBalance?> GetBalanceAsync(long employeeId, long leaveTypeId, int year);
    Task<IEnumerable<LeaveBalance>> GetBalancesByEmployeeAsync(long employeeId, int year);
    Task<IEnumerable<LeaveBalance>> GetBalancesByCompanyAsync(long companyId, int year);
}
