USE TextileERP;
GO

CREATE TABLE maintenance.SpareParts
(
    SparePartId         BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    SparePartCode       NVARCHAR(20) NOT NULL,
    SparePartName       NVARCHAR(200) NOT NULL,
    Description         NVARCHAR(500) NULL,
    Category            NVARCHAR(50) NULL,       -- Mechanical, Electrical, Electronic, Consumable
    UnitId              BIGINT NULL,
    MinStock            DECIMAL(10,2) NOT NULL DEFAULT 0,
    MaxStock            DECIMAL(10,2) NOT NULL DEFAULT 0,
    ReorderLevel        DECIMAL(10,2) NOT NULL DEFAULT 0,
    CurrentStock        DECIMAL(10,2) NOT NULL DEFAULT 0,
    UnitCost            DECIMAL(18,4) NOT NULL DEFAULT 0,
    AverageCost         DECIMAL(18,4) NOT NULL DEFAULT 0,
    LeadTimeDays        INT NOT NULL DEFAULT 7,
    CompatibleMachineTypes NVARCHAR(100) NULL,  -- AirJet, Sulzer, All
    Manufacturer        NVARCHAR(100) NULL,
    PartNumber          NVARCHAR(50) NULL,
    HSNCode             NVARCHAR(10) NULL,
    GSTRate             DECIMAL(5,2) NOT NULL DEFAULT 18,
    IsCriticalSpare     BIT NOT NULL DEFAULT 0,
    ShelfLifeDays       INT NULL,
    StorageLocation     NVARCHAR(100) NULL,
    PhotoPath           NVARCHAR(500) NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME NULL,
    CONSTRAINT PK_SpareParts PRIMARY KEY (SparePartId),
    CONSTRAINT UQ_SparePartCode UNIQUE (CompanyId, SparePartCode)
);
GO
