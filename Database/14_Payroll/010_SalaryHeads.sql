USE TextileERP;
GO

CREATE TABLE payroll.SalaryHeads
(
    HeadId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId       BIGINT NOT NULL,
    HeadCode        NVARCHAR(20) NOT NULL,
    HeadName        NVARCHAR(100) NOT NULL,
    HeadType        NVARCHAR(20) NOT NULL,   -- Earning, Deduction
    CalculationType NVARCHAR(20) NOT NULL DEFAULT 'Fixed', -- Fixed, Percentage
    DefaultAmount   DECIMAL(18,2) NOT NULL DEFAULT 0,
    DefaultPercent  DECIMAL(5,2) NOT NULL DEFAULT 0,
    BasedOn         NVARCHAR(20) NULL,  -- Basic, Gross, CTC
    IsStatutory     BIT NOT NULL DEFAULT 0,  -- PF, ESI, PT are statutory
    StatutoryType   NVARCHAR(20) NULL,  -- PF, ESI, PT, TDS
    SortOrder       INT NOT NULL DEFAULT 0,
    IsActive        BIT NOT NULL DEFAULT 1,
    CreatedBy       BIGINT NULL,
    CreatedDate     DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy      BIGINT NULL,
    ModifiedDate    DATETIME NULL,
    CONSTRAINT PK_SalaryHeads PRIMARY KEY (HeadId),
    CONSTRAINT UQ_SalaryHeadCode UNIQUE (CompanyId, HeadCode)
);
GO
