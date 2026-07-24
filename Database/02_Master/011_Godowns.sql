-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - GODOWNS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Godowns (Warehouses)
CREATE TABLE master.Godowns
(
    GodownId            BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    GodownCode          NVARCHAR(20) NOT NULL,
    GodownName          NVARCHAR(200) NOT NULL,
    GodownType          NVARCHAR(30) NOT NULL DEFAULT 'Warehouse',  -- Warehouse, Factory, Showroom, Yard
    GodownAddress       NVARCHAR(500) NULL,
    AddressLine1        NVARCHAR(200) NULL,
    AddressLine2        NVARCHAR(200) NULL,
    City                NVARCHAR(100) NULL,
    StateId             BIGINT NULL,
    StateCode           NVARCHAR(2) NULL,
    PinCode             NVARCHAR(10) NULL,
    Phone               NVARCHAR(20) NULL,
    ManagerName         NVARCHAR(100) NULL,
    ManagerContact      NVARCHAR(20) NULL,
    TotalArea           DECIMAL(10,2) NULL,  -- in sqft or sqm
    AreaUnit            NVARCHAR(10) NULL DEFAULT 'sqft',
    Latitude            DECIMAL(10,8) NULL,
    Longitude           DECIMAL(11,8) NULL,
    IsDefault           BIT NOT NULL DEFAULT 0,
    IsMainGodown        BIT NOT NULL DEFAULT 0,
    IsProductionUnit    BIT NOT NULL DEFAULT 0,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Godowns PRIMARY KEY CLUSTERED (GodownId),
    CONSTRAINT UQ_Godowns_CompanyGodownCode UNIQUE (CompanyId, GodownCode),
    CONSTRAINT FK_Godowns_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_Godowns_GodownType CHECK (GodownType IN ('Warehouse', 'Factory', 'Showroom', 'Yard', 'Store'))
);
GO

-- Godown Racks/Bins/Positions (for location tracking)
CREATE TABLE master.GodownLocations
(
    LocationId          BIGINT IDENTITY(1,1) NOT NULL,
    GodownId            BIGINT NOT NULL,
    LocationCode        NVARCHAR(20) NOT NULL,
    LocationName        NVARCHAR(100) NOT NULL,
    LocationType        NVARCHAR(20) NOT NULL,  -- Rack, Bin, Position, Floor
    RackNumber          NVARCHAR(20) NULL,
    ShelfNumber         NVARCHAR(20) NULL,
    BinNumber           NVARCHAR(20) NULL,
    MaxCapacity         DECIMAL(18,4) NULL,
    CurrentOccupancy    DECIMAL(18,4) NOT NULL DEFAULT 0,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_GodownLocations PRIMARY KEY CLUSTERED (LocationId),
    CONSTRAINT UQ_GodownLocations_GodownLocationCode UNIQUE (GodownId, LocationCode),
    CONSTRAINT FK_GodownLocations_Godowns FOREIGN KEY (GodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT CK_GodownLocations_LocationType CHECK (LocationType IN ('Rack', 'Bin', 'Position', 'Floor'))
);
GO

PRINT 'Tables master.Godowns, master.GodownLocations created successfully.';
GO
