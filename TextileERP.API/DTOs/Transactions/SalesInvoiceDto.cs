namespace TextileERP.API.DTOs.Transactions;

public class SalesInvoiceDto
{
    public long SalesInvoiceId { get; set; }
    public long CompanyId { get; set; }
    public string InvoiceNumber { get; set; } = string.Empty;
    public DateTime InvoiceDate { get; set; }
    public long CustomerId { get; set; }
    public string? CustomerName { get; set; }
    public string? CustomerGSTIN { get; set; }
    public string? CustomerPAN { get; set; }
    public string? CustomerStateCode { get; set; }
    public string? CustomerAddress { get; set; }
    public long? SalesOrderId { get; set; }
    public string? ReferenceNumber { get; set; }
    public string? PaymentMode { get; set; }
    public long? ShippingAddressId { get; set; }
    public long? BillingAddressId { get; set; }
    public long? DispatchGodownId { get; set; }
    public string? DispatchGodownName { get; set; }
    public long? TransporterId { get; set; }
    public string? TransporterName { get; set; }
    public long? VehicleId { get; set; }
    public string? VehicleNumber { get; set; }
    public string? LREntryNumber { get; set; }
    public DateTime? ExpectedDeliveryDate { get; set; }
    public DateTime? ActualDeliveryDate { get; set; }
    public decimal? InsuranceAmount { get; set; }
    public decimal? FreightAmount { get; set; }
    public decimal? OtherCharges { get; set; }
    public decimal? RoundOffAmount { get; set; }
    public string? InvoiceStatus { get; set; }
    public bool IsEInvoiceApplicable { get; set; }
    public bool IsEWayBillRequired { get; set; }
    public long? StateId { get; set; }
    public long? FinancialYearId { get; set; }
    public long? SalesPersonId { get; set; }
    public decimal TotalQuantity { get; set; }
    public decimal TotalAmount { get; set; }
    public decimal TotalTaxableAmount { get; set; }
    public decimal TotalCGST { get; set; }
    public decimal TotalSGST { get; set; }
    public decimal TotalIGST { get; set; }
    public decimal TotalCess { get; set; }
    public decimal TotalDiscount { get; set; }
    public decimal NetAmount { get; set; }
    public string? Remarks { get; set; }
    public List<SalesInvoiceDetailDto> Details { get; set; } = new();
}

public class SalesInvoiceDetailDto
{
    public long SalesInvoiceDetailId { get; set; }
    public long SalesInvoiceId { get; set; }
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
    public long? SalesOrderId { get; set; }
    public long? SalesOrderDetailId { get; set; }
    public long? PackingSlipId { get; set; }
    public long? PackingSlipDetailId { get; set; }
    public long? DeliveryChallanId { get; set; }
    public long? DeliveryChallanDetailId { get; set; }
    public string? Remarks { get; set; }
}

public class CreateSalesInvoiceRequest
{
    public long CompanyId { get; set; }
    public long CustomerId { get; set; }
    public string? CustomerStateCode { get; set; }
    public string? ReferenceNumber { get; set; }
    public string? PaymentMode { get; set; }
    public long? ShippingAddressId { get; set; }
    public long? BillingAddressId { get; set; }
    public long? DispatchGodownId { get; set; }
    public long? TransporterId { get; set; }
    public long? VehicleId { get; set; }
    public DateTime? ExpectedDeliveryDate { get; set; }
    public decimal? InsuranceAmount { get; set; }
    public decimal? FreightAmount { get; set; }
    public decimal? OtherCharges { get; set; }
    public long? SalesOrderId { get; set; }
    public long? SalesPersonId { get; set; }
    public string? Remarks { get; set; }
    public List<CreateSalesInvoiceDetailRequest> Details { get; set; } = new();
}

public class CreateSalesInvoiceDetailRequest
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
    public long? SalesOrderId { get; set; }
    public long? SalesOrderDetailId { get; set; }
    public long? DeliveryChallanId { get; set; }
    public long? DeliveryChallanDetailId { get; set; }
    public string? Remarks { get; set; }
}
