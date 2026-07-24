namespace TextileERP.API.Models.Master;

public class Transporter : BaseModel
{
    public string TransporterCode { get; set; } = string.Empty;
    public string TransporterName { get; set; } = string.Empty;
    public string? GSTIN { get; set; }
    public string? PAN { get; set; }
    public string? ContactPerson { get; set; }
    public string? Phone { get; set; }
    public string? Mobile { get; set; }
    public string? Email { get; set; }
    public string? Address { get; set; }
    public string? City { get; set; }
    public long? StateId { get; set; }
    public string? StateCode { get; set; }
    public string? PinCode { get; set; }
    public string TransporterType { get; set; } = "Road"; // Road, Rail, Air, Ship
    public bool IsGSTRegistered { get; set; } = true;
    public bool IsEWayBillRegistered { get; set; } = true;
    
    // Navigation properties
    public virtual StateMaster? State { get; set; }
    public virtual Company? Company { get; set; }
}

public class Vehicle : BaseModel
{
    public string VehicleNumber { get; set; } = string.Empty;
    public string VehicleType { get; set; } = string.Empty;
    public string? VehicleDescription { get; set; }
    public decimal? Capacity { get; set; }
    public string CapacityUnit { get; set; } = "Tonnes";
    public long? TransporterId { get; set; }
    public string? DriverName { get; set; }
    public string? DriverLicenseNo { get; set; }
    public string? DriverMobile { get; set; }
    
    // Navigation properties
    public virtual Transporter? Transporter { get; set; }
    public virtual Company? Company { get; set; }
}
