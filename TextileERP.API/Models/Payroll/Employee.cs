using TextileERP.API.Models.Master;

namespace TextileERP.API.Models.Payroll;

public class Employee : BaseModel
{
    public string EmployeeCode { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? MiddleName { get; set; }
    public string? FatherName { get; set; }
    public string? SpouseName { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public DateTime DateOfJoining { get; set; }
    public string Gender { get; set; } = string.Empty;  // Male, Female, Other
    public string? MaritalStatus { get; set; }
    public string? BloodGroup { get; set; }
    public string? Nationality { get; set; } = "Indian";
    public string? Religion { get; set; }
    public string? Category { get; set; }  // General, SC, ST, OBC
    public bool PhysicallyChallenged { get; set; }

    public long? DepartmentId { get; set; }
    public long? DesignationId { get; set; }
    public long? ReportingToId { get; set; }
    public string EmploymentType { get; set; } = "Permanent"; // Permanent, Contract, Temporary
    public string? Shift { get; set; }

    // Identity
    public string? PAN { get; set; }
    public string? AadhaarNumber { get; set; }
    public string? PassportNumber { get; set; }
    public string? DrivingLicense { get; set; }

    // Statutory
    public string? PFNumber { get; set; }
    public string? ESINumber { get; set; }
    public string? UAN { get; set; }
    public bool IsPFApplicable { get; set; } = true;
    public bool IsESIApplicable { get; set; } = true;
    public bool IsPTApplicable { get; set; } = true;
    public string? PFAccountNumber { get; set; }
    public DateTime? PFJoinDate { get; set; }
    public DateTime? ESIJoinDate { get; set; }

    // Address
    public string? AddressLine1 { get; set; }
    public string? AddressLine2 { get; set; }
    public string? City { get; set; }
    public long? StateId { get; set; }
    public string? PinCode { get; set; }
    public long? CountryId { get; set; } = 1;

    // Contact
    public string? Phone { get; set; }
    public string? Mobile { get; set; }
    public string? PersonalEmail { get; set; }
    public string? OfficialEmail { get; set; }

    // Emergency Contact
    public string? EmergencyContactName { get; set; }
    public string? EmergencyContactPhone { get; set; }
    public string? EmergencyContactRelation { get; set; }

    // Bank
    public string? BankName { get; set; }
    public string? BankBranch { get; set; }
    public string? BankIFSC { get; set; }
    public string? BankAccountNumber { get; set; }
    public string? BankAccountType { get; set; }

    // Salary
    public decimal BasicSalary { get; set; }
    public decimal HRA { get; set; }
    public decimal DA { get; set; }
    public decimal ConveyanceAllowance { get; set; }
    public decimal MedicalAllowance { get; set; }
    public decimal SpecialAllowance { get; set; }
    public decimal OtherAllowance { get; set; }
    public decimal GrossSalary { get; set; }
    public decimal AnnualCTC { get; set; }

    // Leave Balance
    public decimal CasualLeaveBalance { get; set; }
    public decimal SickLeaveBalance { get; set; }
    public decimal EarnedLeaveBalance { get; set; }

    // Documents
    public string? PhotoPath { get; set; }
    public string? IDProofPath { get; set; }

    public bool IsLocked { get; set; }
    public DateTime? LastWorkingDate { get; set; }
    public string? ReasonForLeaving { get; set; }

    // Navigation
    public virtual Department? Department { get; set; }
    public virtual Designation? Designation { get; set; }
    public virtual Employee? ReportingTo { get; set; }
    public virtual Company? Company { get; set; }
}
