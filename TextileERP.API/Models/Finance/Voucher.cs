namespace TextileERP.API.Models.Finance;

public class Voucher
{
    public long VoucherId { get; set; }
    public long CompanyId { get; set; }
    public string VoucherNumber { get; set; } = string.Empty;
    public DateTime VoucherDate { get; set; }
    public string VoucherType { get; set; } = string.Empty;
    public string VoucherStatus { get; set; } = "Draft";
    
    public string? ReferenceType { get; set; }
    public long? ReferenceId { get; set; }
    public string? ReferenceNumber { get; set; }
    
    public decimal TotalDebit { get; set; }
    public decimal TotalCredit { get; set; }
    
    public string? PaymentMode { get; set; }
    public string? ChequeNumber { get; set; }
    public DateTime? ChequeDate { get; set; }
    public string? BankName { get; set; }
    public string? TransactionRef { get; set; }
    
    public decimal TDSAmount { get; set; }
    public decimal TCSAmount { get; set; }
    
    public string? Narration { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    public long? PostedBy { get; set; }
    public DateTime? PostedDate { get; set; }
    public bool IsCancelled { get; set; }
    public long? CancelledBy { get; set; }
    public DateTime? CancelledDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual ICollection<VoucherDetail>? Details { get; set; }
}

public class VoucherDetail
{
    public long VoucherDetailId { get; set; }
    public long VoucherId { get; set; }
    public int LineNumber { get; set; }
    public long LedgerId { get; set; }
    public decimal DebitAmount { get; set; }
    public decimal CreditAmount { get; set; }
    
    public long? PartyId { get; set; }
    public string? PartyType { get; set; }
    
    public string? BillReferenceNumber { get; set; }
    public DateTime? BillReferenceDate { get; set; }
    
    public string? GSTLedgerType { get; set; }
    public decimal GSTAmount { get; set; }
    
    public long? TDSLedgerId { get; set; }
    public decimal TDSAmount { get; set; }
    public long? TCSLedgerId { get; set; }
    public decimal TCSAmount { get; set; }
    
    public string? CostCenterCode { get; set; }
    public string? ProjectCode { get; set; }
    
    public string? LineNarration { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual Voucher? Voucher { get; set; }
    public virtual Master.Ledger? Ledger { get; set; }
    public virtual Master.Party? Party { get; set; }
}

public class BankAccount
{
    public long BankAccountId { get; set; }
    public long CompanyId { get; set; }
    public string BankAccountCode { get; set; } = string.Empty;
    public string BankAccountName { get; set; } = string.Empty;
    public string BankName { get; set; } = string.Empty;
    public string? BankBranch { get; set; }
    public string AccountNumber { get; set; } = string.Empty;
    public string? AccountHolderName { get; set; }
    public string IFSCCode { get; set; } = string.Empty;
    public string? MICRCode { get; set; }
    public string? SWIFTCode { get; set; }
    public string AccountType { get; set; } = "Current";
    public string CurrencyCode { get; set; } = "INR";
    public decimal OpeningBalance { get; set; }
    public decimal CurrentBalance { get; set; }
    public long LedgerId { get; set; }
    public bool IsDefault { get; set; }
    public bool IsActive { get; set; } = true;
    public bool IsReconciled { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Ledger? Ledger { get; set; }
    public virtual ICollection<BankTransaction>? Transactions { get; set; }
}

public class BankTransaction
{
    public long BankTransactionId { get; set; }
    public long BankAccountId { get; set; }
    public DateTime TransactionDate { get; set; }
    public string TransactionType { get; set; } = string.Empty;
    public string TransactionStatus { get; set; } = "Pending";
    
    public decimal DebitAmount { get; set; }
    public decimal CreditAmount { get; set; }
    public decimal BalanceAfter { get; set; }
    
    public string? ChequeNumber { get; set; }
    public DateTime? ChequeDate { get; set; }
    public string? TransactionRef { get; set; }
    public string? UTRNumber { get; set; }
    
    public long? PartyId { get; set; }
    public string? PartyName { get; set; }
    
    public string? Narration { get; set; }
    
    public bool IsReconciled { get; set; }
    public DateTime? ReconciledDate { get; set; }
    public long? ReconciledBy { get; set; }
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual BankAccount? BankAccount { get; set; }
    public virtual Master.Party? Party { get; set; }
}

public class OutstandingReceivable
{
    [System.ComponentModel.DataAnnotations.Key]
    public long ReceivableId { get; set; }
    public long CompanyId { get; set; }
    public long CustomerId { get; set; }
    
    public string ReferenceType { get; set; } = string.Empty;
    public long ReferenceId { get; set; }
    public string ReferenceNumber { get; set; } = string.Empty;
    public DateTime ReferenceDate { get; set; }
    
    public decimal InvoiceAmount { get; set; }
    public decimal PaidAmount { get; set; }
    
    public DateTime DueDate { get; set; }
    public string? AgingBucket { get; set; }
    
    public string PaymentStatus { get; set; } = "Unpaid";
    public bool IsActive { get; set; } = true;
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Party? Customer { get; set; }
}

public class OutstandingPayable
{
    [System.ComponentModel.DataAnnotations.Key]
    public long PayableId { get; set; }
    public long CompanyId { get; set; }
    public long SupplierId { get; set; }
    
    public string ReferenceType { get; set; } = string.Empty;
    public long ReferenceId { get; set; }
    public string ReferenceNumber { get; set; } = string.Empty;
    public DateTime ReferenceDate { get; set; }
    
    public decimal InvoiceAmount { get; set; }
    public decimal PaidAmount { get; set; }
    
    public DateTime DueDate { get; set; }
    public string? AgingBucket { get; set; }
    
    public string PaymentStatus { get; set; } = "Unpaid";
    public bool IsActive { get; set; } = true;
    
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.Party? Supplier { get; set; }
}
