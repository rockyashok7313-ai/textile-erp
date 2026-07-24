using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TextileERP.API.DTOs.Maintenance;
using TextileERP.API.Models.Maintenance;
using TextileERP.API.Services.Maintenance;

namespace TextileERP.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MaintenanceController : ControllerBase
{
    private readonly IMaintenanceService _maintenanceService;

    public MaintenanceController(IMaintenanceService maintenanceService)
    {
        _maintenanceService = maintenanceService;
    }

    // Maintenance Requests
    [HttpGet("requests")]
    public async Task<ActionResult<IEnumerable<MaintenanceRequestDto>>> GetRequests([FromQuery] long companyId)
    {
        var requests = await _maintenanceService.GetRequestsByStatusAsync("Open", companyId);
        return Ok(requests);
    }

    [HttpGet("requests/{id}")]
    public async Task<ActionResult<MaintenanceRequestDto>> GetRequestById(long id)
    {
        var request = await _maintenanceService.GetRequestByIdAsync(id);
        if (request == null) return NotFound();
        return Ok(request);
    }

    [HttpGet("requests/bymachine/{machineId}")]
    public async Task<ActionResult<IEnumerable<MaintenanceRequestDto>>> GetRequestsByMachine(long machineId)
    {
        var requests = await _maintenanceService.GetRequestsByMachineAsync(machineId);
        return Ok(requests);
    }

    [HttpPost("requests")]
    public async Task<ActionResult<MaintenanceRequestDto>> CreateRequest([FromBody] CreateMaintenanceRequestRequest request)
    {
        var maintenanceRequest = new MaintenanceRequest
        {
            CompanyId = request.CompanyId,
            MachineId = request.MachineId,
            FaultDescription = request.FaultDescription,
            FaultCategory = request.FaultCategory,
            Priority = request.Priority,
            IsEmergency = request.IsEmergency,
            EstimatedCost = request.EstimatedCost,
            Remarks = request.Remarks
        };

        var created = await _maintenanceService.CreateRequestAsync(maintenanceRequest);
        return CreatedAtAction(nameof(GetRequestById), new { id = created.Id }, created);
    }

    [HttpPost("requests/{id}/assign")]
    public async Task<IActionResult> AssignRequest(long id, [FromQuery] long technicianId, [FromQuery] string technicianName)
    {
        try
        {
            await _maintenanceService.AssignRequestAsync(id, technicianId, technicianName);
            return Ok(new { message = "Request assigned successfully" });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpPost("requests/{id}/complete")]
    public async Task<IActionResult> CompleteRequest(long id, [FromBody] string completionRemarks)
    {
        try
        {
            await _maintenanceService.CompleteRequestAsync(id, completionRemarks);
            return Ok(new { message = "Request completed successfully" });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    // Work Orders
    [HttpGet("workorders")]
    public async Task<ActionResult<IEnumerable<WorkOrderDto>>> GetActiveWorkOrders([FromQuery] long companyId)
    {
        var workOrders = await _maintenanceService.GetActiveWorkOrdersAsync(companyId);
        return Ok(workOrders);
    }

    [HttpGet("workorders/{id}")]
    public async Task<ActionResult<WorkOrderDto>> GetWorkOrderById(long id)
    {
        var workOrder = await _maintenanceService.GetWorkOrderByIdAsync(id);
        if (workOrder == null) return NotFound();
        return Ok(workOrder);
    }

    [HttpPost("workorders")]
    public async Task<ActionResult<WorkOrderDto>> CreateWorkOrder([FromBody] CreateWorkOrderRequest request)
    {
        var workOrder = new WorkOrder
        {
            CompanyId = request.CompanyId,
            RequestId = request.RequestId,
            MachineId = request.MachineId,
            TechnicianName = request.TechnicianName,
            WorkDescription = request.WorkDescription
        };

        var created = await _maintenanceService.CreateWorkOrderAsync(workOrder);
        return CreatedAtAction(nameof(GetWorkOrderById), new { id = created.Id }, created);
    }

    [HttpPost("workorders/{id}/complete")]
    public async Task<IActionResult> CompleteWorkOrder(long id, [FromBody] CompleteWorkOrderRequest request)
    {
        try
        {
            await _maintenanceService.CompleteWorkOrderAsync(
                id, request.TotalPartsCost, request.TotalLaborCost, request.DowntimeHours);
            return Ok(new { message = "Work order completed successfully" });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpPost("workorders/{id}/cancel")]
    public async Task<IActionResult> CancelWorkOrder(long id, [FromBody] string reason)
    {
        try
        {
            await _maintenanceService.CancelWorkOrderAsync(id, reason);
            return Ok(new { message = "Work order cancelled" });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }
}
