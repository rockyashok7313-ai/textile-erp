using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Repositories.Maintenance;

public interface IMaintenanceRepository : IRepository<MaintenanceRequest>
{
    Task<MaintenanceRequest?> GetByNumberAsync(string requestNumber, long companyId);
    Task<IEnumerable<MaintenanceRequest>> GetByMachineAsync(long machineId);
    Task<IEnumerable<MaintenanceRequest>> GetByStatusAsync(string status, long companyId);
    Task<WorkOrder?> GetWorkOrderByIdAsync(long workOrderId);
    Task<WorkOrder?> GetWorkOrderByNumberAsync(string workOrderNumber, long companyId);
    Task<IEnumerable<WorkOrder>> GetWorkOrdersByMachineAsync(long machineId);
    Task<IEnumerable<WorkOrder>> GetActiveWorkOrdersAsync(long companyId);
    Task<bool> IsRequestNumberExistsAsync(string requestNumber, long companyId);
    Task<bool> IsWorkOrderNumberExistsAsync(string workOrderNumber, long companyId);
}
