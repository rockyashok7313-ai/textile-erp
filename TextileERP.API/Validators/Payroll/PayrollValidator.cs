using FluentValidation;
using TextileERP.API.DTOs.Payroll;

namespace TextileERP.API.Validators.Payroll;

public class CreateEmployeeRequestValidator : AbstractValidator<CreateEmployeeRequest>
{
    public CreateEmployeeRequestValidator()
    {
        RuleFor(x => x.EmployeeCode).NotEmpty().WithMessage("Employee code is required")
            .MaximumLength(20).WithMessage("Employee code must not exceed 20 characters");
        RuleFor(x => x.FirstName).NotEmpty().WithMessage("First name is required")
            .MaximumLength(100).WithMessage("First name must not exceed 100 characters");
        RuleFor(x => x.LastName).NotEmpty().WithMessage("Last name is required")
            .MaximumLength(100).WithMessage("Last name must not exceed 100 characters");
        RuleFor(x => x.DateOfJoining).NotEmpty().WithMessage("Date of joining is required");
        RuleFor(x => x.Gender).NotEmpty().WithMessage("Gender is required")
            .Must(x => new[] { "Male", "Female", "Other" }.Contains(x))
            .WithMessage("Invalid gender. Must be Male, Female, or Other");
        RuleFor(x => x.PAN).Matches(@"^[A-Z]{5}[0-9]{4}[A-Z]{1}$")
            .WithMessage("Invalid PAN format").When(x => !string.IsNullOrEmpty(x.PAN));
        RuleFor(x => x.BasicSalary).GreaterThanOrEqualTo(0).WithMessage("Basic salary must be non-negative");
        RuleFor(x => x.HRA).GreaterThanOrEqualTo(0).WithMessage("HRA must be non-negative");
        RuleFor(x => x.DA).GreaterThanOrEqualTo(0).WithMessage("DA must be non-negative");
    }
}

public class MarkAttendanceRequestValidator : AbstractValidator<MarkAttendanceRequest>
{
    public MarkAttendanceRequestValidator()
    {
        RuleFor(x => x.EmployeeId).GreaterThan(0).WithMessage("Employee is required");
        RuleFor(x => x.AttendanceDate).NotEmpty().WithMessage("Attendance date is required");
        RuleFor(x => x.Status).NotEmpty().WithMessage("Status is required")
            .Must(x => new[] { "Present", "Absent", "HalfDay", "Leave", "Holiday", "WeeklyOff" }.Contains(x))
            .WithMessage("Invalid attendance status");
        RuleFor(x => x.OvertimeHours).GreaterThanOrEqualTo(0).WithMessage("Overtime hours must be non-negative");
    }
}

public class ProcessPayrollRequestValidator : AbstractValidator<ProcessPayrollRequest>
{
    public ProcessPayrollRequestValidator()
    {
        RuleFor(x => x.CompanyId).GreaterThan(0).WithMessage("Company is required");
        RuleFor(x => x.PeriodId).GreaterThan(0).WithMessage("Payroll period is required");
    }
}
