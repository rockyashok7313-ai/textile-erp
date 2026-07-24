USE TextileERP;
GO

CREATE TABLE payroll.Designations
(
    DesignationId    BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId        BIGINT NOT NULL,
    DesignationCode  NVARCHAR(20) NOT NULL,
    DesignationName  NVARCHAR(100) NOT NULL,
    Description      NVARCHAR(500) NULL,
    IsActive         BIT NOT NULL DEFAULT 1,
    CreatedBy        BIGINT NULL,
    CreatedDate      DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy       BIGINT NULL,
    ModifiedDate     DATETIME NULL,
    CONSTRAINT PK_Designations PRIMARY KEY (DesignationId),
    CONSTRAINT UQ_DesignationCode UNIQUE (CompanyId, DesignationCode)
);
GO
