using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Repositories.Payroll;

public interface IAttendanceRepository : IRepository<Attendance>
{
    Task<IEnumerable<Attendance>> GetByEmployeeAsync(long employeeId, DateTime fromDate, DateTime toDate);
    Task<IEnumerable<Attendance>> GetByDateAsync(long companyId, DateTime date);
    Task<Attendance?> GetByEmployeeAndDateAsync(long employeeId, DateTime date);
    Task<int> GetPresentDaysAsync(long employeeId, int month, int year);
    Task<int> GetAbsentDaysAsync(long employeeId, int month, int year);
    Task<decimal> GetOvertimeHoursAsync(long employeeId, int month, int year);
}
