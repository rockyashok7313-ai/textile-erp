using FluentValidation;
using TextileERP.API.DTOs.Transactions;

namespace TextileERP.API.Validators.Transactions;

public class CreateSalesInvoiceRequestValidator : AbstractValidator<CreateSalesInvoiceRequest>
{
    public CreateSalesInvoiceRequestValidator()
    {
        RuleFor(x => x.CompanyId)
            .GreaterThan(0).WithMessage("Company is required");

        RuleFor(x => x.CustomerId)
            .GreaterThan(0).WithMessage("Customer is required");

        RuleFor(x => x.Details)
            .NotEmpty().WithMessage("At least one invoice detail is required");

        RuleFor(x => x.Details)
            .Must(details => details.All(d => d.ItemId > 0))
            .WithMessage("All details must have a valid item");

        RuleFor(x => x.Details)
            .Must(details => details.All(d => d.Quantity > 0))
            .WithMessage("All details must have quantity greater than 0");

        RuleFor(x => x.Details)
            .Must(details => details.All(d => d.Rate >= 0))
            .WithMessage("All details must have rate greater than or equal to 0");

        RuleFor(x => x.InsuranceAmount)
            .GreaterThanOrEqualTo(0).WithMessage("Insurance amount must be non-negative")
            .When(x => x.InsuranceAmount.HasValue);

        RuleFor(x => x.FreightAmount)
            .GreaterThanOrEqualTo(0).WithMessage("Freight amount must be non-negative")
            .When(x => x.FreightAmount.HasValue);

        RuleFor(x => x.OtherCharges)
            .GreaterThanOrEqualTo(0).WithMessage("Other charges must be non-negative")
            .When(x => x.OtherCharges.HasValue);
    }
}

public class CreateSalesInvoiceDetailRequestValidator : AbstractValidator<CreateSalesInvoiceDetailRequest>
{
    public CreateSalesInvoiceDetailRequestValidator()
    {
        RuleFor(x => x.ItemId)
            .GreaterThan(0).WithMessage("Item is required");

        RuleFor(x => x.Quantity)
            .GreaterThan(0).WithMessage("Quantity must be greater than 0");

        RuleFor(x => x.Rate)
            .GreaterThanOrEqualTo(0).WithMessage("Rate must be non-negative");

        RuleFor(x => x.DiscountPercent)
            .InclusiveBetween(0, 100).WithMessage("Discount must be between 0 and 100")
            .When(x => x.DiscountPercent.HasValue);

        RuleFor(x => x.DiscountAmount)
            .GreaterThanOrEqualTo(0).WithMessage("Discount amount must be non-negative")
            .When(x => x.DiscountAmount.HasValue);
    }
}
