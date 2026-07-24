namespace TextileERP.API.Models.Compliance;

public class EWayBill
{
    public long EWayBillId { get; set; }
    public long CompanyId { get; set; }
    public string? EWayBillNumber { get; set; }
    public DateTime EWayBillDate { get; set; }
    public DateTime? EWayBillValidUpto { get; set; }
    public string EWayBillStatus { get; set; } = "Pending";
    
    public string InvoiceType { get; set; } = string.Empty;
    public long InvoiceId { get; set; }
    public string InvoiceNumber { get; set; } = string.Empty;
    public DateTime InvoiceDate { get; set; }
    public decimal InvoiceValue { get; set; }
    
    public string SupplierGSTIN { get; set; } = string.Empty;
    public string SupplierStateCode { get; set; } = string.Empty;
    public string? SupplierAddress { get; set; }
    public string? SupplierPinCode { get; set; }
    
    public string? RecipientGSTIN { get; set; }
    public string RecipientStateCode { get; set; } = string.Empty;
    public string? RecipientAddress { get; set; }
    public string? RecipientPinCode { get; set; }
    public string? RecipientName { get; set; }
    
    public string PlaceOfSupplyCode { get; set; } = string.Empty;
    public string? PlaceOfSupplyPinCode { get; set; }
    
    public int DistanceKm { get; set; }
    public string? FromPinCode { get; set; }
    public string? ToPinCode { get; set; }
    
    public string HSNCode { get; set; } = string.Empty;
    public string? HSNDescription { get; set; }
    public decimal Quantity { get; set; }
    public string UQC { get; set; } = string.Empty;
    
    public string TransportMode { get; set; } = "Road";
    public string? TransporterID { get; set; }
    public string? TransporterName { get; set; }
    public string? TransporterGSTIN { get; set; }
    
    public string DocumentType { get; set; } = "TaxInvoice";
    public string DocumentNumber { get; set; } = string.Empty;
    public DateTime DocumentDate { get; set; }
    
    public string? VehicleNumber { get; set; }
    public string? VehicleType { get; set; } = "Regular";
    public string? DriverName { get; set; }
    public string? DriverLicenseNo { get; set; }
    public string? DriverMobile { get; set; }
    
    public decimal TaxableAmount { get; set; }
    public decimal CGSTAmount { get; set; }
    public decimal SGSTAmount { get; set; }
    public decimal IGSTAmount { get; set; }
    public decimal CessAmount { get; set; }
    public decimal OtherAmount { get; set; }
    public decimal TotalValue { get; set; }
    
    public bool IsConsolidated { get; set; }
    public long? ParentEWayBillId { get; set; }
    
    public DateTime? CancelledDate { get; set; }
    public long? CancelledBy { get; set; }
    public string? CancelReason { get; set; }
    public DateTime? RejectedDate { get; set; }
    public long? RejectedBy { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual EWayBill? ParentEWayBill { get; set; }
    public virtual ICollection<EWayBillVehicle>? Vehicles { get; set; }
}

public class EWayBillVehicle
{
    public long EWayBillVehicleId { get; set; }
    public long EWayBillId { get; set; }
    public string VehicleNumber { get; set; } = string.Empty;
    public string VehicleType { get; set; } = "Regular";
    public string? DriverName { get; set; }
    public string? DriverLicenseNo { get; set; }
    public string? DriverMobile { get; set; }
    public string? FromPlace { get; set; }
    public string? FromStateCode { get; set; }
    public string? ToPlace { get; set; }
    public string? ToStateCode { get; set; }
    public decimal? Quantity { get; set; }
    public bool IsPrimary { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual EWayBill? EWayBill { get; set; }
}

public class EInvoice
{
    public long EInvoiceId { get; set; }
    public long CompanyId { get; set; }
    public string? IRN { get; set; }
    public DateTime? IRNDate { get; set; }
    public string? AcknowledgementNumber { get; set; }
    public DateTime? AcknowledgementDate { get; set; }
    public string EInvoiceStatus { get; set; } = "Pending";
    
    public string InvoiceType { get; set; } = string.Empty;
    public long InvoiceId { get; set; }
    public string InvoiceNumber { get; set; } = string.Empty;
    public DateTime InvoiceDate { get; set; }
    public string InvoiceCategory { get; set; } = "B2B";
    public string DocumentType { get; set; } = "INV";
    
