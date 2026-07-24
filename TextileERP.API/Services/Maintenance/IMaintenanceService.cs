using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Services.Maintenance;

public interface IMaintenanceService
{
    Task<MaintenanceRequest?> GetRequestByIdAsync(long id);
    Task<MaintenanceRequest?> GetRequestByNumberAsync(string requestNumber, long companyId);
    Task<IEnumerable<MaintenanceRequest>> GetRequestsByMachineAsync(long machineId);
    Task<IEnumerable<MaintenanceRequest>> GetRequestsByStatusAsync(string status, long companyId);
    Task<MaintenanceRequest> CreateRequestAsync(MaintenanceRequest request);
    Task UpdateRequestAsync(MaintenanceRequest request);
    Task AssignRequestAsync(long requestId, long technicianId, string technicianName);
    Task CompleteRequestAsync(long requestId, string completionRemarks);

    Task<WorkOrder?> GetWorkOrderByIdAsync(long id);
    Task<WorkOrder?> GetWorkOrderByNumberAsync(string workOrderNumber, long companyId);
    Task<IEnumerable<WorkOrder>> GetActiveWorkOrdersAsync(long companyId);
    Task<WorkOrder> CreateWorkOrderAsync(WorkOrder workOrder);
    Task UpdateWorkOrderAsync(WorkOrder workOrder);
    Task CompleteWorkOrderAsync(long workOrderId, decimal totalPartsCost, decimal totalLaborCost, decimal downtimeHours);
    Task CancelWorkOrderAsync(long workOrderId, string reason);
}
