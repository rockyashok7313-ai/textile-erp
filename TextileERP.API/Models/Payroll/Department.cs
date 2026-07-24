using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Payroll;

public class Department : BaseModel
{
    public string DepartmentCode { get; set; } = string.Empty;
    public string DepartmentName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public virtual Company? Company { get; set; }
}
