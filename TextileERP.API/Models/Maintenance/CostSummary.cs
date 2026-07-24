using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Maintenance;

public class CostSummary : BaseModel
{
    public long MachineId { get; set; }
    public int PeriodMonth { get; set; }
    public int PeriodYear { get; set; }
    public int TotalWorkOrders { get; set; }
    public int ReactiveWorkOrders { get; set; }
    public decimal PartsCost { get; set; }
    public decimal LaborCost { get; set; }
    public decimal OutsideCost { get; set; }
    public decimal TotalCost { get; set; }
    public decimal DowntimeHours { get; set; }
    public decimal DowntimeCost { get; set; }
    public decimal AverageRepairTime { get; set; }
    public decimal? MTBF_Hours { get; set; }   // Mean Time Between Failures
    public decimal? MTTR_Hours { get; set; }   // Mean Time To Repair
    public decimal? AvailabilityPercent { get; set; }

    public virtual Machine? Machine { get; set; }
    public virtual Company? Company { get; set; }
}
