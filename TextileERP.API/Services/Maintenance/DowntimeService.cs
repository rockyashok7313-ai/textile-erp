using TextileERP.API.Models.Maintenance;
using TextileERP.API.Repositories.Maintenance;

namespace TextileERP.API.Services.Maintenance;

public class DowntimeService : IDowntimeService
{
    private readonly IDowntimeRepository _repository;
    private readonly IMachineService _machineService;

    public DowntimeService(IDowntimeRepository repository, IMachineService machineService)
    {
        _repository = repository;
        _machineService = machineService;
    }

    public async Task<DowntimeLog?> GetByIdAsync(long id) => await _repository.GetByIdAsync(id);

    public async Task<IEnumerable<DowntimeLog>> GetByMachineAsync(long machineId, DateTime fromDate, DateTime toDate)
    {
        return await _repository.GetByMachineAsync(machineId, fromDate, toDate);
    }

    public async Task<IEnumerable<DowntimeLog>> GetByDateRangeAsync(long companyId, DateTime fromDate, DateTime toDate)
    {
        return await _repository.GetByDateRangeAsync(companyId, fromDate, toDate);
    }

    public async Task<DowntimeLog> StartDowntimeAsync(DowntimeLog log)
    {
        log.StartDateTime = DateTime.Now;
        log.DurationMinutes = 0;
        var result = await _repository.AddAsync(log);

        await _machineService.UpdateStatusAsync(log.MachineId, "Down");
        return result;
    }

    public async Task<DowntimeLog> EndDowntimeAsync(long downtimeId)
    {
        var log = await _repository.GetByIdAsync(downtimeId);
        if (log == null) throw new KeyNotFoundException("Downtime log not found");
        if (log.EndDateTime.HasValue) throw new InvalidOperationException("Downtime already ended");

        log.EndDateTime = DateTime.Now;
        log.DurationMinutes = (decimal)(log.EndDateTime.Value - log.StartDateTime).TotalMinutes;
        await _repository.UpdateAsync(log);

        await _machineService.UpdateStatusAsync(log.MachineId, "Running");
        return log;
    }

    public async Task<decimal> GetTotalDowntimeHoursAsync(long machineId, int month, int year)
    {
        return await _repository.GetTotalDowntimeHoursAsync(machineId, month, year);
    }

    public async Task<DowntimeLog?> GetActiveDowntimeAsync(long machineId)
    {
        return await _repository.GetActiveDowntimeAsync(machineId);
    }
}
