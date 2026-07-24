USE TextileERP;
GO

CREATE TABLE payroll.PayrollPeriods
(
    PeriodId        BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId       BIGINT NOT NULL,
    PeriodName      NVARCHAR(20) NOT NULL,   -- Apr-2025, May-2025
    StartDate       DATE NOT NULL,
    EndDate         DATE NOT NULL,
    Status          NVARCHAR(20) NOT NULL DEFAULT 'Open',  -- Open, Processing, Closed, Paid
    ProcessedBy     BIGINT NULL,
    ProcessedDate   DATETIME NULL,
    ClosedBy        BIGINT NULL,
    ClosedDate      DATETIME NULL,
    Remarks         NVARCHAR(200) NULL,
    CreatedBy       BIGINT NULL,
    CreatedDate     DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy      BIGINT NULL,
    ModifiedDate    DATETIME NULL,
    CONSTRAINT PK_PayrollPeriods PRIMARY KEY (PeriodId),
    CONSTRAINT UQ_PayrollPeriod UNIQUE (CompanyId, PeriodName)
);
GO
