namespace TextileERP.API.Models.Master;

public class Godown : BaseModel
{
    public string GodownCode { get; set; } = string.Empty;
    public string GodownName { get; set; } = string.Empty;
    public string GodownType { get; set; } = "Warehouse"; // Warehouse, Factory, Showroom, Yard
    public string? GodownAddress { get; set; }
    public string? AddressLine1 { get; set; }
    public string? AddressLine2 { get; set; }
    public string? City { get; set; }
    public long? StateId { get; set; }
    public string? StateCode { get; set; }
    public string? PinCode { get; set; }
    public string? Phone { get; set; }
    public string? ManagerName { get; set; }
    public string? ManagerContact { get; set; }
    public decimal? TotalArea { get; set; }
    public string? AreaUnit { get; set; } = "sqft";
    public decimal? Latitude { get; set; }
    public decimal? Longitude { get; set; }
    public bool IsDefault { get; set; }
    public bool IsMainGodown { get; set; }
    public bool IsProductionUnit { get; set; }
    
    // Navigation properties
    public virtual StateMaster? State { get; set; }
    public virtual Company? Company { get; set; }
    public virtual ICollection<GodownLocation>? Locations { get; set; }
}

public class GodownLocation : BaseModel
{
    public long GodownId { get; set; }
    public string LocationCode { get; set; } = string.Empty;
    public string LocationName { get; set; } = string.Empty;
    public string LocationType { get; set; } = string.Empty; // Rack, Bin, Position, Floor
    public string? RackNumber { get; set; }
    public string? ShelfNumber { get; set; }
    public string? BinNumber { get; set; }
    public decimal? MaxCapacity { get; set; }
    public decimal CurrentOccupancy { get; set; }
    
    // Navigation properties
    public virtual Godown? Godown { get; set; }
}
