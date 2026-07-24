namespace TextileERP.API.Models.Master;

public class ItemCategory : BaseModel
{
    public string CategoryCode { get; set; } = string.Empty;
    public string CategoryName { get; set; } = string.Empty;
    public string? CategoryDescription { get; set; }
    public long? ParentCategoryId { get; set; }
    public int CategoryLevel { get; set; } = 1;
    public string? CategoryPath { get; set; }
    public decimal? DefaultGSTRate { get; set; }
    public string? DefaultHSNCode { get; set; }
    public string? DefaultUOM { get; set; }
    public bool IsRawMaterial { get; set; }
    public bool IsFinishedGood { get; set; }
    public bool IsSemiFinished { get; set; }
    public bool IsConsumable { get; set; }
    
    // Navigation properties
    public virtual ItemCategory? ParentCategory { get; set; }
    public virtual Company? Company { get; set; }
}
