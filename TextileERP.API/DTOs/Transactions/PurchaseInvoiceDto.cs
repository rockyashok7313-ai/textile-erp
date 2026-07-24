namespace TextileERP.API.DTOs.Transactions;

public class PurchaseInvoiceDto
{
    public long PurchaseInvoiceId { get; set; }
    public long CompanyId { get; set; }
    public string InvoiceNumber { get; set; } = string.Empty;
    public DateTime InvoiceDate { get; set; }
    public long SupplierId { get; set; }
    public string? SupplierName { get; set; }
    public string? SupplierGSTIN { get; set; }
    public string? SupplierPAN { get; set; }
    public string? SupplierStateCode { get; set; }
    public string? SupplierAddress { get; set; }
    public string? ReferenceNumber { get; set; }
    public string? SupplierInvoiceNumber { get; set; }
    public DateTime? SupplierInvoiceDate { get; set; }
    public long? PurchaseOrderId { get; set; }
    public long? GRNId { get; set; }
    public long? ReceivedGodownId { get; set; }
    public string? ReceivedGodownName { get; set; }
    public long? TransporterId { get; set; }
    public string? TransporterName { get; set; }
    public long? VehicleId { get; set; }
    public string? VehicleNumber { get; set; }
    public string? LREntryNumber { get; set; }
    public decimal? InsuranceAmount { get; set; }
    public decimal? FreightAmount { get; set; }
    public decimal? OtherCharges { get; set; }
    public decimal? RoundOffAmount { get; set; }
    public string? InvoiceStatus { get; set; }
    public long? StateId { get; set; }
    public long? FinancialYearId { get; set; }
    public decimal TotalQuantity { get; set; }
    public decimal TotalAmount { get; set; }
    public decimal TotalTaxableAmount { get; set; }
    public decimal TotalCGST { get; set; }
    public decimal TotalSGST { get; set; }
    public decimal TotalIGST { get; set; }
    public decimal TotalCess { get; set; }
    public decimal NetAmount { get; set; }
    public string? Remarks { get; set; }
    public List<PurchaseInvoiceDetailDto> Details { get; set; } = new();
}

public class PurchaseInvoiceDetailDto
{
    public long PurchaseInvoiceDetailId { get; set; }
    public long PurchaseInvoiceId { get; set; }
    public int SerialNumber { get; set; }
    public long ItemId { get; set; }
    public string? ItemCode { get; set; }
    public string? ItemName { get; set; }
    public string? Description { get; set; }
    public long? HSNId { get; set; }
    public string? HSNCode { get; set; }
    public long? UnitId { get; set; }
    public string? UnitName { get; set; }
    public long? QuantityUnitId { get; set; }
    public long? WeightUnitId { get; set; }
    public long? LengthUnitId { get; set; }
    public long? BatchId { get; set; }
    public string? BatchNumber { get; set; }
    public long? GodownId { get; set; }
    public string? GodownName { get; set; }
    public long? GodownLocationId { get; set; }
    public string? RollOrBundleNumber { get; set; }
    public decimal Quantity { get; set; }
    public decimal? Weight { get; set; }
    public decimal? Length { get; set; }
    public decimal? Width { get; set; }
    public decimal? GSM { get; set; }
    public decimal Rate { get; set; }
    public string? RatePer { get; set; }
    public decimal BasicAmount { get; set; }
    public decimal? DiscountPercent { get; set; }
    public decimal? DiscountAmount { get; set; }
    public decimal? SpecialDiscount { get; set; }
    public decimal? SchemeDiscount { get; set; }
    public long? GSTRateId { get; set; }
    public decimal GSTRate { get; set; }
    public decimal TaxableAmount { get; set; }
    public decimal CGSTAmount { get; set; }
    public decimal SGSTAmount { get; set; }
    public decimal IGSTAmount { get; set; }
    public decimal? CessRate { get; set; }
    public decimal CessAmount { get; set; }
    public decimal TotalAmount { get; set; }
    public long? PurchaseOrderId { get; set; }
    public long? PurchaseOrderDetailId { get; set; }
    public long? GRNId { get; set; }
    public long? GRNDetailId { get; set; }
    public string? Remarks { get; set; }
}

public class CreatePurchaseInvoiceRequest
{
    public long CompanyId { get; set; }
    public long SupplierId { get; set; }
    public string? SupplierStateCode { get; set; }
    public string? ReferenceNumber { get; set; }
    public string? SupplierInvoiceNumber { get; set; }
    public DateTime? SupplierInvoiceDate { get; set; }
    public long? PurchaseOrderId { get; set; }
    public long? GRNId { get; set; }
    public long? ReceivedGodownId { get; set; }
    public long? TransporterId { get; set; }
    public long? VehicleId { get; set; }
    public decimal? InsuranceAmount { get; set; }
    public decimal? FreightAmount { get; set; }
    public decimal? OtherCharges { get; set; }
    public string? Remarks { get; set; }
    public List<CreatePurchaseInvoiceDetailRequest> Details { get; set; } = new();
}

public class CreatePurchaseInvoiceDetailRequest
{
    public long ItemId { get; set; }
    public string? Description { get; set; }
    public long? HSNId { get; set; }
    public long? UnitId { get; set; }
    public long? QuantityUnitId { get; set; }
    public long? BatchId { get; set; }
    public long? GodownId { get; set; }
    public long? GodownLocationId { get; set; }
    public string? RollOrBundleNumber { get; set; }
    public decimal Quantity { get; set; }
    public decimal Rate { get; set; }
    public string? RatePer { get; set; }
    public decimal? DiscountPercent { get; set; }
    public decimal? DiscountAmount { get; set; }
    public long? GSTRateId { get; set; }
    public long? PurchaseOrderId { get; set; }
    public long? PurchaseOrderDetailId { get; set; }
    public long? GRNId { get; set; }
    public long? GRNDetailId { get; set; }
    public string? Remarks { get; set; }
}
