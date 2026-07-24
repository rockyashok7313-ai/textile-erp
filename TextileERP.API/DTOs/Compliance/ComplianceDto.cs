namespace TextileERP.API.DTOs.Compliance;

public class EWayBillDto
{
    public long EWayBillId { get; set; }
    public long CompanyId { get; set; }
    public string EWayBillNumber { get; set; } = string.Empty;
    public DateTime EWayBillDate { get; set; }
    public string? DocumentType { get; set; }
    public string? DocumentNumber { get; set; }
    public DateTime? DocumentDate { get; set; }
    public long? SupplierId { get; set; }
    public string? SupplierGSTIN { get; set; }
    public string? SupplierName { get; set; }
    public string? SupplierAddress { get; set; }
    public long? SupplierStateId { get; set; }
    public string? SupplierStateCode { get; set; }
    public long? CustomerId { get; set; }
    public string? CustomerGSTIN { get; set; }
    public string? CustomerName { get; set; }
    public string? CustomerAddress { get; set; }
    public long? CustomerStateId { get; set; }
    public string? CustomerStateCode { get; set; }
    public string? DispatchFrom { get; set; }
    public string? ShipTo { get; set; }
    public long? TransporterId { get; set; }
    public string? TransporterGSTIN { get; set; }
    public string? TransporterName { get; set; }
    public long? VehicleId { get; set; }
    public string? VehicleNumber { get; set; }
    public decimal TotalTaxableValue { get; set; }
    public decimal TotalCGST { get; set; }
    public decimal TotalSGST { get; set; }
    public decimal TotalIGST { get; set; }
    public decimal TotalCess { get; set; }
    public decimal? OtherAmount { get; set; }
    public decimal TotalValue { get; set; }
    public decimal? InsuranceAmount { get; set; }
    public decimal? FreightAmount { get; set; }
    public decimal? InvoiceAdvanceAmount { get; set; }
    public decimal? OtherCharges { get; set; }
    public decimal? RoundOffAmount { get; set; }
    public string? Distance { get; set; }
    public string? EWayBillStatus { get; set; }
    public string? EWayBillURL { get; set; }
    public string? Remarks { get; set; }
    public DateTime? ValidUpto { get; set; }
    public string? TransportMode { get; set; } // Road, Rail, Air, Ship
}

public class CreateEWayBillRequest
{
    public long CompanyId { get; set; }
    public string? DocumentType { get; set; }
    public string? DocumentNumber { get; set; }
    public DateTime? DocumentDate { get; set; }
    public long? SupplierId { get; set; }
    public string? SupplierGSTIN { get; set; }
    public string? SupplierName { get; set; }
    public string? SupplierAddress { get; set; }
    public long? SupplierStateId { get; set; }
    public long? CustomerId { get; set; }
    public string? CustomerGSTIN { get; set; }
    public string? CustomerName { get; set; }
    public string? CustomerAddress { get; set; }
    public long? CustomerStateId { get; set; }
    public string? DispatchFrom { get; set; }
    public string? ShipTo { get; set; }
    public long? TransporterId { get; set; }
    public string? TransporterGSTIN { get; set; }
    public long? VehicleId { get; set; }
    public string? VehicleNumber { get; set; }
    public decimal? InsuranceAmount { get; set; }
    public decimal? FreightAmount { get; set; }
    public decimal? InvoiceAdvanceAmount { get; set; }
    public decimal? OtherCharges { get; set; }
    public string? Distance { get; set; }
    public string? TransportMode { get; set; }
    public string? Remarks { get; set; }
}

public class EInvoiceDto
{
    public long EInvoiceId { get; set; }
    public long CompanyId { get; set; }
    public string IRN { get; set; } = string.Empty;
    public string AcknowledgementNumber { get; set; } = string.Empty;
    public DateTime AcknowledgementDate { get; set; }
    public long SalesInvoiceId { get; set; }
    public string? InvoiceNumber { get; set; }
    public DateTime? InvoiceDate { get; set; }
    public string? EInvoiceStatus { get; set; }
    public string? EInvoiceType { get; set; }
    public string? SupplyType { get; set; }
    public long? CustomerId { get; set; }
    public string? CustomerGSTIN { get; set; }
    public string? CustomerName { get; set; }
    public string? CustomerStateCode { get; set; }
    public long? StateId { get; set; }
    public decimal TotalTaxableValue { get; set; }
    public decimal TotalCGST { get; set; }
    public decimal TotalSGST { get; set; }
    public decimal TotalIGST { get; set; }
    public decimal TotalCess { get; set; }
    public decimal? OtherCharges { get; set; }
    public decimal TotalInvoiceValue { get; set; }
    public string? QRCodeData { get; set; }
    public string? EInvoiceURL { get; set; }
    public string? Remarks { get; set; }
    public string? CancelReason { get; set; }
    public DateTime? CancelledDate { get; set; }
}

public class CreateEInvoiceRequest
{
    public long CompanyId { get; set; }
    public long SalesInvoiceId { get; set; }
    public string? SupplyType { get; set; }
    public string? Remarks { get; set; }
}

public class CancelEInvoiceRequest
{
    public string? CancelReason { get; set; }
    public string? CancelRemarks { get; set; }
}

public class DocumentSequenceDto
{
    public long DocumentSequenceId { get; set; }
    public long CompanyId { get; set; }
    public string DocumentType { get; set; } = string.Empty;
    public string Prefix { get; set; } = string.Empty;
    public int CurrentNumber { get; set; }
    public string Suffix { get; set; } = string.Empty;
    public string FinancialYear { get; set; } = string.Empty;
    public int MinimumDigits { get; set; }
    public bool IsActive { get; set; }
    public string? Description { get; set; }
}

public class GenerateDocumentNumberRequest
{
    public long CompanyId { get; set; }
    public string DocumentType { get; set; } = string.Empty;
    public string FinancialYear { get; set; } = string.Empty;
}
