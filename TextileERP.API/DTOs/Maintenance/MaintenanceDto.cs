namespace TextileERP.API.DTOs.Maintenance;

public class MachineDto
{
    public long Id { get; set; }
    public string MachineCode { get; set; } = string.Empty;
    public string MachineName { get; set; } = string.Empty;
    public string MachineType { get; set; } = string.Empty;
    public string? Make { get; set; }
    public string? Model { get; set; }
    public string? SerialNumber { get; set; }
    public string? Capacity { get; set; }
    public int LoomCount { get; set; }
    public string? Location { get; set; }
    public string? BayNumber { get; set; }
    public DateTime? InstallationDate { get; set; }
    public DateTime? LastServiceDate { get; set; }
    public DateTime? NextServiceDate { get; set; }
    public decimal OperatingHours { get; set; }
    public string Status { get; set; } = string.Empty;
    public decimal? HealthScore { get; set; }
    public bool IsActive { get; set; }
}

public class CreateMachineRequest
{
    public long CompanyId { get; set; }
    public string MachineCode { get; set; } = string.Empty;
    public string MachineName { get; set; } = string.Empty;
    public string MachineType { get; set; } = string.Empty;
    public string? Make { get; set; }
    public string? Model { get; set; }
    public string? SerialNumber { get; set; }
    public string? Capacity { get; set; }
    public int LoomCount { get; set; } = 1;
    public string? Location { get; set; }
    public string? BayNumber { get; set; }
    public DateTime? InstallationDate { get; set; }
    public decimal? EstimatedValue { get; set; }
}

public class SparePartDto
{
    public long Id { get; set; }
    public string SparePartCode { get; set; } = string.Empty;
    public string SparePartName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? Category { get; set; }
    public long? UnitId { get; set; }
    public decimal MinStock { get; set; }
    public decimal MaxStock { get; set; }
    public decimal ReorderLevel { get; set; }
    public decimal CurrentStock { get; set; }
    public decimal UnitCost { get; set; }
    public int LeadTimeDays { get; set; }
    public string? CompatibleMachineTypes { get; set; }
    public string? Manufacturer { get; set; }
    public string? PartNumber { get; set; }
    public bool IsCriticalSpare { get; set; }
    public bool IsActive { get; set; }
}

public class CreateSparePartRequest
{
    public long CompanyId { get; set; }
    public string SparePartCode { get; set; } = string.Empty;
    public string SparePartName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? Category { get; set; }
    public long? UnitId { get; set; }
    public decimal MinStock { get; set; }
    public decimal MaxStock { get; set; }
    public decimal ReorderLevel { get; set; }
    public decimal UnitCost { get; set; }
    public int LeadTimeDays { get; set; } = 7;
    public string? CompatibleMachineTypes { get; set; }
    public string? Manufacturer { get; set; }
    public string? PartNumber { get; set; }
    public bool IsCriticalSpare { get; set; }
}

public class MaintenanceRequestDto
{
    public long Id { get; set; }
    public string RequestNumber { get; set; } = string.Empty;
    public long MachineId { get; set; }
    public string? MachineName { get; set; }
    public DateTime RequestDate { get; set; }
    public string FaultDescription { get; set; } = string.Empty;
    public string? FaultCategory { get; set; }
    public string Priority { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string? AssignedTechnician { get; set; }
    public DateTime? ExpectedCompletionDate { get; set; }
    public decimal? EstimatedCost { get; set; }
    public decimal? ActualCost { get; set; }
    public bool IsEmergency { get; set; }
    public string? Remarks { get; set; }
}

public class CreateMaintenanceRequestRequest
{
    public long CompanyId { get; set; }
    public long MachineId { get; set; }
    public string FaultDescription { get; set; } = string.Empty;
    public string? FaultCategory { get; set; }
    public string Priority { get; set; } = "Medium";
    public bool IsEmergency { get; set; }
    public decimal? EstimatedCost { get; set; }
    public string? Remarks { get; set; }
}

public class WorkOrderDto
{
    public long Id { get; set; }
    public string WorkOrderNumber { get; set; } = string.Empty;
    public long? RequestId { get; set; }
    public long MachineId { get; set; }
    public string? MachineName { get; set; }
    public string WorkOrderType { get; set; } = string.Empty;
    public DateTime StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public string? TechnicianName { get; set; }
    public string? WorkDescription { get; set; }
    public string? RootCause { get; set; }
    public string? ActionTaken { get; set; }
    public decimal TotalPartsCost { get; set; }
    public decimal TotalLaborCost { get; set; }
    public decimal TotalCost { get; set; }
    public string Status { get; set; } = string.Empty;
    public decimal DowntimeHours { get; set; }
    public List<WorkOrderSparePartDto>? SpareParts { get; set; }
}

public class CreateWorkOrderRequest
{
    public long CompanyId { get; set; }
    public long? RequestId { get; set; }
    public long MachineId { get; set; }
    public string? TechnicianName { get; set; }
    public string? WorkDescription { get; set; }
}

public class CompleteWorkOrderRequest
{
    public string? RootCause { get; set; }
    public string? ActionTaken { get; set; }
    public string? Findings { get; set; }
    public string? Recommendations { get; set; }
    public decimal TotalPartsCost { get; set; }
    public decimal TotalLaborCost { get; set; }
    public decimal DowntimeHours { get; set; }
}

public class WorkOrderSparePartDto
{
    public long Id { get; set; }
    public long SparePartId { get; set; }
    public string? SparePartName { get; set; }
    public decimal QuantityUsed { get; set; }
    public decimal UnitCost { get; set; }
    public decimal TotalCost { get; set; }
}

public class DowntimeDto
{
    public long Id { get; set; }
    public long MachineId { get; set; }
    public string? MachineName { get; set; }
    public DateTime StartDateTime { get; set; }
    public DateTime? EndDateTime { get; set; }
    public decimal DurationMinutes { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public bool IsPlanned { get; set; }
    public long? WorkOrderId { get; set; }
    public decimal? EstimatedCostImpact { get; set; }
}

public class StartDowntimeRequest
{
    public long MachineId { get; set; }
    public long CompanyId { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string Category { get; set; } = "Breakdown";
    public bool IsPlanned { get; set; }
    public long? WorkOrderId { get; set; }
    public decimal? EstimatedCostImpact { get; set; }
    public string? Remarks { get; set; }
}
