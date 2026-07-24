using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Services.Maintenance;

public interface IDowntimeService
{
    Task<DowntimeLog?> GetByIdAsync(long id);
    Task<IEnumerable<DowntimeLog>> GetByMachineAsync(long machineId, DateTime fromDate, DateTime toDate);
    Task<IEnumerable<DowntimeLog>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate);
    Task<DowntimeLog> StartDowntimeAsync(DowntimeLog log);
    Task<DowntimeLog> EndDowntimeAsync(long downtimeId);
    Task<decimal> GetTotalDowntimeHoursAsync(long machineId, int month, int year);
    Task<DowntimeLog?> GetActiveDowntimeAsync(long machineId);
}
