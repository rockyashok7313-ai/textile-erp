USE TextileERP;
GO

CREATE TABLE payroll.PayrollDetails
(
    DetailId          BIGINT IDENTITY(1,1) NOT NULL,
    PayrollId         BIGINT NOT NULL,
    EmployeeId        BIGINT NOT NULL,
    EmployeeCode      NVARCHAR(20) NOT NULL,
    EmployeeName      NVARCHAR(200) NOT NULL,
    DepartmentId      BIGINT NULL,
    DesignationId     BIGINT NULL,

    -- Attendance Summary
    DaysInMonth       INT NOT NULL DEFAULT 30,
    WorkingDays       INT NOT NULL DEFAULT 0,
    DaysPresent       INT NOT NULL DEFAULT 0,
    DaysAbsent        INT NOT NULL DEFAULT 0,
    DaysOnLeave       INT NOT NULL DEFAULT 0,
    Holidays          INT NOT NULL DEFAULT 0,
    WeeklyOffs        INT NOT NULL DEFAULT 0,
    OvertimeHours     DECIMAL(5,2) NOT NULL DEFAULT 0,

    -- Earnings
    BasicSalary       DECIMAL(18,2) NOT NULL DEFAULT 0,
    BasicEarned       DECIMAL(18,2) NOT NULL DEFAULT 0,
    HRA               DECIMAL(18,2) NOT NULL DEFAULT 0,
    DA                DECIMAL(18,2) NOT NULL DEFAULT 0,
    ConveyanceAllowance DECIMAL(18,2) NOT NULL DEFAULT 0,
    MedicalAllowance  DECIMAL(18,2) NOT NULL DEFAULT 0,
    SpecialAllowance  DECIMAL(18,2) NOT NULL DEFAULT 0,
    OtherAllowance    DECIMAL(18,2) NOT NULL DEFAULT 0,
    OvertimeAmount    DECIMAL(18,2) NOT NULL DEFAULT 0,
    LeaveEncashment   DECIMAL(18,2) NOT NULL DEFAULT 0,
    Bonus             DECIMAL(18,2) NOT NULL DEFAULT 0,
    GrossEarnings     DECIMAL(18,2) NOT NULL DEFAULT 0,

    -- Deductions (Employee)
    PF_Employee       DECIMAL(18,2) NOT NULL DEFAULT 0,
    ESI_Employee      DECIMAL(18,2) NOT NULL DEFAULT 0,
    ProfessionalTax   DECIMAL(18,2) NOT NULL DEFAULT 0,
    TDS               DECIMAL(18,2) NOT NULL DEFAULT 0,
    LoanDeduction     DECIMAL(18,2) NOT NULL DEFAULT 0,
    AdvanceDeduction  DECIMAL(18,2) NOT NULL DEFAULT 0,
    OtherDeductions   DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalDeductions   DECIMAL(18,2) NOT NULL DEFAULT 0,

    -- Employer Contribution
    PF_Employer       DECIMAL(18,2) NOT NULL DEFAULT 0,
    ESI_Employer      DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalEmployerCost DECIMAL(18,2) NOT NULL DEFAULT 0,

    -- Net Pay
    NetPay            DECIMAL(18,2) NOT NULL DEFAULT 0,
    AmountInWords     NVARCHAR(500) NULL,

    -- Payment
    PaymentMode       NVARCHAR(20) NULL,  -- BankTransfer, Cheque, Cash
    BankAccountNumber NVARCHAR(30) NULL,
    ChequeNumber      NVARCHAR(20) NULL,
    PaymentDate       DATE NULL,
    IsPaid            BIT NOT NULL DEFAULT 0,

    Remarks           NVARCHAR(200) NULL,
    CreatedBy         BIGINT NULL,
    CreatedDate       DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy        BIGINT NULL,
    ModifiedDate      DATETIME NULL,

    CONSTRAINT PK_PayrollDetails PRIMARY KEY (DetailId),
    CONSTRAINT UQ_PayrollDetail UNIQUE (PayrollId, EmployeeId),
    CONSTRAINT FK_PayrollDetail_Payroll FOREIGN KEY (PayrollId) REFERENCES payroll.Payroll(PayrollId),
    CONSTRAINT FK_PayrollDetail_Employee FOREIGN KEY (EmployeeId) REFERENCES payroll.Employees(EmployeeId)
);
GO
