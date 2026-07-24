namespace TextileERP.API.Models.Payroll;

public class PayrollDetail : BaseModel
{
    public long PayrollId { get; set; }
    public long EmployeeId { get; set; }
    public string EmployeeCode { get; set; } = string.Empty;
    public string EmployeeName { get; set; } = string.Empty;
    public long? DepartmentId { get; set; }
    public long? DesignationId { get; set; }

    // Attendance
    public int DaysInMonth { get; set; } = 30;
    public int WorkingDays { get; set; }
    public int DaysPresent { get; set; }
    public int DaysAbsent { get; set; }
    public int DaysOnLeave { get; set; }
    public int Holidays { get; set; }
    public int WeeklyOffs { get; set; }
    public decimal OvertimeHours { get; set; }

    // Earnings
    public decimal BasicSalary { get; set; }
    public decimal BasicEarned { get; set; }
    public decimal HRA { get; set; }
    public decimal DA { get; set; }
    public decimal ConveyanceAllowance { get; set; }
    public decimal MedicalAllowance { get; set; }
    public decimal SpecialAllowance { get; set; }
    public decimal OtherAllowance { get; set; }
    public decimal OvertimeAmount { get; set; }
    public decimal LeaveEncashment { get; set; }
    public decimal Bonus { get; set; }
    public decimal GrossEarnings { get; set; }

    // Deductions
    public decimal PF_Employee { get; set; }
    public decimal ESI_Employee { get; set; }
    public decimal ProfessionalTax { get; set; }
    public decimal TDS { get; set; }
    public decimal LoanDeduction { get; set; }
    public decimal AdvanceDeduction { get; set; }
    public decimal OtherDeductions { get; set; }
    public decimal TotalDeductions { get; set; }

    // Employer
    public decimal PF_Employer { get; set; }
    public decimal ESI_Employer { get; set; }
    public decimal TotalEmployerCost { get; set; }

    // Net
    public decimal NetPay { get; set; }
    public string? AmountInWords { get; set; }

    // Payment
    public string? PaymentMode { get; set; }
    public string? BankAccountNumber { get; set; }
    public string? ChequeNumber { get; set; }
    public DateTime? PaymentDate { get; set; }
    public bool IsPaid { get; set; }

    public string? Remarks { get; set; }

    public virtual PayrollHeader? Payroll { get; set; }
    public virtual Employee? Employee { get; set; }
}
