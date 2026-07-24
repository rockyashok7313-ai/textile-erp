using Microsoft.EntityFrameworkCore;
using TextileERP.API.Data;
using TextileERP.API.Models.Maintenance;
using TextileERP.API.Repositories.Maintenance;

namespace TextileERP.API.Services.Maintenance;

public class MaintenanceService : IMaintenanceService
{
    private readonly IMaintenanceRepository _maintenanceRepository;
    private readonly ISparePartService _sparePartService;
    private readonly IMachineService _machineService;
    private readonly ApplicationDbContext _context;

    public MaintenanceService(
        IMaintenanceRepository maintenanceRepository,
        ISparePartService sparePartService,
        IMachineService machineService,
        ApplicationDbContext context)
    {
        _maintenanceRepository = maintenanceRepository;
        _sparePartService = sparePartService;
        _machineService = machineService;
        _context = context;
    }

    // Maintenance Requests
    public async Task<MaintenanceRequest?> GetRequestByIdAsync(long id) => await _maintenanceRepository.GetByIdAsync(id);
    public async Task<MaintenanceRequest?> GetRequestByNumberAsync(string requestNumber, long companyId) =>
        await _maintenanceRepository.GetByNumberAsync(requestNumber, companyId);
    public async Task<IEnumerable<MaintenanceRequest>> GetRequestsByMachineAsync(long machineId) =>
        await _maintenanceRepository.GetByMachineAsync(machineId);
    public async Task<IEnumerable<MaintenanceRequest>> GetRequestsByStatusAsync(string status, long companyId) =>
        await _maintenanceRepository.GetByStatusAsync(status, companyId);

    public async Task<MaintenanceRequest> CreateRequestAsync(MaintenanceRequest request)
    {
        request.RequestDate = DateTime.Now;
        request.Status = "Open";
        return await _maintenanceRepository.AddAsync(request);
    }

    public async Task UpdateRequestAsync(MaintenanceRequest request)
    {
        await _maintenanceRepository.UpdateAsync(request);
    }

    public async Task AssignRequestAsync(long requestId, long technicianId, string technicianName)
    {
        var request = await _maintenanceRepository.GetByIdAsync(requestId);
        if (request == null) throw new KeyNotFoundException("Maintenance request not found");

        request.AssignedToId = technicianId;
        request.AssignedTechnician = technicianName;
        request.AssignedDate = DateTime.Now;
        request.Status = "Assigned";
        await _maintenanceRepository.UpdateAsync(request);
    }

    public async Task CompleteRequestAsync(long requestId, string completionRemarks)
    {
        var request = await _maintenanceRepository.GetByIdAsync(requestId);
        if (request == null) throw new KeyNotFoundException("Maintenance request not found");

        request.Status = "Completed";
        request.CompletionRemarks = completionRemarks;
        request.ActualCompletionDate = DateTime.Now;
        await _maintenanceRepository.UpdateAsync(request);
    }

    // Work Orders
    public async Task<WorkOrder?> GetWorkOrderByIdAsync(long id) => await _maintenanceRepository.GetWorkOrderByIdAsync(id);
    public async Task<WorkOrder?> GetWorkOrderByNumberAsync(string workOrderNumber, long companyId) =>
        await _maintenanceRepository.GetWorkOrderByNumberAsync(workOrderNumber, companyId);
    public async Task<IEnumerable<WorkOrder>> GetActiveWorkOrdersAsync(long companyId) =>
        await _maintenanceRepository.GetActiveWorkOrdersAsync(companyId);

    public async Task<WorkOrder> CreateWorkOrderAsync(WorkOrder workOrder)
    {
        workOrder.StartDate = DateTime.Now;
        workOrder.Status = "Open";
        workOrder.WorkOrderType = "Reactive";

        _context.WorkOrders.Add(workOrder);
        await _context.SaveChangesAsync();

        // Update machine status
        await _machineService.UpdateStatusAsync(workOrder.MachineId, "Maintenance");

        return workOrder;
    }

    public async Task UpdateWorkOrderAsync(WorkOrder workOrder)
    {
        _context.WorkOrders.Update(workOrder);
        await _context.SaveChangesAsync();
    }

    public async Task CompleteWorkOrderAsync(long workOrderId, decimal totalPartsCost, decimal totalLaborCost, decimal downtimeHours)
    {
        var workOrder = await _maintenanceRepository.GetWorkOrderByIdAsync(workOrderId);
        if (workOrder == null) throw new KeyNotFoundException("Work order not found");

        workOrder.Status = "Completed";
        workOrder.EndDate = DateTime.Now;
        workOrder.IsCompleted = true;
        workOrder.TotalPartsCost = totalPartsCost;
        workOrder.TotalLaborCost = totalLaborCost;
        workOrder.TotalCost = totalPartsCost + totalLaborCost;
        workOrder.DowntimeHours = downtimeHours;

        await _context.SaveChangesAsync();

        // Update machine status back to running
        await _machineService.UpdateStatusAsync(workOrder.MachineId, "Running");

        // Update machine last service date
        var machine = await _machineService.GetByIdAsync(workOrder.MachineId);
        if (machine != null)
        {
            machine.LastServiceDate = DateTime.Now;
            machine.OperatingHours += downtimeHours;
            await _machineService.UpdateAsync(machine);
        }

        // Update linked request if any
        if (workOrder.RequestId.HasValue)
        {
            await CompleteRequestAsync(workOrder.RequestId.Value, "Completed via work order");
        }
    }

    public async Task CancelWorkOrderAsync(long workOrderId, string reason)
    {
        var workOrder = await _maintenanceRepository.GetWorkOrderByIdAsync(workOrderId);
        if (workOrder == null) throw new KeyNotFoundException("Work order not found");

        workOrder.Status = "Cancelled";
        workOrder.Remarks = reason;

        _context.WorkOrders.Update(workOrder);
        await _context.SaveChangesAsync();

        await _machineService.UpdateStatusAsync(workOrder.MachineId, "Running");
    }
}
