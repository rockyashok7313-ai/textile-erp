-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - UNITS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Units of Measurement
CREATE TABLE master.Units
(
    UnitId              BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    UnitCode            NVARCHAR(10) NOT NULL,
    UnitName            NVARCHAR(50) NOT NULL,
    UnitFullName         NVARCHAR(100) NULL,
    UnitType            NVARCHAR(20) NOT NULL,  -- Quantity, Weight, Length, Area, Volume
    ConversionFactor    DECIMAL(18,6) NOT NULL DEFAULT 1,
    BaseUnitId          BIGINT NULL,
    DecimalPlaces       INT NOT NULL DEFAULT 2,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Units PRIMARY KEY CLUSTERED (UnitId),
    CONSTRAINT UQ_Units_CompanyUnitCode UNIQUE (CompanyId, UnitCode),
    CONSTRAINT FK_Units_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_Units_BaseUnit FOREIGN KEY (BaseUnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_Units_UnitType CHECK (UnitType IN ('Quantity', 'Weight', 'Length', 'Area', 'Volume'))
);
GO

-- Unit Conversions (for multi-unit scenarios)
CREATE TABLE master.UnitConversions
(
    ConversionId        BIGINT IDENTITY(1,1) NOT NULL,
    FromUnitId          BIGINT NOT NULL,
    ToUnitId            BIGINT NOT NULL,
    ConversionFactor    DECIMAL(18,6) NOT NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT PK_UnitConversions PRIMARY KEY CLUSTERED (ConversionId),
    CONSTRAINT UQ_UnitConversions UNIQUE (FromUnitId, ToUnitId),
    CONSTRAINT FK_UnitConversions_FromUnit FOREIGN KEY (FromUnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_UnitConversions_ToUnit FOREIGN KEY (ToUnitId) 
        REFERENCES master.Units(UnitId)
);
GO

PRINT 'Tables master.Units, master.UnitConversions created successfully.';
GO
