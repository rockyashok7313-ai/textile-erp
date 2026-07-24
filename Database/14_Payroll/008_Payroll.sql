USE TextileERP;
GO

CREATE TABLE payroll.Payroll
(
    PayrollId       BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId       BIGINT NOT NULL,
    PeriodId        BIGINT NOT NULL,
    PayrollNumber   NVARCHAR(20) NOT NULL,
    ProcessDate     DATETIME NOT NULL DEFAULT GETDATE(),
    TotalEmployees  INT NOT NULL DEFAULT 0,
    TotalDaysWorked INT NOT NULL DEFAULT 0,
    TotalOvertimeHours DECIMAL(8,2) NOT NULL DEFAULT 0,
    TotalLeaves     INT NOT NULL DEFAULT 0,
    GrossPay        DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalEarnings   DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalDeductions DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalEmployerCost DECIMAL(18,2) NOT NULL DEFAULT 0,
    NetPay          DECIMAL(18,2) NOT NULL DEFAULT 0,
    Status          NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Approved, Paid, Cancelled
    ApprovedBy      BIGINT NULL,
    ApprovedDate    DATETIME NULL,
    PaidBy          BIGINT NULL,
    PaidDate        DATETIME NULL,
    Remarks         NVARCHAR(500) NULL,
    CreatedBy       BIGINT NULL,
    CreatedDate     DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy      BIGINT NULL,
    ModifiedDate    DATETIME NULL,
    CONSTRAINT PK_Payroll PRIMARY KEY (PayrollId),
    CONSTRAINT UQ_PayrollNumber UNIQUE (CompanyId, PayrollNumber),
    CONSTRAINT FK_Payroll_Period FOREIGN KEY (PeriodId) REFERENCES payroll.PayrollPeriods(PeriodId)
);
GO
