namespace TextileERP.API.Models.Sales;

public class SalesInvoice
{
    public long SalesInvoiceId { get; set; }
    public long CompanyId { get; set; }
    public string InvoiceNumber { get; set; } = string.Empty;
    public DateTime InvoiceDate { get; set; }
    public DateTime? DueDate { get; set; }
    public string InvoiceType { get; set; } = "Regular";
    public string InvoiceStatus { get; set; } = "Draft";
    
    public long CustomerId { get; set; }
    public string? CustomerGSTIN { get; set; }
    public string? CustomerPAN { get; set; }
    public string? CustomerStateCode { get; set; }
    public string? CustomerName { get; set; }
    public string? ContactPerson { get; set; }
    
    public string? BillingAddress { get; set; }
    public string? ShippingAddress { get; set; }
    public long? ShippingAddressId { get; set; }
    
    public long? DispatchGodownId { get; set; }
    public DateTime? DeliveryDate { get; set; }
    public string? DeliveryChallanNumber { get; set; }
    
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
    
    public decimal AmountReceived { get; set; }
    public string CurrencyCode { get; set; } = "INR";
    public decimal ExchangeRate { get; set; } = 1;
    
    public long? SalesOrderId { get; set; }
    public long? ProformaInvoiceId { get; set; }
    public string? CustomerPONumber { get; set; }
    public DateTime? CustomerPODate { get; set; }
    public string? ReferenceNumber { get; set; }
    public string? ProjectCode { get; set; }
    
    public string? EWayBillNumber { get; set; }
    public DateTime? EWayBillDate { get; set; }
    public DateTime? EWayBillValidUpto { get; set; }
    public bool IsEWayBillRequired { get; set; }
    
    public string? IRN { get; set; }
    public DateTime? IRNDate { get; set; }
    public string? EInvoiceAckNumber { get; set; }
    public string? EInvoiceQRCode { get; set; }
    public bool IsEInvoiceRequired { get; set; }
    public string? EInvoiceStatus { get; set; } = "NotGenerated";
    
    public bool IsExport { get; set; }
    public string? ExportType { get; set; }
    public string? ShippingBillNumber { get; set; }
    public DateTime? ShippingBillDate { get; set; }
    public string? PortCode { get; set; }
    public decimal? FOBValue { get; set; }
    
    public string? PaymentTerms { get; set; }
    public string? DeliveryTerms { get; set; }
    public string? Remarks { get; set; }
    public string? InternalRemarks { get; set; }
    
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
    public virtual Master.Party? Customer { get; set; }
    public virtual Master.Godown? DispatchGodown { get; set; }
    public virtual SalesOrder? SalesOrder { get; set; }
    public virtual ProformaInvoice? ProformaInvoice { get; set; }
    public virtual ICollection<SalesInvoiceDetail>? Details { get; set; }
}

public class SalesInvoiceDetail
{
    public long SalesInvoiceDetailId { get; set; }
    public long SalesInvoiceId { get; set; }
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
    public string? DesignName { get; set; }
    public decimal? Width { get; set; }
    public decimal? GSM { get; set; }
    public string? QualityGrade { get; set; }
    public string? BatchNumber { get; set; }
    
    public long? SalesOrderDetailId { get; set; }
    public long? ProformaInvoiceDetailId { get; set; }
    
    public string? ItemRemarks { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual SalesInvoice? SalesInvoice { get; set; }
    public virtual Master.Item? Item { get; set; }
    public virtual Master.Unit? Unit { get; set; }
    public virtual SalesOrderDetail? SalesOrderDetail { get; set; }
}

public class SalesOrder
{
    public long SalesOrderId { get; set; }
    public long CompanyId { get; set; }
    public string OrderNumber { get; set; } = string.Empty;
    public DateTime OrderDate { get; set; }
    public DateTime? ExpectedDate { get; set; }
    public DateTime? DeliveryDate { get; set; }
    public string OrderStatus { get; set; } = "Draft";
    
    public long CustomerId { get; set; }
    public string? CustomerGSTIN { get; set; }
    public string? CustomerStateCode { get; set; }
    public string? ContactPerson { get; set; }
    public string? ContactPhone { get; set; }
    
    public string? BillingAddress { get; set; }
    public string? ShippingAddress { get; set; }
    public long? ShippingAddressId { get; set; }
    
    public long? DispatchGodownId { get; set; }
    public DateTime? ExpectedDeliveryDate { get; set; }
    
