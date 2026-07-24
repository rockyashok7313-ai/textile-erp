using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Payroll;
using TextileERP.API.Repositories.Payroll;

namespace TextileERP.API.Services.Payroll;

public class PayrollService : IPayrollService
{
    private readonly IPayrollRepository _payrollRepository;
    private readonly IEmployeeRepository _employeeRepository;
    private readonly IAttendanceRepository _attendanceRepository;
    private readonly ApplicationDbContext _context;

    public PayrollService(
        IPayrollRepository payrollRepository,
        IEmployeeRepository employeeRepository,
        IAttendanceRepository attendanceRepository,
        ApplicationDbContext context)
    {
        _payrollRepository = payrollRepository;
        _employeeRepository = employeeRepository;
        _attendanceRepository = attendanceRepository;
        _context = context;
    }

    public async Task<PayrollHeader?> GetByIdAsync(long id) => await _payrollRepository.GetWithDetailsAsync(id);

    public async Task<IEnumerable<PayrollHeader>> GetAllAsync(long companyId)
    {
        return await _payrollRepository.FindAsync(p => p.CompanyId == companyId);
    }

    public async Task<PayrollHeader?> GetByPeriodAsync(long periodId)
    {
        return await _payrollRepository.GetByPeriodAsync(periodId);
    }

    public async Task<PayrollHeader> ProcessPayrollAsync(long companyId, long periodId)
    {
        var period = await _context.PayrollPeriods.FindAsync(periodId);
        if (period == null) throw new KeyNotFoundException("Payroll period not found");
        if (period.Status != "Open") throw new InvalidOperationException("Payroll period is not open");

        var employees = await _employeeRepository.GetActiveEmployeesAsync(companyId);
        var month = period.StartDate.Month;
        var year = period.StartDate.Year;
        int daysInMonth = DateTime.DaysInMonth(year, month);

        var payrollNumber = $"PAY-{year}{month:D2}-{companyId}";

        var header = new PayrollHeader
        {
            CompanyId = companyId,
            PeriodId = periodId,
            PayrollNumber = payrollNumber,
            ProcessDate = DateTime.Now,
            Status = "Draft"
        };

        decimal totalGross = 0, totalEarnings = 0, totalDeductions = 0, totalNetPay = 0, totalEmployerCost = 0;
        int totalEmployees = 0, totalDaysWorked = 0, totalLeaves = 0;
        decimal totalOvertime = 0;

        var details = new List<PayrollDetail>();

        foreach (var emp in employees)
        {
            var present = await _attendanceRepository.GetPresentDaysAsync(emp.Id, month, year);
            var absent = await _attendanceRepository.GetAbsentDaysAsync(emp.Id, month, year);
            var overtime = await _attendanceRepository.GetOvertimeHoursAsync(emp.Id, month, year);

            var leaveDays = daysInMonth - present - absent;
            if (leaveDays < 0) leaveDays = 0;

            // Earnings - pro-rata based on days worked
            var totalWorkingDays = daysInMonth;
            var ratio = totalWorkingDays > 0 ? (decimal)present / totalWorkingDays : 0;

            var basicEarned = Math.Round(emp.BasicSalary * ratio, 2);
            var hraEarned = Math.Round(emp.HRA * ratio, 2);
            var daEarned = Math.Round(emp.DA * ratio, 2);
            var convEarned = Math.Round(emp.ConveyanceAllowance * ratio, 2);
            var medEarned = Math.Round(emp.MedicalAllowance * ratio, 2);
            var specEarned = Math.Round(emp.SpecialAllowance * ratio, 2);
            var otherEarned = Math.Round(emp.OtherAllowance * ratio, 2);

            var hourlyRate = emp.BasicSalary / (decimal)(daysInMonth * 8);
            var overtimeAmount = Math.Round(hourlyRate * 2 * overtime, 2); // Double rate for OT

            var grossEarnings = basicEarned + hraEarned + daEarned + convEarned + medEarned + specEarned + otherEarned + overtimeAmount;

            // Deductions
            var pfEmployee = emp.IsPFApplicable ? Math.Round(Math.Min(basicEarned, 15000) * 0.12m, 2) : 0;
            var pfEmployer = emp.IsPFApplicable ? Math.Round(Math.Min(basicEarned, 15000) * 0.12m, 2) : 0;

            var esiEmployee = (emp.IsESIApplicable && grossEarnings <= 21000) ? Math.Round(grossEarnings * 0.0075m, 2) : 0;
            var esiEmployer = (emp.IsESIApplicable && grossEarnings <= 21000) ? Math.Round(grossEarnings * 0.0325m, 2) : 0;

            // Professional Tax - simple slab
            var pt = 0m;
            if (emp.IsPTApplicable)
            {
                if (grossEarnings >= 15000) pt = 200;
                else if (grossEarnings >= 10000) pt = 100;
            }

            var empDeductions = pfEmployee + esiEmployee + pt;
            var netPay = grossEarnings - empDeductions;
            var employerCost = pfEmployer + esiEmployer;

            var detail = new PayrollDetail
            {
                EmployeeId = emp.Id,
                EmployeeCode = emp.EmployeeCode,
                EmployeeName = $"{emp.FirstName} {emp.LastName}",
                DepartmentId = emp.DepartmentId,
                DesignationId = emp.DesignationId,
                DaysInMonth = daysInMonth,
                WorkingDays = totalWorkingDays,
                DaysPresent = present,
                DaysAbsent = absent,
                DaysOnLeave = leaveDays,
                OvertimeHours = overtime,
                BasicSalary = emp.BasicSalary,
                BasicEarned = basicEarned,
                HRA = hraEarned,
                DA = daEarned,
                ConveyanceAllowance = convEarned,
                MedicalAllowance = medEarned,
                SpecialAllowance = specEarned,
                OtherAllowance = otherEarned,
                OvertimeAmount = overtimeAmount,
                GrossEarnings = grossEarnings,
                PF_Employee = pfEmployee,
                ESI_Employee = esiEmployee,
                ProfessionalTax = pt,
                TotalDeductions = empDeductions,
                PF_Employer = pfEmployer,
                ESI_Employer = esiEmployer,
                TotalEmployerCost = employerCost,
                NetPay = netPay
            };

            details.Add(detail);

            totalGross += grossEarnings;
            totalEarnings += grossEarnings;
            totalDeductions += empDeductions;
            totalNetPay += netPay;
            totalEmployerCost += employerCost;
            totalEmployees++;
            totalDaysWorked += present;
            totalLeaves += leaveDays;
            totalOvertime += overtime;
        }

        header.TotalEmployees = totalEmployees;
        header.TotalDaysWorked = totalDaysWorked;
        header.TotalOvertimeHours = totalOvertime;
        header.TotalLeaves = totalLeaves;
        header.GrossPay = totalGross;
        header.TotalEarnings = totalEarnings;
        header.TotalDeductions = totalDeductions;
        header.TotalEmployerCost = totalEmployerCost;
        header.NetPay = totalNetPay;

        _context.PayrollHeaders.Add(header);
        await _context.SaveChangesAsync();

        foreach (var detail in details)
        {
            detail.PayrollId = header.Id;
            _context.PayrollDetails.Add(detail);
        }

        await _context.SaveChangesAsync();

        // Update period status
        period.Status = "Processing";
        await _context.SaveChangesAsync();

        return header;
    }

