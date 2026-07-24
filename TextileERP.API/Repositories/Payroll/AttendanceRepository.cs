using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Payroll;

namespace TextileERP.API.Repositories.Payroll;

public class AttendanceRepository : Repository<Attendance>, IAttendanceRepository
{
    public AttendanceRepository(ApplicationDbContext context) : base(context) { }

    public async Task<IEnumerable<Attendance>> GetByEmployeeAsync(long employeeId, DateTime fromDate, DateTime toDate)
    {
        return await _dbSet.Where(a => a.EmployeeId == employeeId &&
            a.AttendanceDate >= fromDate && a.AttendanceDate <= toDate)
            .OrderBy(a => a.AttendanceDate).ToListAsync();
    }

    public async Task<IEnumerable<Attendance>> GetByDateAsync(long companyId, DateTime date)
    {
        return await _dbSet.Where(a => a.CompanyId == companyId && a.AttendanceDate.Date == date.Date)
            .OrderBy(a => a.EmployeeId).ToListAsync();
    }

    public async Task<Attendance?> GetByEmployeeAndDateAsync(long employeeId, DateTime date)
    {
        return await _dbSet.FirstOrDefaultAsync(a => a.EmployeeId == employeeId &&
            a.AttendanceDate.Date == date.Date);
    }

    public async Task<int> GetPresentDaysAsync(long employeeId, int month, int year)
    {
        return await _dbSet.CountAsync(a => a.EmployeeId == employeeId &&
            a.AttendanceDate.Month == month && a.AttendanceDate.Year == year &&
            (a.Status == "Present" || a.Status == "HalfDay"));
    }

    public async Task<int> GetAbsentDaysAsync(long employeeId, int month, int year)
    {
        return await _dbSet.CountAsync(a => a.EmployeeId == employeeId &&
            a.AttendanceDate.Month == month && a.AttendanceDate.Year == year &&
            a.Status == "Absent");
    }

    public async Task<decimal> GetOvertimeHoursAsync(long employeeId, int month, int year)
    {
        var result = await _dbSet.Where(a => a.EmployeeId == employeeId &&
            a.AttendanceDate.Month == month && a.AttendanceDate.Year == year)
            .SumAsync(a => a.OvertimeHours);
        return result;
    }
}
