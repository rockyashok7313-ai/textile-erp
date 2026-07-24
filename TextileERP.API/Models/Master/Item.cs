namespace TextileERP.API.Models.Master;

public class Item : BaseModel
{
    public string ItemCode { get; set; } = string.Empty;
    public string ItemName { get; set; } = string.Empty;
    public string? ItemDescription { get; set; }
    public string? ShortName { get; set; }
    public string? Barcode { get; set; }
    public long? CategoryId { get; set; }
    public long? SubCategoryId { get; set; }
    public long? ItemGroupId { get; set; }
    
    public string HSNCode { get; set; } = string.Empty;
    public long? GSTGroupId { get; set; }
    public decimal GSTRate { get; set; }
    public decimal CessRate { get; set; }
    public bool IsGSTApplicable { get; set; } = true;
    public bool IsCessApplicable { get; set; }
    
    public long BaseUnitId { get; set; }
    public long? PurchaseUnitId { get; set; }
    public long? SalesUnitId { get; set; }
    public long? ProductionUnitId { get; set; }
    public decimal UnitConversionFactor { get; set; } = 1;
    
    public decimal PurchaseRate { get; set; }
    public decimal SalesRate { get; set; }
    public decimal MRP { get; set; }
    public decimal WholesaleRate { get; set; }
    public decimal RetailRate { get; set; }
    public decimal JobWorkRate { get; set; }
    public string CostingMethod { get; set; } = "FIFO";
    
    // Textile Specific Fields
    public string? FabricType { get; set; }
    public string? FiberContent { get; set; }
    public string? FiberComposition1 { get; set; }
    public string? FiberComposition2 { get; set; }
    public decimal? GSM { get; set; }
    public decimal? Width { get; set; }
    public string? WidthUnit { get; set; } = "cm";
    public decimal? LengthPerRoll { get; set; }
    public decimal? WeightPerRoll { get; set; }
    public int? RollsPerBundle { get; set; } = 1;
    public int? BundlesPerCarton { get; set; } = 1;
    public string? ColorCode { get; set; }
    public string? ColorName { get; set; }
    public string? ShadeCode { get; set; }
    public string? DesignCode { get; set; }
    public string? DesignName { get; set; }
    public string? QualityGrade { get; set; }
    public decimal? ShrinkagePercent { get; set; }
    public decimal? WastagePercent { get; set; }
    
    public bool IsBatchTracked { get; set; }
    public bool IsSerialTracked { get; set; }
    public bool IsExpiryTracked { get; set; }
    public bool IsNegativeStockAllowed { get; set; }
    
    public decimal MinimumStockLevel { get; set; }
    public decimal MaximumStockLevel { get; set; }
    public decimal ReorderLevel { get; set; }
    public decimal ReorderQuantity { get; set; }
    public decimal SafetyStock { get; set; }
    public int LeadTimeDays { get; set; }
    
    public bool IsPurchaseItem { get; set; } = true;
    public bool IsSalesItem { get; set; } = true;
    public bool IsProductionItem { get; set; }
    public bool IsJobWorkItem { get; set; }
    public bool IsServiceItem { get; set; }
    public bool IsComponentItem { get; set; }
    public bool IsRawMaterial { get; set; }
    public bool IsFinishedGood { get; set; }
    public bool IsSemiFinished { get; set; }
    public bool IsConsumable { get; set; }
    public bool IsCapitalGoods { get; set; }
    
    public bool IsEWayBillApplicable { get; set; } = true;
    public bool IsEInvoiceApplicable { get; set; } = true;
    
    public string? PrimaryImagePath { get; set; }
    
    public bool IsDiscontinued { get; set; }
    public DateTime? DiscontinuedDate { get; set; }
    
    // Navigation properties
    public virtual ItemCategory? Category { get; set; }
    public virtual Unit? BaseUnit { get; set; }
    public virtual Company? Company { get; set; }
}
