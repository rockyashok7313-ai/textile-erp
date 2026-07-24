namespace TextileERP.API.Models.Maintenance;

public class WorkOrderSparePart : BaseModel
{
    public long WorkOrderId { get; set; }
    public long SparePartId { get; set; }
    public decimal QuantityUsed { get; set; }
    public decimal UnitCost { get; set; }
    public decimal TotalCost { get; set; }
    public bool IsReturned { get; set; }
    public decimal ReturnQuantity { get; set; }

    public virtual WorkOrder? WorkOrder { get; set; }
    public virtual SparePart? SparePart { get; set; }
}
