using TextileERP.API.Models.Maintenance;
using TextileERP.API.Repositories.Maintenance;

namespace TextileERP.API.Services.Maintenance;

public class MachineService : IMachineService
{
    private readonly IMachineRepository _repository;

    public MachineService(IMachineRepository repository)
    {
        _repository = repository;
    }

    public async Task<Machine?> GetByIdAsync(long id) => await _repository.GetByIdAsync(id);

    public async Task<IEnumerable<Machine>> GetAllAsync(long companyId)
    {
        return await _repository.GetActiveMachinesAsync(companyId);
    }

    public async Task<IEnumerable<Machine>> GetByTypeAsync(string machineType, long companyId)
    {
        return await _repository.GetByTypeAsync(machineType, companyId);
    }

    public async Task<IEnumerable<Machine>> GetByStatusAsync(string status, long companyId)
    {
        return await _repository.GetByStatusAsync(status, companyId);
    }

    public async Task<Machine> CreateAsync(Machine machine) => await _repository.AddAsync(machine);

    public async Task UpdateAsync(Machine machine) => await _repository.UpdateAsync(machine);

    public async Task DeleteAsync(long id) => await _repository.DeleteAsync(id);

    public async Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null)
    {
        return await _repository.IsCodeExistsAsync(code, companyId, excludeId);
    }

    public async Task UpdateStatusAsync(long machineId, string status)
    {
        var machine = await _repository.GetByIdAsync(machineId);
        if (machine == null) throw new KeyNotFoundException("Machine not found");
        machine.Status = status;
        await _repository.UpdateAsync(machine);
    }
}
