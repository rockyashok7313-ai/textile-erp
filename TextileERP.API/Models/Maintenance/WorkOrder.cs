using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Maintenance;

public class WorkOrder : BaseModel
{
    public string WorkOrderNumber { get; set; } = string.Empty;
    public long? RequestId { get; set; }
    public long MachineId { get; set; }
    public string WorkOrderType { get; set; } = "Reactive"; // Reactive, Preventive, Emergency
    public DateTime StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public string? TechnicianName { get; set; }
    public long? TechnicianId { get; set; }
    public string? WorkDescription { get; set; }
    public string? RootCause { get; set; }
    public string? ActionTaken { get; set; }
    public string? Findings { get; set; }
    public string? Recommendations { get; set; }
    public decimal TotalPartsCost { get; set; }
    public decimal TotalLaborCost { get; set; }
    public decimal TotalOutsideCost { get; set; }
    public decimal TotalCost { get; set; }
    public string Status { get; set; } = "Open"; // Open, InProgress, Completed, OnHold, Cancelled
    public long? ApprovedBy { get; set; }
    public DateTime? ApprovedDate { get; set; }
    public bool IsCompleted { get; set; }
    public decimal DowntimeHours { get; set; }
    public string? Remarks { get; set; }

    public virtual MaintenanceRequest? Request { get; set; }
    public virtual Machine? Machine { get; set; }
    public virtual Company? Company { get; set; }
}
