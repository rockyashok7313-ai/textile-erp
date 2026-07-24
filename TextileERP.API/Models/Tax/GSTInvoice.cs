namespace TextileERP.API.Models.Tax;

public class GSTInvoice
{
    public long GSTInvoiceId { get; set; }
    public long CompanyId { get; set; }
    public string InvoiceType { get; set; } = string.Empty;
    public long InvoiceId { get; set; }
    public string InvoiceNumber { get; set; } = string.Empty;
    public DateTime InvoiceDate { get; set; }
    
    public long PartyId { get; set; }
    public string? PartyGSTIN { get; set; }
    public string? PartyStateCode { get; set; }
    public string PartyType { get; set; } = string.Empty;
    
    public bool IsInterState { get; set; }
    public string? PlaceOfSupply { get; set; }
    public string? PlaceOfSupplyStateCode { get; set; }
    public bool ReverseCharge { get; set; }
    
    public decimal TaxableAmount { get; set; }
    public decimal CGSTRate { get; set; }
    public decimal CGSTAmount { get; set; }
    public decimal SGSTRate { get; set; }
    public decimal SGSTAmount { get; set; }
    public decimal IGSTRate { get; set; }
    public decimal IGSTAmount { get; set; }
    public decimal CessRate { get; set; }
    public decimal CessAmount { get; set; }
    public decimal InvoiceValue { get; set; }
    
    public string GSTR1Status { get; set; } = "Pending";
    public DateTime? GSTR1FilingDate { get; set; }
    public string GSTR3BStatus { get; set; } = "Pending";
    public DateTime? GSTR3BFilingDate { get; set; }
    
    public string? ITCStatus { get; set; } = "Eligible";
    public decimal ITCReversalAmount { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Party? Party { get; set; }
    public virtual ICollection<GSTInvoiceDetail>? Details { get; set; }
}

public class GSTInvoiceDetail
{
    public long GSTInvoiceDetailId { get; set; }
    public long GSTInvoiceId { get; set; }
    public string HSNCode { get; set; } = string.Empty;
    public string? HSNDesc { get; set; }
    public string? UQC { get; set; }
    public decimal Quantity { get; set; }
    public decimal TaxableValue { get; set; }
    public decimal CGSTRate { get; set; }
    public decimal CGSTAmount { get; set; }
    public decimal SGSTRate { get; set; }
    public decimal SGSTAmount { get; set; }
    public decimal IGSTRate { get; set; }
    public decimal IGSTAmount { get; set; }
    public decimal CessRate { get; set; }
    public decimal CessAmount { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual GSTInvoice? GSTInvoice { get; set; }
}

public class TDSEntry
{
    public long TDSEntryId { get; set; }
    public long CompanyId { get; set; }
    public DateTime TDSDate { get; set; }
    
    public long PartyId { get; set; }
    public string? PartyName { get; set; }
    public string? PartyGSTIN { get; set; }
    public string? PartyPAN { get; set; }
    public bool IsPANValidated { get; set; }
    
    public string TDSSection { get; set; } = string.Empty;
    public string? TDSSectionDescription { get; set; }
    public decimal TDSRate { get; set; }
    public bool IsIndividual { get; set; }
    
    public string ReferenceType { get; set; } = string.Empty;
    public long ReferenceId { get; set; }
    public string ReferenceNumber { get; set; } = string.Empty;
    public DateTime ReferenceDate { get; set; }
    
    public decimal GrossAmount { get; set; }
    public decimal TDSDeducted { get; set; }
    
    public decimal? ThresholdLimit { get; set; }
    public bool IsAboveThreshold { get; set; } = true;
    
    public string FinancialYear { get; set; } = string.Empty;
    public string Quarter { get; set; } = string.Empty;
    
    public bool IsDeducted { get; set; } = true;
    public DateTime? DeductedDate { get; set; }
    public bool IsDeposited { get; set; }
    public DateTime? DepositDate { get; set; }
    public string? ChallanNumber { get; set; }
    
    public bool IsIncludedInReturn { get; set; }
    public DateTime? ReturnFilingDate { get; set; }
    
    public bool IsCertificateGenerated { get; set; }
    public string? CertificateNumber { get; set; }
    public DateTime? CertificateDate { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Party? Party { get; set; }
}

public class TCSEntry
{
    public long TCSEntryId { get; set; }
    public long CompanyId { get; set; }
    public DateTime TCSDate { get; set; }
    
    public long PartyId { get; set; }
    public string? PartyName { get; set; }
    public string? PartyGSTIN { get; set; }
    public string? PartyPAN { get; set; }
    
    public string TCSSection { get; set; } = string.Empty;
    public string? TCSSectionDescription { get; set; }
    public decimal TCSRate { get; set; }
    
    public string ReferenceType { get; set; } = string.Empty;
    public long ReferenceId { get; set; }
    public string ReferenceNumber { get; set; } = string.Empty;
    public DateTime ReferenceDate { get; set; }
    
    public decimal GrossAmount { get; set; }
    public decimal TCSAmount { get; set; }
    
    public decimal? ThresholdLimit { get; set; }
    public bool IsAboveThreshold { get; set; } = true;
    
    public string FinancialYear { get; set; } = string.Empty;
    public string Quarter { get; set; } = string.Empty;
    
    public bool IsCollected { get; set; } = true;
    public DateTime? CollectionDate { get; set; }
    public bool IsDeposited { get; set; }
    public DateTime? DepositDate { get; set; }
    public string? ChallanNumber { get; set; }
    
    public bool IsIncludedInReturn { get; set; }
    public DateTime? ReturnFilingDate { get; set; }
    
    public bool IsCertificateGenerated { get; set; }
    public string? CertificateNumber { get; set; }
    public DateTime? CertificateDate { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Party? Party { get; set; }
}
