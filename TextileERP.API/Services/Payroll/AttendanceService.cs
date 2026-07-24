using TextileERP.API.Models.Payroll;
using TextileERP.API.Repositories.Payroll;

namespace TextileERP.API.Services.Payroll;

public class AttendanceService : IAttendanceService
{
    private readonly IAttendanceRepository _repository;

    public AttendanceService(IAttendanceRepository repository)
    {
        _repository = repository;
    }

    public async Task<Attendance?> GetByIdAsync(long id) => await _repository.GetByIdAsync(id);

    public async Task<IEnumerable<Attendance>> GetByEmployeeAsync(long employeeId, DateTime fromDate, DateTime toDate)
    {
        return await _repository.GetByEmployeeAsync(employeeId, fromDate, toDate);
    }

    public async Task<IEnumerable<Attendance>> GetByDateAsync(long companyId, DateTime date)
    {
        return await _repository.GetByDateAsync(companyId, date);
    }

    public async Task<Attendance> MarkAttendanceAsync(Attendance attendance)
    {
        var existing = await _repository.GetByEmployeeAndDateAsync(attendance.EmployeeId, attendance.AttendanceDate);
        if (existing != null)
            throw new InvalidOperationException("Attendance already marked for this employee on this date");

        if (attendance.InTime.HasValue && attendance.OutTime.HasValue)
        {
            attendance.TotalHours = (decimal)(attendance.OutTime.Value - attendance.InTime.Value).TotalHours;
        }

        return await _repository.AddAsync(attendance);
    }

    public async Task UpdateAttendanceAsync(Attendance attendance)
    {
        if (attendance.InTime.HasValue && attendance.OutTime.HasValue)
        {
            attendance.TotalHours = (decimal)(attendance.OutTime.Value - attendance.InTime.Value).TotalHours;
        }
        await _repository.UpdateAsync(attendance);
    }

    public async Task<int> GetPresentDaysAsync(long employeeId, int month, int year)
    {
        return await _repository.GetPresentDaysAsync(employeeId, month, year);
    }

    public async Task<int> GetAbsentDaysAsync(long employeeId, int month, int year)
    {
        return await _repository.GetAbsentDaysAsync(employeeId, month, year);
    }

    public async Task<decimal> GetOvertimeHoursAsync(long employeeId, int month, int year)
    {
        return await _repository.GetOvertimeHoursAsync(employeeId, month, year);
    }
}