    public bool IsInterState { get; set; }
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
    
    public string? ReferenceNumber { get; set; }
    public string? CustomerPONumber { get; set; }
    public DateTime? CustomerPODate { get; set; }
    public string? ProjectCode { get; set; }
    
    public string? PaymentTerms { get; set; }
    public string? DeliveryTerms { get; set; }
    public string? Remarks { get; set; }
    public string? InternalRemarks { get; set; }
    
    public long? ApprovedBy { get; set; }
    public DateTime? ApprovedDate { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    public bool IsCancelled { get; set; }
    public long? CancelledBy { get; set; }
    public DateTime? CancelledDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Party? Customer { get; set; }
    public virtual Master.Godown? DispatchGodown { get; set; }
    public virtual ICollection<SalesOrderDetail>? Details { get; set; }
}

public class SalesOrderDetail
{
    public long SalesOrderDetailId { get; set; }
    public long SalesOrderId { get; set; }
    public int LineNumber { get; set; }
    public long ItemId { get; set; }
    public string? ItemDescription { get; set; }
    public string HSNCode { get; set; } = string.Empty;
    
    public decimal OrderedQuantity { get; set; }
    public decimal DeliveredQuantity { get; set; }
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
    public string? DesignName { get; set; }
    public decimal? Width { get; set; }
    public decimal? GSM { get; set; }
    public string? QualityGrade { get; set; }
    
    public string? ItemRemarks { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual SalesOrder? SalesOrder { get; set; }
    public virtual Master.Item? Item { get; set; }
    public virtual Master.Unit? Unit { get; set; }
}

public class ProformaInvoice
{
    public long ProformaInvoiceId { get; set; }
    public long CompanyId { get; set; }
    public string InvoiceNumber { get; set; } = string.Empty;
    public DateTime InvoiceDate { get; set; }
    public DateTime? ValidUntilDate { get; set; }
    public string InvoiceStatus { get; set; } = "Draft";
    
    public long CustomerId { get; set; }
    public string? CustomerGSTIN { get; set; }
    public string? CustomerStateCode { get; set; }
    public string? ContactPerson { get; set; }
    
    public string? BillingAddress { get; set; }
    public string? ShippingAddress { get; set; }
    
    public bool IsInterState { get; set; }
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
    public decimal NetAmount { get; set; }
    
    public long? SalesOrderId { get; set; }
    public string? ReferenceNumber { get; set; }
    public string? CustomerPONumber { get; set; }
    
    public string? PaymentTerms { get; set; }
    public string? DeliveryTerms { get; set; }
    public string? Remarks { get; set; }
    
    public bool ConvertedToSalesInvoice { get; set; }
    public long? SalesInvoiceId { get; set; }
    public DateTime? ConversionDate { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    public bool IsCancelled { get; set; }
    public long? CancelledBy { get; set; }
    public DateTime? CancelledDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Party? Customer { get; set; }
    public virtual SalesOrder? SalesOrder { get; set; }
    public virtual ICollection<ProformaInvoiceDetail>? Details { get; set; }
}

public class ProformaInvoiceDetail
{
    public long ProformaInvoiceDetailId { get; set; }
    public long ProformaInvoiceId { get; set; }
    public int LineNumber { get; set; }
    public long ItemId { get; set; }
    public string HSNCode { get; set; } = string.Empty;
    public decimal Quantity { get; set; }
    public long UnitId { get; set; }
    public decimal Rate { get; set; }
    public decimal DiscountPercent { get; set; }
    public decimal DiscountAmount { get; set; }
    public decimal BasicAmount { get; set; }
    public decimal GSTRate { get; set; }
    public decimal CGSTAmount { get; set; }
    public decimal SGSTAmount { get; set; }
    public decimal IGSTAmount { get; set; }
    public decimal CessAmount { get; set; }
    public decimal TaxableAmount { get; set; }
    public decimal TotalAmount { get; set; }
    public string? ColorCode { get; set; }
    public string? ShadeCode { get; set; }
    public string? DesignCode { get; set; }
    public decimal? Width { get; set; }
    public decimal? GSM { get; set; }
    public string? QualityGrade { get; set; }
    public long? SalesOrderDetailId { get; set; }
    public string? ItemRemarks { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual ProformaInvoice? ProformaInvoice { get; set; }
    public virtual Master.Item? Item { get; set; }
    public virtual Master.Unit? Unit { get; set; }
}
