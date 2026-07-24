using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Repositories.Maintenance;

public interface IMachineRepository : IRepository<Machine>
{
    Task<Machine?> GetByCodeAsync(string code, long companyId);
    Task<IEnumerable<Machine>> GetByTypeAsync(string machineType, long companyId);
    Task<IEnumerable<Machine>> GetByStatusAsync(string status, long companyId);
    Task<IEnumerable<Machine>> GetActiveMachinesAsync(long companyId);
    Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null);
}
