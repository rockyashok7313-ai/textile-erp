namespace TextileERP.API.Models.Audit;

public class ActivityLog
{
    public long ActivityLogId { get; set; }
    public long CompanyId { get; set; }
    public long? UserId { get; set; }
    public string? UserName { get; set; }
    
    public string ActivityType { get; set; } = string.Empty;
    public string ModuleName { get; set; } = string.Empty;
    public string? SubModuleName { get; set; }
    public string? ActivityDescription { get; set; }
    
    public string? ReferenceType { get; set; }
    public long? ReferenceId { get; set; }
    public string? ReferenceNumber { get; set; }
    
    public string? OldValue { get; set; }
    public string? NewValue { get; set; }
    public string? ChangedColumns { get; set; }
    
    public string? IPAddress { get; set; }
    public string? BrowserInfo { get; set; }
    public string? DeviceInfo { get; set; }
    
    public DateTime ActivityDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.User? User { get; set; }
}

public class ErrorLog
{
    public long ErrorLogId { get; set; }
    public long? CompanyId { get; set; }
    public long? UserId { get; set; }
    
    public string ErrorLevel { get; set; } = string.Empty;
    public string? ErrorSource { get; set; }
    public int? ErrorNumber { get; set; }
    public string ErrorMessage { get; set; } = string.Empty;
    public string? ErrorProcedure { get; set; }
    public int? ErrorLine { get; set; }
    public string? ErrorStackTrace { get; set; }
    
    public string? RequestUrl { get; set; }
    public string? RequestMethod { get; set; }
    public string? RequestBody { get; set; }
    public string? IPAddress { get; set; }
    public string? UserAgent { get; set; }
    
    public bool IsResolved { get; set; }
    public long? ResolvedBy { get; set; }
    public DateTime? ResolvedDate { get; set; }
    public string? ResolutionNotes { get; set; }
    
    public DateTime ErrorDate { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual Master.Company? Company { get; set; }
    public virtual Master.User? User { get; set; }
}

public class LoginHistory
{
    public long LoginHistoryId { get; set; }
    public long UserId { get; set; }
    public long CompanyId { get; set; }
    public DateTime LoginDate { get; set; } = DateTime.Now;
    public DateTime? LogoutDate { get; set; }
    
    public string LoginStatus { get; set; } = string.Empty;
    public string? FailureReason { get; set; }
    
    public string? IPAddress { get; set; }
    public string? BrowserInfo { get; set; }
    public string? DeviceInfo { get; set; }
    public string? Location { get; set; }
    
    public string? SessionId { get; set; }
    public DateTime? TokenExpiry { get; set; }
    
    // Navigation properties
    public virtual Master.User? User { get; set; }
    public virtual Master.Company? Company { get; set; }
}
