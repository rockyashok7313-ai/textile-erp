namespace TextileERP.API.Models.Master;

public class Party : BaseModel
{
    public string PartyCode { get; set; } = string.Empty;
    public string PartyName { get; set; } = string.Empty;
    public string? TradeName { get; set; }
    public string? LegalName { get; set; }
    public string PartyType { get; set; } = string.Empty; // Customer, Supplier, Both
    
    public string? GSTIN { get; set; }
    public string? PAN { get; set; }
    public string? TAN { get; set; }
    public string RegistrationType { get; set; } = "Regular";
    public bool IsReverseCharge { get; set; }
    
    public bool IsTDSApplicable { get; set; }
    public string? TDSSection { get; set; }
    public decimal? TDSRate { get; set; }
    public decimal? TDSLimit { get; set; }
    public bool IsTCSApplicable { get; set; }
    public string? TCSSection { get; set; }
    public decimal? TCSRate { get; set; }
    public decimal? TCSLimit { get; set; }
    
    public string? ContactPerson { get; set; }
    public string? ContactPersonDesignation { get; set; }
    public string? Phone { get; set; }
    public string? Mobile { get; set; }
    public string? AlternateMobile { get; set; }
    public string? Email { get; set; }
    public string? Website { get; set; }
    
    public string? AddressLine1 { get; set; }
    public string? AddressLine2 { get; set; }
    public string? AddressLine3 { get; set; }
    public string? City { get; set; }
    public string? District { get; set; }
    public long? StateId { get; set; }
    public string? StateCode { get; set; }
    public string? PinCode { get; set; }
    public int CountryId { get; set; } = 1;
    
    public string? ShipAddressLine1 { get; set; }
    public string? ShipAddressLine2 { get; set; }
    public string? ShipAddressLine3 { get; set; }
    public string? ShipCity { get; set; }
    public string? ShipDistrict { get; set; }
    public long? ShipStateId { get; set; }
    public string? ShipStateCode { get; set; }
    public string? ShipPinCode { get; set; }
    
    public decimal? Latitude { get; set; }
    public decimal? Longitude { get; set; }
    public string? GISCode { get; set; }
    
    public decimal OpeningBalance { get; set; }
    public string? OpeningBalanceType { get; set; } = "Dr";
    public decimal CreditLimit { get; set; }
    public int PaymentTermsDays { get; set; }
    public decimal DiscountPercent { get; set; }
    public string? PriceGroup { get; set; }
    
    public string? BankName { get; set; }
    public string? BankBranch { get; set; }
    public string? BankAccountNumber { get; set; }
    public string? BankIFSC { get; set; }
    
    public bool IsBlacklisted { get; set; }
    public string? BlacklistReason { get; set; }
    
    // Navigation properties
    public virtual StateMaster? State { get; set; }
    public virtual Company? Company { get; set; }
    public virtual ICollection<PartyAddress>? Addresses { get; set; }
}

public class PartyAddress : BaseModel
{
    public long PartyId { get; set; }
    public string AddressType { get; set; } = string.Empty; // Billing, Shipping
    public string? AddressName { get; set; }
    public string? ContactPerson { get; set; }
    public string? Phone { get; set; }
    public string? Mobile { get; set; }
    public string? Email { get; set; }
    public string AddressLine1 { get; set; } = string.Empty;
    public string? AddressLine2 { get; set; }
    public string? AddressLine3 { get; set; }
    public string City { get; set; } = string.Empty;
    public string? District { get; set; }
    public long StateId { get; set; }
    public string StateCode { get; set; } = string.Empty;
    public string PinCode { get; set; } = string.Empty;
    public int CountryId { get; set; } = 1;
    public string? GSTIN { get; set; }
    public decimal? Latitude { get; set; }
    public decimal? Longitude { get; set; }
    public bool IsDefault { get; set; }
    
    // Navigation properties
    public virtual Party? Party { get; set; }
    public virtual StateMaster? State { get; set; }
}
