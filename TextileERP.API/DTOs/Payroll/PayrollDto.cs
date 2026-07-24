namespace TextileERP.API.DTOs.Payroll;

public class EmployeeDto
{
    public long Id { get; set; }
    public string EmployeeCode { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? MiddleName { get; set; }
    public string? FatherName { get; set; }
    public string? SpouseName { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public DateTime DateOfJoining { get; set; }
    public string Gender { get; set; } = string.Empty;
    public string? MaritalStatus { get; set; }
    public string? BloodGroup { get; set; }
    public string? PAN { get; set; }
    public string? AadhaarNumber { get; set; }
    public long? DepartmentId { get; set; }
    public string? DepartmentName { get; set; }
    public long? DesignationId { get; set; }
    public string? DesignationName { get; set; }
    public string EmploymentType { get; set; } = "Permanent";
    public string? PFNumber { get; set; }
    public string? ESINumber { get; set; }
    public string? UAN { get; set; }
    public bool IsPFApplicable { get; set; }
    public bool IsESIApplicable { get; set; }
    public bool IsPTApplicable { get; set; }
    public string? AddressLine1 { get; set; }
    public string? City { get; set; }
    public long? StateId { get; set; }
    public string? PinCode { get; set; }
    public string? Phone { get; set; }
    public string? Mobile { get; set; }
    public string? PersonalEmail { get; set; }
    public string? OfficialEmail { get; set; }
    public string? BankName { get; set; }
    public string? BankIFSC { get; set; }
    public string? BankAccountNumber { get; set; }
    public decimal BasicSalary { get; set; }
    public decimal HRA { get; set; }
    public decimal DA { get; set; }
    public decimal ConveyanceAllowance { get; set; }
    public decimal MedicalAllowance { get; set; }
    public decimal SpecialAllowance { get; set; }
    public decimal OtherAllowance { get; set; }
    public decimal GrossSalary { get; set; }
    public decimal AnnualCTC { get; set; }
    public bool IsActive { get; set; }
}

public class CreateEmployeeRequest
{
    public long CompanyId { get; set; }
    public string EmployeeCode { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? MiddleName { get; set; }
    public string? FatherName { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public DateTime DateOfJoining { get; set; }
    public string Gender { get; set; } = string.Empty;
    public long? DepartmentId { get; set; }
    public long? DesignationId { get; set; }
    public string EmploymentType { get; set; } = "Permanent";
    public string? PAN { get; set; }
    public string? AadhaarNumber { get; set; }
    public string? PFNumber { get; set; }
    public string? ESINumber { get; set; }
    public string? UAN { get; set; }
    public bool IsPFApplicable { get; set; } = true;
    public bool IsESIApplicable { get; set; } = true;
    public bool IsPTApplicable { get; set; } = true;
    public string? Mobile { get; set; }
    public string? PersonalEmail { get; set; }
    public string? BankName { get; set; }
    public string? BankIFSC { get; set; }
    public string? BankAccountNumber { get; set; }
    public decimal BasicSalary { get; set; }
    public decimal HRA { get; set; }
    public decimal DA { get; set; }
    public decimal ConveyanceAllowance { get; set; }
    public decimal MedicalAllowance { get; set; }
    public decimal SpecialAllowance { get; set; }
    public decimal OtherAllowance { get; set; }
}

public class AttendanceDto
{
    public long Id { get; set; }
    public long EmployeeId { get; set; }
    public string? EmployeeName { get; set; }
    public string? EmployeeCode { get; set; }
    public DateTime AttendanceDate { get; set; }
    public string Status { get; set; } = string.Empty;
    public string? HalfDayType { get; set; }
    public DateTime? InTime { get; set; }
    public DateTime? OutTime { get; set; }
    public decimal? TotalHours { get; set; }
    public decimal OvertimeHours { get; set; }
    public string? Remarks { get; set; }
}

public class MarkAttendanceRequest
{
    public long EmployeeId { get; set; }
    public DateTime AttendanceDate { get; set; }
    public string Status { get; set; } = "Present";
    public string? HalfDayType { get; set; }
    public DateTime? InTime { get; set; }
    public DateTime? OutTime { get; set; }
    public decimal OvertimeHours { get; set; }
    public string? Remarks { get; set; }
}

public class PayrollDto
{
    public long Id { get; set; }
    public string PayrollNumber { get; set; } = string.Empty;
    public long PeriodId { get; set; }
    public string? PeriodName { get; set; }
    public DateTime ProcessDate { get; set; }
    public int TotalEmployees { get; set; }
    public decimal GrossPay { get; set; }
    public decimal TotalDeductions { get; set; }
    public decimal TotalEmployerCost { get; set; }
    public decimal NetPay { get; set; }
    public string Status { get; set; } = string.Empty;
    public List<PayrollDetailDto>? Details { get; set; }
}

public class PayrollDetailDto
{
    public long DetailId { get; set; }
    public long EmployeeId { get; set; }
    public string EmployeeCode { get; set; } = string.Empty;
    public string EmployeeName { get; set; } = string.Empty;
    public int DaysPresent { get; set; }
    public int DaysAbsent { get; set; }
    public int DaysOnLeave { get; set; }
    public decimal OvertimeHours { get; set; }
    public decimal BasicEarned { get; set; }
    public decimal HRA { get; set; }
    public decimal DA { get; set; }
    public decimal GrossEarnings { get; set; }
    public decimal PF_Employee { get; set; }
    public decimal ESI_Employee { get; set; }
    public decimal ProfessionalTax { get; set; }
    public decimal TotalDeductions { get; set; }
    public decimal PF_Employer { get; set; }
    public decimal ESI_Employer { get; set; }
    public decimal NetPay { get; set; }
    public bool IsPaid { get; set; }
}

public class ProcessPayrollRequest
{
    public long CompanyId { get; set; }
    public long PeriodId { get; set; }
}

public class LeaveTypeDto
{
    public long Id { get; set; }
    public string LeaveTypeCode { get; set; } = string.Empty;
    public string LeaveTypeName { get; set; } = string.Empty;
    public decimal DaysPerYear { get; set; }
    public bool IsCarryForward { get; set; }
    public bool IsPaid { get; set; }
    public string? Description { get; set; }
}

public class LeaveBalanceDto
{
    public long Id { get; set; }
    public long EmployeeId { get; set; }
    public string? EmployeeName { get; set; }
    public long LeaveTypeId { get; set; }
    public string? LeaveTypeName { get; set; }
    public int LeaveYear { get; set; }
    public decimal TotalDays { get; set; }
    public decimal UsedDays { get; set; }
    public decimal BalanceDays { get; set; }
}
