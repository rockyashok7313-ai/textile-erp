USE TextileERP;
GO

CREATE TABLE maintenance.Machines
(
    MachineId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    MachineCode         NVARCHAR(20) NOT NULL,
    MachineName         NVARCHAR(100) NOT NULL,
    MachineType         NVARCHAR(30) NOT NULL,   -- AirJet, Sulzer
    Make                NVARCHAR(100) NULL,       -- Toyota, Picanol, Sulzer
    Model               NVARCHAR(100) NULL,
    SerialNumber        NVARCHAR(100) NULL,
    Capacity            NVARCHAR(50) NULL,        -- e.g., 2.5 meters width
    LoomCount           INT NOT NULL DEFAULT 1,
    Location            NVARCHAR(100) NULL,       -- Shop floor, Bay number
    FloorId             NVARCHAR(50) NULL,
    BayNumber           NVARCHAR(20) NULL,
    InstallationDate    DATE NULL,
    WarrantyExpiryDate  DATE NULL,
    LastServiceDate     DATE NULL,
    NextServiceDate     DATE NULL,
    OperatingHours      DECIMAL(10,2) NOT NULL DEFAULT 0,
    Status              NVARCHAR(20) NOT NULL DEFAULT 'Running', -- Running, Down, Maintenance, Idle, Scrap
    HealthScore         DECIMAL(5,2) NULL,        -- 0-100
    EstimatedValue      DECIMAL(18,2) NULL,
    SalvageValue        DECIMAL(18,2) NULL,
    UsefulLifeYears     INT NULL,
    DepreciationMethod  NVARCHAR(20) NULL,       -- StraightLine, WDV
    PhotoPath           NVARCHAR(500) NULL,
    Remarks             NVARCHAR(500) NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME NULL,
    CONSTRAINT PK_Machines PRIMARY KEY (MachineId),
    CONSTRAINT UQ_MachineCode UNIQUE (CompanyId, MachineCode)
);
GO
