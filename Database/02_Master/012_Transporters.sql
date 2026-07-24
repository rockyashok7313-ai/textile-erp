-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - TRANSPORTERS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Transporters
CREATE TABLE master.Transporters
(
    TransporterId       BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    TransporterCode     NVARCHAR(20) NOT NULL,
    TransporterName     NVARCHAR(200) NOT NULL,
    GSTIN               NVARCHAR(15) NULL,
    PAN                 NVARCHAR(10) NULL,
    ContactPerson       NVARCHAR(100) NULL,
    Phone               NVARCHAR(20) NULL,
    Mobile              NVARCHAR(20) NULL,
    Email               NVARCHAR(100) NULL,
    Address             NVARCHAR(500) NULL,
    City                NVARCHAR(100) NULL,
    StateId             BIGINT NULL,
    StateCode           NVARCHAR(2) NULL,
    PinCode             NVARCHAR(10) NULL,
    TransporterType     NVARCHAR(20) NOT NULL DEFAULT 'Road',  -- Road, Rail, Air, Ship
    IsGSTRegistered     BIT NOT NULL DEFAULT 1,
    IsEWayBillRegistered BIT NOT NULL DEFAULT 1,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Transporters PRIMARY KEY CLUSTERED (TransporterId),
    CONSTRAINT UQ_Transporters_CompanyTransporterCode UNIQUE (CompanyId, TransporterCode),
    CONSTRAINT FK_Transporters_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_Transporters_TransporterType CHECK (TransporterType IN ('Road', 'Rail', 'Air', 'Ship'))
);
GO

-- Vehicle Master
CREATE TABLE master.Vehicles
(
    VehicleId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    VehicleNumber       NVARCHAR(20) NOT NULL,
    VehicleType         NVARCHAR(30) NOT NULL,  -- TATA, EICHER, CONTAINER, etc.
    VehicleDescription  NVARCHAR(200) NULL,
    Capacity            DECIMAL(10,2) NULL,  -- in tonnes
    CapacityUnit        NVARCHAR(10) NOT NULL DEFAULT 'Tonnes',
    TransporterId       BIGINT NULL,
    DriverName          NVARCHAR(100) NULL,
    DriverLicenseNo     NVARCHAR(50) NULL,
    DriverMobile        NVARCHAR(20) NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Vehicles PRIMARY KEY CLUSTERED (VehicleId),
    CONSTRAINT UQ_Vehicles_CompanyVehicleNumber UNIQUE (CompanyId, VehicleNumber),
    CONSTRAINT FK_Vehicles_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_Vehicles_Transporters FOREIGN KEY (TransporterId) 
        REFERENCES master.Transporters(TransporterId)
);
GO

PRINT 'Tables master.Transporters, master.Vehicles created successfully.';
GO
