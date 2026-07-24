using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Payroll;

public class Designation : BaseModel
{
    public string DesignationCode { get; set; } = string.Empty;
    public string DesignationName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public virtual Company? Company { get; set; }
}
