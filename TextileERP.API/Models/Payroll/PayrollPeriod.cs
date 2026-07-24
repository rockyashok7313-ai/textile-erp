using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Payroll;

public class PayrollPeriod : BaseModel
{
    public string PeriodName { get; set; } = string.Empty;  // Apr-2025
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string Status { get; set; } = "Open"; // Open, Processing, Closed, Paid
    public long? ProcessedBy { get; set; }
    public DateTime? ProcessedDate { get; set; }
    public long? ClosedBy { get; set; }
    public DateTime? ClosedDate { get; set; }
    public string? Remarks { get; set; }
    public virtual Company? Company { get; set; }
}
