-- ============================================================================
-- TEXTILE ERP - INVENTORY MODULE - STOCK SUMMARY TABLE
-- ============================================================================

USE TextileERP;
GO

-- Stock Summary (Current Stock Levels)
CREATE TABLE inventory.StockSummary
(
    StockId             BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    ItemId              BIGINT NOT NULL,
    GodownId            BIGINT NOT NULL,
    LocationId          BIGINT NULL,
    BatchNumber         NVARCHAR(50) NULL,
    LotNumber           NVARCHAR(50) NULL,
    ColorCode           NVARCHAR(20) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    DesignCode          NVARCHAR(20) NULL,
    
    -- Quantity
    OpeningQuantity     DECIMAL(18,4) NOT NULL DEFAULT 0,
    InwardQuantity      DECIMAL(18,4) NOT NULL DEFAULT 0,
    OutwardQuantity     DECIMAL(18,4) NOT NULL DEFAULT 0,
    CurrentQuantity     DECIMAL(18,4) NOT NULL DEFAULT 0,
    ReservedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    AvailableQuantity   AS (CurrentQuantity - ReservedQuantity) PERSISTED,
    
    -- Value
    OpeningValue        DECIMAL(18,2) NOT NULL DEFAULT 0,
    InwardValue         DECIMAL(18,2) NOT NULL DEFAULT 0,
    OutwardValue        DECIMAL(18,2) NOT NULL DEFAULT 0,
    CurrentValue        DECIMAL(18,2) NOT NULL DEFAULT 0,
    AverageRate         AS (CASE WHEN CurrentQuantity > 0 THEN CurrentValue / CurrentQuantity ELSE 0 END) PERSISTED,
    
    -- Textile Specific
    RollCount           INT NOT NULL DEFAULT 0,
    BundleCount         INT NOT NULL DEFAULT 0,
    TotalMeters         DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalWeight         DECIMAL(18,2) NOT NULL DEFAULT 0,  -- in Kg
    
    -- Dates
    LastPurchaseDate    DATE NULL,
    LastSalesDate       DATE NULL,
    LastManufactureDate DATE NULL,
    LastMovementDate    DATE NULL,
    
    -- Status
    IsNegativeAllowed   BIT NOT NULL DEFAULT 0,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_StockSummary PRIMARY KEY CLUSTERED (StockId),
    CONSTRAINT UQ_StockSummary UNIQUE (CompanyId, ItemId, GodownId, BatchNumber, ColorCode, ShadeCode, DesignCode),
    CONSTRAINT FK_StockSummary_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_StockSummary_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_StockSummary_Godowns FOREIGN KEY (GodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_StockSummary_Locations FOREIGN KEY (LocationId) 
        REFERENCES master.GodownLocations(LocationId),
    CONSTRAINT CK_StockSummary_CurrentQuantity CHECK (CurrentQuantity >= 0 OR IsNegativeAllowed = 1)
);
GO

PRINT 'Table inventory.StockSummary created successfully.';
GO