    public async Task ApprovePayrollAsync(long payrollId, long approvedBy)
    {
        var payroll = await _payrollRepository.GetByIdAsync(payrollId);
        if (payroll == null) throw new KeyNotFoundException("Payroll not found");
        if (payroll.Status != "Draft") throw new InvalidOperationException("Only draft payroll can be approved");

        payroll.Status = "Approved";
        payroll.ApprovedBy = approvedBy;
        payroll.ApprovedDate = DateTime.Now;
        await _payrollRepository.UpdateAsync(payroll);
    }

    public async Task CancelPayrollAsync(long payrollId, long cancelledBy, string reason)
    {
        var payroll = await _payrollRepository.GetByIdAsync(payrollId);
        if (payroll == null) throw new KeyNotFoundException("Payroll not found");
        if (payroll.Status == "Paid") throw new InvalidOperationException("Cannot cancel paid payroll");

        payroll.Status = "Cancelled";
        payroll.Remarks = reason;
        await _payrollRepository.UpdateAsync(payroll);
    }

    public async Task UpdateStatusAsync(long payrollId, string status)
    {
        var payroll = await _payrollRepository.GetByIdAsync(payrollId);
        if (payroll == null) throw new KeyNotFoundException("Payroll not found");
        payroll.Status = status;
        await _payrollRepository.UpdateAsync(payroll);
    }

    public async Task<bool> IsNumberExistsAsync(string payrollNumber, long companyId)
    {
        return await _payrollRepository.IsNumberExistsAsync(payrollNumber, companyId);
    }
}
