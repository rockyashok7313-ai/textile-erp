namespace TextileERP.API.DTOs.Master;

public class PartyDto
{
    public long Id { get; set; }
    public string PartyCode { get; set; } = string.Empty;
    public string PartyName { get; set; } = string.Empty;
    public string? PartyType { get; set; } // Customer, Supplier, Both
    public string? ContactPerson { get; set; }
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? Mobile { get; set; }
    public string? GSTIN { get; set; }
    public string? PAN { get; set; }
    public string? TAN { get; set; }
    public long? StateId { get; set; }
    public string? StateName { get; set; }
    public string? StateCode { get; set; }
    public string? Address1 { get; set; }
    public string? Address2 { get; set; }
    public string? City { get; set; }
    public string? PinCode { get; set; }
    public string? ShippingAddress1 { get; set; }
    public string? ShippingAddress2 { get; set; }
    public string? ShippingCity { get; set; }
    public string? ShippingPinCode { get; set; }
    public long? ShippingStateId { get; set; }
    public string? ShippingStateName { get; set; }
    public long? LedgerGroupId { get; set; }
    public string? LedgerGroupName { get; set; }
    public long? DefaultLedgerId { get; set; }
    public string? DefaultLedgerName { get; set; }
    public decimal? CreditLimit { get; set; }
    public int? CreditDays { get; set; }
    public decimal? DiscountPercent { get; set; }
    public decimal? OutstandingBalance { get; set; }
    public string? PaymentTerms { get; set; }
    public string? TransporterId { get; set; }
    public bool IsActive { get; set; }
    public string? Remarks { get; set; }
    public string? GSTRegistrationType { get; set; } // Regular, Composition, Unregistered, SEZ
}

public class CreatePartyRequest
{
    public string PartyCode { get; set; } = string.Empty;
    public string PartyName { get; set; } = string.Empty;
    public string? PartyType { get; set; }
    public string? ContactPerson { get; set; }
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? Mobile { get; set; }
    public string? GSTIN { get; set; }
    public string? PAN { get; set; }
    public string? TAN { get; set; }
    public long? StateId { get; set; }
    public string? Address1 { get; set; }
    public string? Address2 { get; set; }
    public string? City { get; set; }
    public string? PinCode { get; set; }
    public string? ShippingAddress1 { get; set; }
    public string? ShippingAddress2 { get; set; }
    public string? ShippingCity { get; set; }
    public string? ShippingPinCode { get; set; }
    public long? ShippingStateId { get; set; }
    public long? LedgerGroupId { get; set; }
    public long? DefaultLedgerId { get; set; }
    public decimal? CreditLimit { get; set; }
    public int? CreditDays { get; set; }
    public decimal? DiscountPercent { get; set; }
    public string? PaymentTerms { get; set; }
    public string? TransporterId { get; set; }
    public string? GSTRegistrationType { get; set; }
    public string? Remarks { get; set; }
}

public class PartySearchRequest
{
    public string? SearchTerm { get; set; }
    public string? PartyType { get; set; }
    public long? StateId { get; set; }
    public bool? IsActive { get; set; }
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 25;
}
