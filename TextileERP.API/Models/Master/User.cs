namespace TextileERP.API.Models.Master;

public class User : BaseModel
{
    public string UserCode { get; set; } = string.Empty;
    public string UserName { get; set; } = string.Empty;
    public string LoginId { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string PasswordSalt { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? Mobile { get; set; }
    public string? EmployeeCode { get; set; }
    public string? Department { get; set; }
    public string? Designation { get; set; }
    public byte[]? Photo { get; set; }
    public string? PhotoPath { get; set; }
    public long? DefaultGodownId { get; set; }
    public long? DefaultLedgerId { get; set; }
    public bool IsAdmin { get; set; }
    public bool IsSuperAdmin { get; set; }
    public bool IsApprover { get; set; }
    public bool CanApprovePurchase { get; set; }
    public bool CanApproveSales { get; set; }
    public bool CanApprovePayment { get; set; }
    public decimal MaxDiscountPercent { get; set; }
    public decimal MaxCreditLimit { get; set; }
    public DateTime? LastLoginDate { get; set; }
    public DateTime? LastPasswordChange { get; set; }
    public int PasswordExpiryDays { get; set; } = 90;
    public int LoginAttempts { get; set; }
    public bool IsLocked { get; set; }
    public DateTime? LockedDate { get; set; }
    public bool TwoFactorEnabled { get; set; }
    public string? TwoFactorSecret { get; set; }
    
    // Navigation properties
    public virtual Company? Company { get; set; }
}