    public string SupplierGSTIN { get; set; } = string.Empty;
    public string? SupplierLegalName { get; set; }
    public string? SupplierTradeName { get; set; }
    public string? SupplierAddress { get; set; }
    public string? SupplierCity { get; set; }
    public string SupplierStateCode { get; set; } = string.Empty;
    public string? SupplierPinCode { get; set; }
    public string? SupplierPhone { get; set; }
    public string? SupplierEmail { get; set; }
    
    public string? RecipientGSTIN { get; set; }
    public string? RecipientLegalName { get; set; }
    public string? RecipientTradeName { get; set; }
    public string? RecipientAddress { get; set; }
    public string? RecipientCity { get; set; }
    public string RecipientStateCode { get; set; } = string.Empty;
    public string RecipientPinCode { get; set; } = string.Empty;
    public string? RecipientPhone { get; set; }
    public string? RecipientEmail { get; set; }
    
    public string PlaceOfSupplyCode { get; set; } = string.Empty;
    public string? PlaceOfSupplyName { get; set; }
    
    public int TotalItemLines { get; set; }
    public decimal TotalQuantity { get; set; }
    
    public decimal TaxableAmount { get; set; }
    public decimal CGSTAmount { get; set; }
    public decimal SGSTAmount { get; set; }
    public decimal IGSTAmount { get; set; }
    public decimal CessAmount { get; set; }
    public decimal CessNonAdvolAmount { get; set; }
    public decimal OtherCharges { get; set; }
    public decimal Discount { get; set; }
    public bool PreGST { get; set; }
    public decimal RoundOffAmount { get; set; }
    public decimal TotalInvoiceValue { get; set; }
    
    public bool IsExport { get; set; }
    public string? ExportType { get; set; }
    public string? ShippingBillNumber { get; set; }
    public DateTime? ShippingBillDate { get; set; }
    public string? PortCode { get; set; }
    public decimal? FOBValue { get; set; }
    public string? CountryCode { get; set; }
    
    public bool IsReverseCharge { get; set; }
    
    public string? QRCode { get; set; }
    public string? QRCodeImagePath { get; set; }
    
    public string? EWayBillNumber { get; set; }
    public bool EWayBillLinked { get; set; }
    
    public DateTime? CancelledDate { get; set; }
    public long? CancelledBy { get; set; }
    public string? CancelReason { get; set; }
    
    public bool IsBulkGenerated { get; set; }
    public string? BulkBatchId { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual ICollection<EInvoiceDetail>? Details { get; set; }
}

public class EInvoiceDetail
{
    public long EInvoiceDetailId { get; set; }
    public long EInvoiceId { get; set; }
    public int ItemSlNo { get; set; }
    public string ItemDescription { get; set; } = string.Empty;
    public string HSNCode { get; set; } = string.Empty;
    public string? ItemCode { get; set; }
    public bool IsService { get; set; }
    
    public decimal Quantity { get; set; }
    public string UQC { get; set; } = string.Empty;
    
    public decimal UnitPrice { get; set; }
    public decimal TotalAmount { get; set; }
    public decimal PreTaxValue { get; set; }
    public decimal Discount { get; set; }
    public decimal TaxableValue { get; set; }
    
    public decimal GSTRate { get; set; }
    public decimal IGSTAmount { get; set; }
    public decimal CGSTAmount { get; set; }
    public decimal SGSTAmount { get; set; }
    public decimal CessRate { get; set; }
    public decimal CessAmount { get; set; }
    public decimal CessNonAdvolAmount { get; set; }
    
    public string? BatchNumber { get; set; }
    public string? SerialNumber { get; set; }
    
    public string? OriginCountryCode { get; set; }
    public string? ItemRemarks { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual EInvoice? EInvoice { get; set; }
}

public class DocumentSequence
{
    [System.ComponentModel.DataAnnotations.Key]
    public long SequenceId { get; set; }
    public long CompanyId { get; set; }
    public string DocumentType { get; set; } = string.Empty;
    public string FinancialYear { get; set; } = string.Empty;
    public string Prefix { get; set; } = string.Empty;
    public string Suffix { get; set; } = string.Empty;
    public long CurrentNumber { get; set; }
    public int MinDigits { get; set; } = 6;
    public long? MaxNumber { get; set; }
    public bool ResetYearly { get; set; } = true;
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
}
