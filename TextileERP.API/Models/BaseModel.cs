namespace TextileERP.API.Models;

public abstract class BaseModel
{
    public long Id { get; set; }
    public long? CompanyId { get; set; }
    public long? CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public long? ModifiedBy { get; set; }
    public DateTime? ModifiedDate { get; set; }
    public bool IsActive { get; set; } = true;
}

public abstract class BaseAuditModel : BaseModel
{
    public bool IsCancelled { get; set; }
    public long? CancelledBy { get; set; }
    public DateTime? CancelledDate { get; set; }
    public string? CancelReason { get; set; }
}

public abstract class BaseTransactionModel : BaseAuditModel
{
    public string? Status { get; set; }
    public string? Remarks { get; set; }
    public string? InternalRemarks { get; set; }
}
