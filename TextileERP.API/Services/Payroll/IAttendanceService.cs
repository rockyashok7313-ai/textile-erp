using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Services.Payroll;

public interface IAttendanceService
{
    Task<Attendance?> GetByIdAsync(long id);
    Task<IEnumerable<Attendance>> GetByEmployeeAsync(long employeeId, DateTime fromDate, DateTime toDate);
    Task<IEnumerable<Attendance>> GetByDateAsync(long companyId, DateTime date);
    Task<Attendance> MarkAttendanceAsync(Attendance attendance);
    Task UpdateAttendanceAsync(Attendance attendance);
    Task<int> GetPresentDaysAsync(long employeeId, int month, int year);
    Task<int> GetAbsentDaysAsync(long employeeId, int month, int year);
    Task<decimal> GetOvertimeHoursAsync(long employeeId, int month, int year);
}
