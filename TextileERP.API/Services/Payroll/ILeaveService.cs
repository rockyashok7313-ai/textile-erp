using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Services.Payroll;

public interface ILeaveService
{
    Task<IEnumerable<LeaveType>> GetLeaveTypesAsync(long companyId);
    Task<LeaveBalance?> GetBalanceAsync(long employeeId, long leaveTypeId, int year);
    Task<IEnumerable<LeaveBalance>> GetBalancesByEmployeeAsync(long employeeId, int year);
    Task<LeaveBalance> ApplyLeaveAsync(long employeeId, long leaveTypeId, decimal days, int year);
    Task<LeaveBalance> AdjustLeaveAsync(long employeeId, long leaveTypeId, decimal days, int year);
}
