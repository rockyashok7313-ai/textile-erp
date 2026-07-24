USE TextileERP;
GO

CREATE TABLE payroll.Departments
(
    DepartmentId     BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId        BIGINT NOT NULL,
    DepartmentCode   NVARCHAR(20) NOT NULL,
    DepartmentName   NVARCHAR(100) NOT NULL,
    Description      NVARCHAR(500) NULL,
    IsActive         BIT NOT NULL DEFAULT 1,
    CreatedBy        BIGINT NULL,
    CreatedDate      DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy       BIGINT NULL,
    ModifiedDate     DATETIME NULL,
    CONSTRAINT PK_Departments PRIMARY KEY (DepartmentId),
    CONSTRAINT UQ_DepartmentCode UNIQUE (CompanyId, DepartmentCode)
);
GO
