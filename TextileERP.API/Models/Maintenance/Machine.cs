using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Maintenance;

public class Machine : BaseModel
{
    public string MachineCode { get; set; } = string.Empty;
    public string MachineName { get; set; } = string.Empty;
    public string MachineType { get; set; } = string.Empty; // AirJet, Sulzer
    public string? Make { get; set; }       // Toyota, Picanol, Sulzer
    public string? Model { get; set; }
    public string? SerialNumber { get; set; }
    public string? Capacity { get; set; }
    public int LoomCount { get; set; } = 1;
    public string? Location { get; set; }
    public string? FloorId { get; set; }
    public string? BayNumber { get; set; }
    public DateTime? InstallationDate { get; set; }
    public DateTime? WarrantyExpiryDate { get; set; }
    public DateTime? LastServiceDate { get; set; }
    public DateTime? NextServiceDate { get; set; }
    public decimal OperatingHours { get; set; }
    public string Status { get; set; } = "Running"; // Running, Down, Maintenance, Idle, Scrap
    public decimal? HealthScore { get; set; }
    public decimal? EstimatedValue { get; set; }
    public decimal? SalvageValue { get; set; }
    public int? UsefulLifeYears { get; set; }
    public string? DepreciationMethod { get; set; }
    public string? PhotoPath { get; set; }
    public string? Remarks { get; set; }

    public virtual Company? Company { get; set; }
}
