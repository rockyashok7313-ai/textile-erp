namespace TextileERP.API.DTOs.Master;

public class CompanyDto
{
    public long Id { get; set; }
    public string CompanyName { get; set; } = string.Empty;
    public string? CompanyCode { get; set; }
    public string? LegalName { get; set; }
    public string? GSTIN { get; set; }
    public string? PAN { get; set; }
    public string? CIN { get; set; }
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? Website { get; set; }
    public string? Address1 { get; set; }
    public string? Address2 { get; set; }
    public long? CityId { get; set; }
    public string? CityName { get; set; }
    public long? StateId { get; set; }
    public string? StateName { get; set; }
    public string? PinCode { get; set; }
    public long? CountryId { get; set; }
    public string? CountryName { get; set; }
    public string? LogoPath { get; set; }
    public string? FinancialYearStart { get; set; }
    public string? FinancialYearEnd { get; set; }
    public bool IsActive { get; set; }
}

public class CreateCompanyRequest
{
    public string CompanyName { get; set; } = string.Empty;
    public string? CompanyCode { get; set; }
    public string? LegalName { get; set; }
    public string? GSTIN { get; set; }
    public string? PAN { get; set; }
    public string? CIN { get; set; }
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? Website { get; set; }
    public string? Address1 { get; set; }
    public string? Address2 { get; set; }
    public long? CityId { get; set; }
    public long? StateId { get; set; }
    public string? PinCode { get; set; }
    public long? CountryId { get; set; }
    public string? FinancialYearStart { get; set; }
    public string? FinancialYearEnd { get; set; }
}
