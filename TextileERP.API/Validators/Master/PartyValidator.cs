using FluentValidation;
using TextileERP.API.DTOs.Master;

namespace TextileERP.API.Validators.Master;

public class CreatePartyRequestValidator : AbstractValidator<CreatePartyRequest>
{
    public CreatePartyRequestValidator()
    {
        RuleFor(x => x.PartyCode)
            .NotEmpty().WithMessage("Party code is required")
            .MaximumLength(50).WithMessage("Party code must not exceed 50 characters");

        RuleFor(x => x.PartyName)
            .NotEmpty().WithMessage("Party name is required")
            .MaximumLength(200).WithMessage("Party name must not exceed 200 characters");

        RuleFor(x => x.PartyType)
            .NotEmpty().WithMessage("Party type is required")
            .Must(x => new[] { "Customer", "Supplier", "Both" }.Contains(x))
            .WithMessage("Invalid party type. Must be: Customer, Supplier, or Both");

        RuleFor(x => x.Email)
            .EmailAddress().WithMessage("Invalid email address")
            .When(x => !string.IsNullOrEmpty(x.Email));

        RuleFor(x => x.Phone)
            .MaximumLength(20).WithMessage("Phone must not exceed 20 characters")
            .When(x => !string.IsNullOrEmpty(x.Phone));

        RuleFor(x => x.Mobile)
            .MaximumLength(15).WithMessage("Mobile must not exceed 15 characters")
            .When(x => !string.IsNullOrEmpty(x.Mobile));

        RuleFor(x => x.GSTIN)
            .MaximumLength(15).WithMessage("GSTIN must not exceed 15 characters")
            .Matches(@"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$")
            .WithMessage("Invalid GSTIN format")
            .When(x => !string.IsNullOrEmpty(x.GSTIN));

        RuleFor(x => x.PAN)
            .MaximumLength(10).WithMessage("PAN must not exceed 10 characters")
            .Matches(@"^[A-Z]{5}[0-9]{4}[A-Z]{1}$")
            .WithMessage("Invalid PAN format")
            .When(x => !string.IsNullOrEmpty(x.PAN));

        RuleFor(x => x.CreditLimit)
            .GreaterThanOrEqualTo(0).WithMessage("Credit limit must be non-negative")
            .When(x => x.CreditLimit.HasValue);

        RuleFor(x => x.CreditDays)
            .GreaterThanOrEqualTo(0).WithMessage("Credit days must be non-negative")
            .When(x => x.CreditDays.HasValue);

        RuleFor(x => x.DiscountPercent)
            .InclusiveBetween(0, 100).WithMessage("Discount must be between 0 and 100")
            .When(x => x.DiscountPercent.HasValue);
    }
}
