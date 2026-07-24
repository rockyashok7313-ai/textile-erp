namespace TextileERP.API.Models.Master;

public class LedgerGroup : BaseModel
{
    public string GroupCode { get; set; } = string.Empty;
    public string GroupName { get; set; } = string.Empty;
    public long? ParentGroupId { get; set; }
    public string GroupType { get; set; } = string.Empty; // Assets, Liabilities, Income, Expenses
    public string GroupNature { get; set; } = string.Empty; // Debit, Credit
    public bool AffectsProfitLoss { get; set; }
    public bool IsSystemGroup { get; set; }
    
    // Navigation properties
    public virtual LedgerGroup? ParentGroup { get; set; }
    public virtual Company? Company { get; set; }
}

public class Ledger : BaseModel
{
    public string LedgerCode { get; set; } = string.Empty;
    public string LedgerName { get; set; } = string.Empty;
    public string? LedgerDisplayName { get; set; }
    public long LedgerGroupId { get; set; }
    public long? ParentLedgerId { get; set; }
    public string LedgerType { get; set; } = "General"; // General, Bank, Cash, GST, TDS, TCS
    public decimal OpeningBalance { get; set; }
    public string OpeningBalanceType { get; set; } = "Dr";
    public decimal CurrentBalance { get; set; }
    public string CurrencyCode { get; set; } = "INR";
    public bool GSTINApplicable { get; set; }
    public bool IsGSTLedger { get; set; }
    public bool IsTDSLedger { get; set; }
    public bool IsTCSLedger { get; set; }
    public bool IsBankLedger { get; set; }
    public bool IsCashLedger { get; set; }
    public bool IsSystemLedger { get; set; }
    
    // Navigation properties
    public virtual LedgerGroup? LedgerGroup { get; set; }
    public virtual Ledger? ParentLedger { get; set; }
    public virtual Company? Company { get; set; }
}
