using FluentValidation;
using TextileERP.API.DTOs.Maintenance;

namespace TextileERP.API.Validators.Maintenance;

public class CreateMachineRequestValidator : AbstractValidator<CreateMachineRequest>
{
    public CreateMachineRequestValidator()
    {
        RuleFor(x => x.MachineCode).NotEmpty().WithMessage("Machine code is required")
            .MaximumLength(20).WithMessage("Machine code must not exceed 20 characters");
        RuleFor(x => x.MachineName).NotEmpty().WithMessage("Machine name is required")
            .MaximumLength(100).WithMessage("Machine name must not exceed 100 characters");
        RuleFor(x => x.MachineType).NotEmpty().WithMessage("Machine type is required")
            .Must(x => new[] { "AirJet", "Sulzer" }.Contains(x))
            .WithMessage("Invalid machine type. Must be AirJet or Sulzer");
        RuleFor(x => x.LoomCount).GreaterThan(0).WithMessage("Loom count must be greater than 0");
    }
}

public class CreateSparePartRequestValidator : AbstractValidator<CreateSparePartRequest>
{
    public CreateSparePartRequestValidator()
    {
        RuleFor(x => x.SparePartCode).NotEmpty().WithMessage("Spare part code is required")
            .MaximumLength(20).WithMessage("Spare part code must not exceed 20 characters");
        RuleFor(x => x.SparePartName).NotEmpty().WithMessage("Spare part name is required")
            .MaximumLength(200).WithMessage("Spare part name must not exceed 200 characters");
        RuleFor(x => x.Category).Must(x => x == null || new[] { "Mechanical", "Electrical", "Electronic", "Consumable" }.Contains(x))
            .WithMessage("Invalid category");
        RuleFor(x => x.UnitCost).GreaterThanOrEqualTo(0).WithMessage("Unit cost must be non-negative");
        RuleFor(x => x.MinStock).GreaterThanOrEqualTo(0).WithMessage("Min stock must be non-negative");
        RuleFor(x => x.MaxStock).GreaterThanOrEqualTo(x => x.MinStock).WithMessage("Max stock must be >= min stock");
    }
}

public class CreateMaintenanceRequestRequestValidator : AbstractValidator<CreateMaintenanceRequestRequest>
{
    public CreateMaintenanceRequestRequestValidator()
    {
        RuleFor(x => x.CompanyId).GreaterThan(0).WithMessage("Company is required");
        RuleFor(x => x.MachineId).GreaterThan(0).WithMessage("Machine is required");
        RuleFor(x => x.FaultDescription).NotEmpty().WithMessage("Fault description is required")
            .MaximumLength(1000).WithMessage("Fault description must not exceed 1000 characters");
        RuleFor(x => x.Priority).NotEmpty().WithMessage("Priority is required")
            .Must(x => new[] { "Low", "Medium", "High", "Critical" }.Contains(x))
            .WithMessage("Invalid priority");
    }
}

public class CreateWorkOrderRequestValidator : AbstractValidator<CreateWorkOrderRequest>
{
    public CreateWorkOrderRequestValidator()
    {
        RuleFor(x => x.CompanyId).GreaterThan(0).WithMessage("Company is required");
        RuleFor(x => x.MachineId).GreaterThan(0).WithMessage("Machine is required");
    }
}

public class CompleteWorkOrderRequestValidator : AbstractValidator<CompleteWorkOrderRequest>
{
    public CompleteWorkOrderRequestValidator()
    {
        RuleFor(x => x.TotalPartsCost).GreaterThanOrEqualTo(0).WithMessage("Parts cost must be non-negative");
        RuleFor(x => x.TotalLaborCost).GreaterThanOrEqualTo(0).WithMessage("Labor cost must be non-negative");
        RuleFor(x => x.DowntimeHours).GreaterThanOrEqualTo(0).WithMessage("Downtime hours must be non-negative");
    }
}
