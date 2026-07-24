using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Payroll;

public class LeaveType : BaseModel
{
    public string LeaveTypeCode { get; set; } = string.Empty;
    public string LeaveTypeName { get; set; } = string.Empty;
    public decimal DaysPerYear { get; set; }
    public bool IsCarryForward { get; set; }
    public decimal MaxCarryForward { get; set; }
    public bool IsPaid { get; set; } = true;
    public bool IsHalfDayAllowed { get; set; } = true;
    public bool IsEarnedLeave { get; set; }
    public bool IsMaternityLeave { get; set; }
    public bool IsPaternityLeave { get; set; }
    public string? Description { get; set; }
    public int SortOrder { get; set; }
    public virtual Company? Company { get; set; }
}
