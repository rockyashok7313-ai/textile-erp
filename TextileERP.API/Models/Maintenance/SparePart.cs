using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Maintenance;

public class SparePart : BaseModel
{
    public string SparePartCode { get; set; } = string.Empty;
    public string SparePartName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? Category { get; set; }  // Mechanical, Electrical, Electronic, Consumable
    public long? UnitId { get; set; }
    public decimal MinStock { get; set; }
    public decimal MaxStock { get; set; }
    public decimal ReorderLevel { get; set; }
    public decimal CurrentStock { get; set; }
    public decimal UnitCost { get; set; }
    public decimal AverageCost { get; set; }
    public int LeadTimeDays { get; set; } = 7;
    public string? CompatibleMachineTypes { get; set; } // AirJet, Sulzer, All
    public string? Manufacturer { get; set; }
    public string? PartNumber { get; set; }
    public string? HSNCode { get; set; }
    public decimal GSTRate { get; set; } = 18;
    public bool IsCriticalSpare { get; set; }
    public int? ShelfLifeDays { get; set; }
    public string? StorageLocation { get; set; }
    public string? PhotoPath { get; set; }

    public virtual Company? Company { get; set; }
}
