namespace TextileERP.API.Models.Payroll;

public class LeaveBalance : BaseModel
{
    public long EmployeeId { get; set; }
    public long LeaveTypeId { get; set; }
    public int LeaveYear { get; set; }
    public decimal TotalDays { get; set; }
    public decimal UsedDays { get; set; }
    public decimal BalanceDays { get; set; }
    public decimal CarryForwardDays { get; set; }
    public decimal AdjustedDays { get; set; }

    public virtual Employee? Employee { get; set; }
    public virtual LeaveType? LeaveType { get; set; }
}
