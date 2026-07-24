using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Payroll;

public class Attendance : BaseModel
{
    public long EmployeeId { get; set; }
    public DateTime AttendanceDate { get; set; }
    public string Status { get; set; } = "Present"; // Present, Absent, HalfDay, Leave, Holiday, WeeklyOff
    public string? HalfDayType { get; set; }  // FirstHalf, SecondHalf
    public DateTime? InTime { get; set; }
    public DateTime? OutTime { get; set; }
    public decimal? TotalHours { get; set; }
    public decimal OvertimeHours { get; set; }
    public bool IsOvertimeApproved { get; set; }
    public long? LeaveTypeId { get; set; }
    public string? Remarks { get; set; }

    public virtual Employee? Employee { get; set; }
    public virtual LeaveType? LeaveType { get; set; }
    public virtual Company? Company { get; set; }
}
