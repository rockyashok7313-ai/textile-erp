using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Payroll;

public class PayrollHeader : BaseModel
{
    public long PeriodId { get; set; }
    public string PayrollNumber { get; set; } = string.Empty;
    public DateTime ProcessDate { get; set; }
    public int TotalEmployees { get; set; }
    public int TotalDaysWorked { get; set; }
    public decimal TotalOvertimeHours { get; set; }
    public int TotalLeaves { get; set; }
    public decimal GrossPay { get; set; }
    public decimal TotalEarnings { get; set; }
    public decimal TotalDeductions { get; set; }
    public decimal TotalEmployerCost { get; set; }
    public decimal NetPay { get; set; }
    public string Status { get; set; } = "Draft"; // Draft, Approved, Paid, Cancelled
    public long? ApprovedBy { get; set; }
    public DateTime? ApprovedDate { get; set; }
    public long? PaidBy { get; set; }
    public DateTime? PaidDate { get; set; }
    public string? Remarks { get; set; }

    public virtual PayrollPeriod? Period { get; set; }
    public virtual Company? Company { get; set; }
}
