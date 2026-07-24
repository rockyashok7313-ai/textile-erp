USE TextileERP;
GO

CREATE TABLE payroll.Employees
(
    EmployeeId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    EmployeeCode        NVARCHAR(20) NOT NULL,
    FirstName           NVARCHAR(100) NOT NULL,
    LastName            NVARCHAR(100) NOT NULL,
    MiddleName          NVARCHAR(100) NULL,
    FatherName          NVARCHAR(100) NULL,
    SpouseName          NVARCHAR(100) NULL,
    DateOfBirth         DATE NULL,
    DateOfJoining       DATE NOT NULL,
    Gender              NVARCHAR(10) NOT NULL,  -- Male, Female, Other
    MaritalStatus       NVARCHAR(20) NULL,      -- Single, Married, Divorced, Widowed
    BloodGroup          NVARCHAR(5) NULL,
    Nationality         NVARCHAR(50) NULL DEFAULT 'Indian',
    Religion            NVARCHAR(50) NULL,
    Category            NVARCHAR(50) NULL,      -- General, SC, ST, OBC
    PhysicallyChallenged BIT NOT NULL DEFAULT 0,

    DepartmentId        BIGINT NULL,
    DesignationId       BIGINT NULL,
    ReportingToId       BIGINT NULL,
    EmploymentType      NVARCHAR(20) NOT NULL DEFAULT 'Permanent', -- Permanent, Contract, Temporary
    Shift               NVARCHAR(20) NULL,

    -- Identity
    PAN                 NVARCHAR(10) NULL,
    AadhaarNumber       NVARCHAR(20) NULL,
    PassportNumber      NVARCHAR(20) NULL,
    DrivingLicense      NVARCHAR(20) NULL,

    -- Statutory
    PFNumber            NVARCHAR(20) NULL,
    ESINumber           NVARCHAR(20) NULL,
    UAN                 NVARCHAR(20) NULL,
    IsPFApplicable      BIT NOT NULL DEFAULT 1,
    IsESIApplicable     BIT NOT NULL DEFAULT 1,
    IsPTApplicable      BIT NOT NULL DEFAULT 1,
    PFAccountNumber     NVARCHAR(20) NULL,
    PFJoinDate          DATE NULL,
    ESIJoinDate         DATE NULL,

    -- Address
    AddressLine1        NVARCHAR(200) NULL,
    AddressLine2        NVARCHAR(200) NULL,
    City                NVARCHAR(100) NULL,
    StateId             BIGINT NULL,
    PinCode             NVARCHAR(10) NULL,
    CountryId           BIGINT NULL DEFAULT 1,

    -- Contact
    Phone               NVARCHAR(20) NULL,
    Mobile              NVARCHAR(15) NULL,
    PersonalEmail       NVARCHAR(100) NULL,
    OfficialEmail       NVARCHAR(100) NULL,

    -- Emergency Contact
    EmergencyContactName  NVARCHAR(100) NULL,
    EmergencyContactPhone NVARCHAR(15) NULL,
    EmergencyContactRelation NVARCHAR(50) NULL,

    -- Bank Details
    BankName            NVARCHAR(100) NULL,
    BankBranch          NVARCHAR(100) NULL,
    BankIFSC            NVARCHAR(20) NULL,
    BankAccountNumber   NVARCHAR(30) NULL,
    BankAccountType     NVARCHAR(20) NULL,  -- Savings, Current

    -- Salary
    BasicSalary         DECIMAL(18,2) NOT NULL DEFAULT 0,
    HRA                 DECIMAL(18,2) NOT NULL DEFAULT 0,
    DA                  DECIMAL(18,2) NOT NULL DEFAULT 0,
    ConveyanceAllowance DECIMAL(18,2) NOT NULL DEFAULT 0,
    MedicalAllowance    DECIMAL(18,2) NOT NULL DEFAULT 0,
    SpecialAllowance    DECIMAL(18,2) NOT NULL DEFAULT 0,
    OtherAllowance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    GrossSalary         DECIMAL(18,2) NOT NULL DEFAULT 0,
    AnnualCTC           DECIMAL(18,2) NOT NULL DEFAULT 0,

    -- Leave Balance
    CasualLeaveBalance  DECIMAL(5,1) NOT NULL DEFAULT 0,
    SickLeaveBalance    DECIMAL(5,1) NOT NULL DEFAULT 0,
    EarnedLeaveBalance  DECIMAL(5,1) NOT NULL DEFAULT 0,

    -- Photo & Documents
    PhotoPath           NVARCHAR(500) NULL,
    IDProofPath         NVARCHAR(500) NULL,

    IsActive            BIT NOT NULL DEFAULT 1,
    IsLocked            BIT NOT NULL DEFAULT 0,
    LastWorkingDate     DATE NULL,
    ReasonForLeaving    NVARCHAR(200) NULL,
    Remarks             NVARCHAR(500) NULL,

    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME NULL,

    CONSTRAINT PK_Employees PRIMARY KEY (EmployeeId),
    CONSTRAINT UQ_EmployeeCode UNIQUE (CompanyId, EmployeeCode),
    CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentId) REFERENCES payroll.Departments(DepartmentId),
    CONSTRAINT FK_Employee_Designation FOREIGN KEY (DesignationId) REFERENCES payroll.Designations(DesignationId),
    CONSTRAINT FK_Employee_ReportingTo FOREIGN KEY (ReportingToId) REFERENCES payroll.Employees(EmployeeId)
);
GO
