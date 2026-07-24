using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Repositories.Maintenance;

public interface IDowntimeRepository : IRepository<DowntimeLog>
{
    Task<IEnumerable<DowntimeLog>> GetByMachineAsync(long machineId, DateTime fromDate, DateTime toDate);
    Task<IEnumerable<DowntimeLog>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate);
    Task<decimal> GetTotalDowntimeHoursAsync(long machineId, int month, int year);
    Task<DowntimeLog?> GetActiveDowntimeAsync(long machineId);
}
