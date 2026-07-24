namespace TextileERP.API.Models.Inventory;

public class StockSummary
{
    [System.ComponentModel.DataAnnotations.Key]
    public long StockId { get; set; }
    public long CompanyId { get; set; }
    public long ItemId { get; set; }
    public long GodownId { get; set; }
    public long? LocationId { get; set; }
    public string? BatchNumber { get; set; }
    public string? LotNumber { get; set; }
    public string? ColorCode { get; set; }
    public string? ShadeCode { get; set; }
    public string? DesignCode { get; set; }
    
    public decimal OpeningQuantity { get; set; }
    public decimal InwardQuantity { get; set; }
    public decimal OutwardQuantity { get; set; }
    public decimal CurrentQuantity { get; set; }
    public decimal ReservedQuantity { get; set; }
    
    public decimal OpeningValue { get; set; }
    public decimal InwardValue { get; set; }
    public decimal OutwardValue { get; set; }
    public decimal CurrentValue { get; set; }
    
    public int RollCount { get; set; }
    public int BundleCount { get; set; }
    public decimal TotalMeters { get; set; }
    public decimal TotalWeight { get; set; }
    
    public DateTime? LastPurchaseDate { get; set; }
    public DateTime? LastSalesDate { get; set; }
    public DateTime? LastManufactureDate { get; set; }
    public DateTime? LastMovementDate { get; set; }
    
    public bool IsNegativeAllowed { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Item? Item { get; set; }
    public virtual Master.Godown? Godown { get; set; }
}

public class StockJournal
{
    [System.ComponentModel.DataAnnotations.Key]
    public long JournalId { get; set; }
    public long CompanyId { get; set; }
    public string JournalNumber { get; set; } = string.Empty;
    public DateTime JournalDate { get; set; }
    public string JournalType { get; set; } = string.Empty; // Transfer, Opening, Physical, Consumption, Production
    public string JournalStatus { get; set; } = "Draft";
    
    public long? FromGodownId { get; set; }
    public long? FromLocationId { get; set; }
    public long? ToGodownId { get; set; }
    public long? ToLocationId { get; set; }
    
    public string? ReferenceType { get; set; }
    public long? ReferenceId { get; set; }
    public string? ReferenceNumber { get; set; }
    
    public string? Reason { get; set; }
    public string? Remarks { get; set; }
    public decimal TotalQuantity { get; set; }
    public decimal TotalValue { get; set; }
    
    public long? ApprovedBy { get; set; }
    public DateTime? ApprovedDate { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    public bool IsCancelled { get; set; }
    public long? CancelledBy { get; set; }
    public DateTime? CancelledDate { get; set; }
    public string? CancelReason { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Godown? FromGodown { get; set; }
    public virtual Master.Godown? ToGodown { get; set; }
    public virtual ICollection<StockJournalDetail>? Details { get; set; }
}

public class StockJournalDetail
{
    [System.ComponentModel.DataAnnotations.Key]
    public long JournalDetailId { get; set; }
    public long JournalId { get; set; }
    public long ItemId { get; set; }
    public string? BatchNumber { get; set; }
    public string? LotNumber { get; set; }
    public string? ColorCode { get; set; }
    public string? ShadeCode { get; set; }
    
    public long? FromGodownId { get; set; }
    public long? FromLocationId { get; set; }
    public string? FromBatchNumber { get; set; }
    
    public long? ToGodownId { get; set; }
    public long? ToLocationId { get; set; }
    public string? ToBatchNumber { get; set; }
    
    public decimal Quantity { get; set; }
    public long UnitId { get; set; }
    public decimal UnitRate { get; set; }
    
    public int? RollCount { get; set; }
    public int? BundleCount { get; set; }
    public decimal? Meters { get; set; }
    public decimal? Weight { get; set; }
    
    public string? ItemRemarks { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual StockJournal? Journal { get; set; }
    public virtual Master.Item? Item { get; set; }
    public virtual Master.Godown? FromGodown { get; set; }
    public virtual Master.Godown? ToGodown { get; set; }
    public virtual Master.Unit? Unit { get; set; }
}
