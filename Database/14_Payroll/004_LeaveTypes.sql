USE TextileERP;
GO

CREATE TABLE payroll.LeaveTypes
(
    LeaveTypeId     BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId       BIGINT NOT NULL,
    LeaveTypeCode   NVARCHAR(10) NOT NULL,
    LeaveTypeName   NVARCHAR(50) NOT NULL,
    DaysPerYear     DECIMAL(5,1) NOT NULL DEFAULT 0,
    IsCarryForward  BIT NOT NULL DEFAULT 0,
    MaxCarryForward DECIMAL(5,1) NOT NULL DEFAULT 0,
    IsPaid          BIT NOT NULL DEFAULT 1,
    IsHalfDayAllowed BIT NOT NULL DEFAULT 1,
    IsEarnedLeave   BIT NOT NULL DEFAULT 0,
    IsMaternityLeave BIT NOT NULL DEFAULT 0,
    IsPaternityLeave BIT NOT NULL DEFAULT 0,
    Description     NVARCHAR(200) NULL,
    SortOrder       INT NOT NULL DEFAULT 0,
    IsActive        BIT NOT NULL DEFAULT 1,
    CreatedBy       BIGINT NULL,
    CreatedDate     DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy      BIGINT NULL,
    ModifiedDate    DATETIME NULL,
    CONSTRAINT PK_LeaveTypes PRIMARY KEY (LeaveTypeId),
    CONSTRAINT UQ_LeaveTypeCode UNIQUE (CompanyId, LeaveTypeCode)
);
GO
