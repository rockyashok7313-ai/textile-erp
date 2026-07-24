-- ============================================================================
-- TEXTILE ERP - INVENTORY MODULE - OPENING STOCK TABLE
-- ============================================================================

USE TextileERP;
GO

-- Opening Stock Entry
CREATE TABLE inventory.StockOpening
(
    OpeningId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    FinancialYear       NVARCHAR(10) NOT NULL,  -- e.g., '2025-26'
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
    UnitId              BIGINT NOT NULL,
    
    -- Value
    OpeningRate         DECIMAL(18,4) NOT NULL DEFAULT 0,
    OpeningValue        AS (OpeningQuantity * OpeningRate) PERSISTED,
    
    -- Textile Specific
    RollCount           INT NULL DEFAULT 0,
    BundleCount         INT NULL DEFAULT 0,
    TotalMeters         DECIMAL(18,2) NULL DEFAULT 0,
    TotalWeight         DECIMAL(18,2) NULL DEFAULT 0,
    
    -- Status
    IsVerified          BIT NOT NULL DEFAULT 0,
    VerifiedBy          BIGINT NULL,
    VerifiedDate        DATETIME2 NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_StockOpening PRIMARY KEY CLUSTERED (OpeningId),
    CONSTRAINT UQ_StockOpening UNIQUE (CompanyId, FinancialYear, ItemId, GodownId, BatchNumber, ColorCode),
    CONSTRAINT FK_StockOpening_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_StockOpening_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_StockOpening_Godowns FOREIGN KEY (GodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_StockOpening_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_StockOpening_OpeningQuantity CHECK (OpeningQuantity >= 0)
);
GO

PRINT 'Table inventory.StockOpening created successfully.';
GO
