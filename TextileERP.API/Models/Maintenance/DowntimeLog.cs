using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Maintenance;

public class DowntimeLog : BaseModel
{
    public long MachineId { get; set; }
    public DateTime StartDateTime { get; set; }
    public DateTime? EndDateTime { get; set; }
    public decimal DurationMinutes { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string Category { get; set; } = "Breakdown"; // Breakdown, Repair, Inspection, Setup, Idle
    public bool IsPlanned { get; set; }
    public long? WorkOrderId { get; set; }
    public long? RequestId { get; set; }
    public decimal? ProductionLossMeters { get; set; }
    public decimal? ProductionLossPieces { get; set; }
    public decimal? EstimatedCostImpact { get; set; }
    public long? ReportedById { get; set; }

    public virtual Machine? Machine { get; set; }
    public virtual WorkOrder? WorkOrder { get; set; }
    public virtual Company? Company { get; set; }
}
