using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Services.Maintenance;

public interface IMachineService
{
    Task<Machine?> GetByIdAsync(long id);
    Task<IEnumerable<Machine>> GetAllAsync(long companyId);
    Task<IEnumerable<Machine>> GetByTypeAsync(string machineType, long companyId);
    Task<IEnumerable<Machine>> GetByStatusAsync(string status, long companyId);
    Task<Machine> CreateAsync(Machine machine);
    Task UpdateAsync(Machine machine);
    Task DeleteAsync(long id);
    Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null);
    Task UpdateStatusAsync(long machineId, string status);
}
