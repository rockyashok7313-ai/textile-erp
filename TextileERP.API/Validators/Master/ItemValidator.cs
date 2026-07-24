using FluentValidation;
using TextileERP.API.DTOs.Master;

namespace TextileERP.API.Validators.Master;

public class CreateItemRequestValidator : AbstractValidator<CreateItemRequest>
{
    public CreateItemRequestValidator()
    {
        RuleFor(x => x.ItemCode)
            .NotEmpty().WithMessage("Item code is required")
            .MaximumLength(50).WithMessage("Item code must not exceed 50 characters");

        RuleFor(x => x.ItemName)
            .NotEmpty().WithMessage("Item name is required")
            .MaximumLength(200).WithMessage("Item name must not exceed 200 characters");

        RuleFor(x => x.ItemDescription)
            .MaximumLength(500).WithMessage("Description must not exceed 500 characters");

        RuleFor(x => x.ItemType)
            .NotEmpty().WithMessage("Item type is required")
            .Must(x => new[] { "Fabric", "Yarn", "Accessory", "Finished", "RawMaterial" }.Contains(x))
            .WithMessage("Invalid item type. Must be: Fabric, Yarn, Accessory, Finished, or RawMaterial");

        RuleFor(x => x.HSNCode)
            .NotEmpty().WithMessage("HSN code is required")
            .MaximumLength(20).WithMessage("HSN code must not exceed 20 characters");

        RuleFor(x => x.UnitId)
            .GreaterThan(0).WithMessage("Unit is required");

        RuleFor(x => x.SellingPrice)
            .GreaterThanOrEqualTo(0).WithMessage("Selling price must be non-negative")
            .When(x => x.SellingPrice.HasValue);

        RuleFor(x => x.PurchasePrice)
            .GreaterThanOrEqualTo(0).WithMessage("Purchase price must be non-negative")
            .When(x => x.PurchasePrice.HasValue);

        RuleFor(x => x.TaxRate)
            .InclusiveBetween(0, 100).WithMessage("Tax rate must be between 0 and 100")
            .When(x => x.TaxRate.HasValue);

        RuleFor(x => x.DiscountPercent)
            .InclusiveBetween(0, 100).WithMessage("Discount must be between 0 and 100")
            .When(x => x.DiscountPercent.HasValue);
    }
}
