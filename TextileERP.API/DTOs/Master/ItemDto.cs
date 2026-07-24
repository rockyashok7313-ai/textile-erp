namespace TextileERP.API.DTOs.Master;

public class ItemDto
{
    public long Id { get; set; }
    public string ItemCode { get; set; } = string.Empty;
    public string ItemName { get; set; } = string.Empty;
    public string? ItemDescription { get; set; }
    public long? ItemCategoryId { get; set; }
    public string? CategoryName { get; set; }
    public long? ParentItemId { get; set; }
    public string? ItemType { get; set; } // Fabric, Yarn, Accessory, Finished, RawMaterial
    public string? HSNCode { get; set; }
    public long? UnitId { get; set; }
    public string? UnitName { get; set; }
    public long? SecondaryUnitId { get; set; }
    public string? SecondaryUnitName { get; set; }
    public decimal? ConversionFactor { get; set; }
    public string? Barcode { get; set; }
    public string? FiberContent { get; set; } // Cotton, Polyester, Mixed
    public string? GSM { get; set; }
    public string? Width { get; set; }
    public string? Color { get; set; }
    public string? ShadeCode { get; set; }
    public string? DesignCode { get; set; }
    public string? RollOrBundle { get; set; }
    public bool IsBatchTracking { get; set; }
    public bool IsSerialTracking { get; set; }
    public bool IsNegativeStockAllowed { get; set; }
    public decimal? MinimumStock { get; set; }
    public decimal? MaximumStock { get; set; }
    public decimal? ReorderLevel { get; set; }
    public decimal? SellingPrice { get; set; }
    public decimal? PurchasePrice { get; set; }
    public decimal? MRP { get; set; }
    public decimal? TaxRate { get; set; }
    public decimal? DiscountPercent { get; set; }
    public bool IsActive { get; set; }
    public string? ImagePath { get; set; }
    public string? Remarks { get; set; }
}

public class CreateItemRequest
{
    public string ItemCode { get; set; } = string.Empty;
    public string ItemName { get; set; } = string.Empty;
    public string? ItemDescription { get; set; }
    public long? ItemCategoryId { get; set; }
    public long? ParentItemId { get; set; }
    public string? ItemType { get; set; }
    public string? HSNCode { get; set; }
    public long? UnitId { get; set; }
    public long? SecondaryUnitId { get; set; }
    public decimal? ConversionFactor { get; set; }
    public string? Barcode { get; set; }
    public string? FiberContent { get; set; }
    public string? GSM { get; set; }
    public string? Width { get; set; }
    public string? Color { get; set; }
    public string? ShadeCode { get; set; }
    public string? DesignCode { get; set; }
    public string? RollOrBundle { get; set; }
    public bool IsBatchTracking { get; set; }
    public bool IsSerialTracking { get; set; }
    public bool IsNegativeStockAllowed { get; set; }
    public decimal? MinimumStock { get; set; }
    public decimal? MaximumStock { get; set; }
    public decimal? ReorderLevel { get; set; }
    public decimal? SellingPrice { get; set; }
    public decimal? PurchasePrice { get; set; }
    public decimal? MRP { get; set; }
    public decimal? TaxRate { get; set; }
    public decimal? DiscountPercent { get; set; }
    public string? Remarks { get; set; }
}

public class ItemSearchRequest
{
    public string? SearchTerm { get; set; }
    public long? CategoryId { get; set; }
    public string? ItemType { get; set; }
    public bool? IsActive { get; set; }
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 25;
}
