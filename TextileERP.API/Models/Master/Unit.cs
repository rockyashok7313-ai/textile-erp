namespace TextileERP.API.Models.Master;

public class Unit : BaseModel
{
    public string UnitCode { get; set; } = string.Empty;
    public string UnitName { get; set; } = string.Empty;
    public string? UnitFullName { get; set; }
    public string UnitType { get; set; } = string.Empty; // Quantity, Weight, Length, Area, Volume
    public decimal ConversionFactor { get; set; } = 1;
    public long? BaseUnitId { get; set; }
    public int DecimalPlaces { get; set; } = 2;
    
    // Navigation properties
    public virtual Unit? BaseUnit { get; set; }
    public virtual Company? Company { get; set; }
}

public class UnitConversion : BaseModel
{
    public long FromUnitId { get; set; }
    public long ToUnitId { get; set; }
    public decimal ConversionFactor { get; set; }
    
    // Navigation properties
    public virtual Unit? FromUnit { get; set; }
    public virtual Unit? ToUnit { get; set; }
}
