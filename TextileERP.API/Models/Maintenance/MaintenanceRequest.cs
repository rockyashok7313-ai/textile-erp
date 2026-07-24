using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Maintenance;

public class MaintenanceRequest : BaseModel
{
    public string RequestNumber { get; set; } = string.Empty;
    public long MachineId { get; set; }
    public DateTime RequestDate { get; set; }
    public long? ReportedById { get; set; }
    public string FaultDescription { get; set; } = string.Empty;
    public string? FaultCategory { get; set; }  // Mechanical, Electrical, Electronic, Other
    public string Priority { get; set; } = "Medium"; // Low, Medium, High, Critical
    public string Status { get; set; } = "Open";   // Open, Assigned, InProgress, Completed, Cancelled
    public long? AssignedToId { get; set; }
    public string? AssignedTechnician { get; set; }
    public DateTime? AssignedDate { get; set; }
    public DateTime? ExpectedCompletionDate { get; set; }
    public DateTime? ActualCompletionDate { get; set; }
    public long? WorkOrderId { get; set; }
    public string? CompletionRemarks { get; set; }
    public decimal? EstimatedCost { get; set; }
    public decimal? ActualCost { get; set; }
    public bool IsEmergency { get; set; }
    public string? Photos { get; set; }
    public string? Remarks { get; set; }

    public virtual Machine? Machine { get; set; }
    public virtual Company? Company { get; set; }
}
