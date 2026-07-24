namespace TextileERP.API.Models.Purchase;

public class PurchaseInvoice
{
    public long PurchaseInvoiceId { get; set; }
    public long CompanyId { get; set; }
    public string InvoiceNumber { get; set; } = string.Empty;
    public DateTime InvoiceDate { get; set; }
    public DateTime? DueDate { get; set; }
    public string InvoiceStatus { get; set; } = "Draft";
    
    public long SupplierId { get; set; }
    public string? SupplierGSTIN { get; set; }
    public string? SupplierStateCode { get; set; }
    public string? SupplierInvoiceNumber { get; set; }
    public DateTime? SupplierInvoiceDate { get; set; }
    
    public string? BillingAddress { get; set; }
    public string? ShippingAddress { get; set; }
    
    public long? ReceivedGodownId { get; set; }
    public DateTime? DeliveryDate { get; set; }
    
    public bool IsInterState { get; set; }
    public bool IsReverseCharge { get; set; }
    public string? PlaceOfSupply { get; set; }
    public string? PlaceOfSupplyStateCode { get; set; }
    
    public decimal TotalQuantity { get; set; }
    public decimal TotalAmount { get; set; }
    public decimal TotalDiscount { get; set; }
    public decimal TotalTaxableAmount { get; set; }
    public decimal TotalCGST { get; set; }
    public decimal TotalSGST { get; set; }
    public decimal TotalIGST { get; set; }
    public decimal TotalCess { get; set; }
    public decimal TotalTDS { get; set; }
    public decimal TotalTCS { get; set; }
    public decimal GrossAmount { get; set; }
    public decimal RoundOff { get; set; }
    public decimal NetAmount { get; set; }
    
    public decimal AmountPaid { get; set; }
    public string? CurrencyCode { get; set; } = "INR";
    public decimal ExchangeRate { get; set; } = 1;
    
    public long? PurchaseOrderId { get; set; }
    public string? ReferenceNumber { get; set; }
    public string? ProjectCode { get; set; }
    
    public string? PaymentTerms { get; set; }
    public string? Remarks { get; set; }
    public string? InternalRemarks { get; set; }
    
    public string? ITCStatus { get; set; } = "Eligible";
    public string? ITCReason { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    public long? PostedBy { get; set; }
    public DateTime? PostedDate { get; set; }
    public bool IsCancelled { get; set; }
    public long? CancelledBy { get; set; }
    public DateTime? CancelledDate { get; set; }
    public string? CancelReason { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Party? Supplier { get; set; }
    public virtual Master.Godown? ReceivedGodown { get; set; }
    public virtual PurchaseOrder? PurchaseOrder { get; set; }
    public virtual ICollection<PurchaseInvoiceDetail>? Details { get; set; }
}

public class PurchaseInvoiceDetail
{
    public long PurchaseInvoiceDetailId { get; set; }
    public long PurchaseInvoiceId { get; set; }
    public int LineNumber { get; set; }
    public long ItemId { get; set; }
    public string? ItemDescription { get; set; }
    public string HSNCode { get; set; } = string.Empty;
    
    public decimal Quantity { get; set; }
    public long UnitId { get; set; }
    
    public decimal Rate { get; set; }
    public decimal DiscountPercent { get; set; }
    public decimal DiscountAmount { get; set; }
    public decimal BasicAmount { get; set; }
    
    public decimal GSTRate { get; set; }
    public decimal CGSTRate { get; set; }
    public decimal CGSTAmount { get; set; }
    public decimal SGSTRate { get; set; }
    public decimal SGSTAmount { get; set; }
    public decimal IGSTRate { get; set; }
    public decimal IGSTAmount { get; set; }
    public decimal CessRate { get; set; }
    public decimal CessAmount { get; set; }
    
    public bool TDSApplicable { get; set; }
    public decimal TDSRate { get; set; }
    public decimal TDSAmount { get; set; }
    public bool TCSApplicable { get; set; }
    public decimal TCSRate { get; set; }
    public decimal TCSAmount { get; set; }
    
    public decimal TaxableAmount { get; set; }
    public decimal TotalAmount { get; set; }
    
    public string? ColorCode { get; set; }
    public string? ColorName { get; set; }
    public string? ShadeCode { get; set; }
    public string? DesignCode { get; set; }
    public decimal? Width { get; set; }
    public decimal? GSM { get; set; }
    public string? QualityGrade { get; set; }
    public string? BatchNumber { get; set; }
    
    public long? PurchaseOrderDetailId { get; set; }
    
    public string? ItemRemarks { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual PurchaseInvoice? PurchaseInvoice { get; set; }
    public virtual Master.Item? Item { get; set; }
    public virtual Master.Unit? Unit { get; set; }
    public virtual PurchaseOrderDetail? PurchaseOrderDetail { get; set; }
}
