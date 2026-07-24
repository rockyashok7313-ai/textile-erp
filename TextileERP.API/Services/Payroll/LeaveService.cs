using TextileERP.API.Data;
using TextileERP.API.Models.Payroll;
using TextileERP.API.Repositories.Payroll;

namespace TextileERP.API.Services.Payroll;

public class LeaveService : ILeaveService
{
    private readonly ILeaveRepository _repository;
    private readonly ApplicationDbContext _context;

    public LeaveService(ILeaveRepository repository, ApplicationDbContext context)
    {
        _repository = repository;
        _context = context;
    }

    public async Task<IEnumerable<LeaveType>> GetLeaveTypesAsync(long companyId)
    {
        return await _repository.GetActiveLeaveTypesAsync(companyId);
    }

    public async Task<LeaveBalance?> GetBalanceAsync(long employeeId, long leaveTypeId, int year)
    {
        return await _repository.GetBalanceAsync(employeeId, leaveTypeId, year);
    }

    public async Task<IEnumerable<LeaveBalance>> GetBalancesByEmployeeAsync(long employeeId, int year)
    {
        return await _repository.GetBalancesByEmployeeAsync(employeeId, year);
    }

    public async Task<LeaveBalance> ApplyLeaveAsync(long employeeId, long leaveTypeId, decimal days, int year)
    {
        var balance = await _repository.GetBalanceAsync(employeeId, leaveTypeId, year);
        if (balance == null)
        {
            balance = new LeaveBalance
            {
                EmployeeId = employeeId,
                LeaveTypeId = leaveTypeId,
                LeaveYear = year,
                TotalDays = 0,
                UsedDays = days,
                BalanceDays = -days
            };
            _context.LeaveBalances.Add(balance);
            await _context.SaveChangesAsync();
            return balance;
        }

        if (balance.BalanceDays < days)
            throw new InvalidOperationException("Insufficient leave balance");

        balance.UsedDays += days;
        balance.BalanceDays -= days;
        await _context.SaveChangesAsync();
        return balance;
    }

    public async Task<LeaveBalance> AdjustLeaveAsync(long employeeId, long leaveTypeId, decimal days, int year)
    {
        var balance = await _repository.GetBalanceAsync(employeeId, leaveTypeId, year);
        if (balance == null)
        {
            balance = new LeaveBalance
            {
                EmployeeId = employeeId,
                LeaveTypeId = leaveTypeId,
                LeaveYear = year,
                TotalDays = days,
                UsedDays = 0,
                BalanceDays = days
            };
            _context.LeaveBalances.Add(balance);
            await _context.SaveChangesAsync();
            return balance;
        }

        balance.TotalDays += days;
        balance.BalanceDays += days;
        await _context.SaveChangesAsync();
        return balance;
    }
}
