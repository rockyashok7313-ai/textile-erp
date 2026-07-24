using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Payroll;

public class SalaryHead : BaseModel
{
    public string HeadCode { get; set; } = string.Empty;
    public string HeadName { get; set; } = string.Empty;
    public string HeadType { get; set; } = string.Empty;   // Earning, Deduction
    public string CalculationType { get; set; } = "Fixed"; // Fixed, Percentage
    public decimal DefaultAmount { get; set; }
    public decimal DefaultPercent { get; set; }
    public string? BasedOn { get; set; }  // Basic, Gross, CTC
    public bool IsStatutory { get; set; }
    public string? StatutoryType { get; set; } // PF, ESI, PT, TDS
    public int SortOrder { get; set; }
    public virtual Company? Company { get; set; }
}
