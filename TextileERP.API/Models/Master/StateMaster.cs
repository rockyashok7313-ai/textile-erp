namespace TextileERP.API.Models.Master;

public class StateMaster
{
    [System.ComponentModel.DataAnnotations.Key]
    public long StateId { get; set; }
    public string StateCode { get; set; } = string.Empty;
    public string StateName { get; set; } = string.Empty;
    public string? StateShortName { get; set; }
    public string StateType { get; set; } = string.Empty; // State, Union Territory
    public int CountryId { get; set; } = 1;
    public bool IsUTWithLegislature { get; set; }
    public bool IsGSTApplicable { get; set; } = true;
    public string? TANStateCode { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedDate { get; set; } = DateTime.Now;
}

public class Country
{
    [System.ComponentModel.DataAnnotations.Key]
    public int CountryId { get; set; }
    public string CountryCode { get; set; } = string.Empty;
    public string CountryName { get; set; } = string.Empty;
    public string? CountryShortName { get; set; }
    public string? ISDCode { get; set; }
    public string? CurrencyCode { get; set; }
    public string? CurrencyName { get; set; }
    public bool IsActive { get; set; } = true;
}
