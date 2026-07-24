namespace TextileERP.API.Models.Master;

public class HSNMaster
{
    [System.ComponentModel.DataAnnotations.Key]
    public long HSNId { get; set; }
    public string HSNCode { get; set; } = string.Empty;
    public string HSNDescription { get; set; } = string.Empty;
    public int HSNLevel { get; set; }
    public string? ParentHSNCode { get; set; }
    public decimal GSTRate { get; set; }
    public decimal CessRate { get; set; }
    public bool IsGSTRApplicable { get; set; } = true;
    public string? UQC { get; set; }
    public bool IsTextileHSN { get; set; }
    public string? TextileCategory { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public DateTime? ModifiedDate { get; set; }
}

public class GSTRate
{
    public long GSTRateId { get; set; }
    public string GSTRateCode { get; set; } = string.Empty;
    public string GSTRateName { get; set; } = string.Empty;
    public decimal CGSTRate { get; set; }
    public decimal SGSTRate { get; set; }
    public decimal IGSTRate { get; set; }
    public decimal CessRate { get; set; }
    public DateTime EffectiveFrom { get; set; }
    public DateTime? EffectiveTo { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedDate { get; set; } = DateTime.Now;
}
