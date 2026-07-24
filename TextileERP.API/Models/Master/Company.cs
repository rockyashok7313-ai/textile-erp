namespace TextileERP.API.Models.Master;

public class Company : BaseModel
{
    public string CompanyCode { get; set; } = string.Empty;
    public string CompanyName { get; set; } = string.Empty;
    public string? TradeName { get; set; }
    public string? LegalName { get; set; }
    public string? GSTIN { get; set; }
    public string? PAN { get; set; }
    public string? TAN { get; set; }
    public string? CIN { get; set; }
    public string? IEC { get; set; }
    public string RegistrationType { get; set; } = "Regular";
    
    public string? AddressLine1 { get; set; }
    public string? AddressLine2 { get; set; }
    public string? AddressLine3 { get; set; }
    public string? City { get; set; }
    public long StateId { get; set; }
    public string StateCode { get; set; } = string.Empty;
    public string? PinCode { get; set; }
    public int CountryId { get; set; } = 1;
    
    public string? Phone { get; set; }
    public string? Mobile { get; set; }
    public string? Email { get; set; }
    public string? Website { get; set; }
    public byte[]? Logo { get; set; }
    public string? LogoPath { get; set; }
    
    public string? BankName { get; set; }
    public string? BankBranch { get; set; }
    public string? BankAccountNumber { get; set; }
    public string? BankIFSC { get; set; }
    public string? BankMICR { get; set; }
    
    public bool EWayBillApplicable { get; set; } = true;
    public bool EInvoiceApplicable { get; set; } = true;
    public bool TDSApplicable { get; set; }
    public bool TCSApplicable { get; set; }
    
    public int FiscalYearStartMonth { get; set; } = 4;
    public string DateFormat { get; set; } = "DD/MM/YYYY";
    public string CurrencyCode { get; set; } = "INR";
    public string Timezone { get; set; } = "Asia/Kolkata";
    
    public bool IsDefault { get; set; }
    
    // Navigation properties
    public virtual StateMaster? State { get; set; }
}
