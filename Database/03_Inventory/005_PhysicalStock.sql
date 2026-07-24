-- ============================================================================
-- TEXTILE ERP - INVENTORY MODULE - PHYSICAL STOCK VERIFICATION TABLE
-- ============================================================================

USE TextileERP;
GO

-- Physical Stock Verification Header
CREATE TABLE inventory.PhysicalStock
(
    PhysicalStockId     BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    VerificationNumber  NVARCHAR(30) NOT NULL,
    VerificationDate    DATE NOT NULL,
    VerificationType    NVARCHAR(20) NOT NULL DEFAULT 'Full',  -- Full, Partial, Cycle
    GodownId            BIGINT NULL,  -- NULL for all godowns
    
    -- Status
    Status              NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, InProgress, Completed, Cancelled
    
    -- Summary
    TotalItems          INT NOT NULL DEFAULT 0,
    MatchedItems        INT NOT NULL DEFAULT 0,
    ExcessItems         INT NOT NULL DEFAULT 0,
    ShortItems          INT NOT NULL DEFAULT 0,
    TotalExcessValue    DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalShortValue     DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Approval
    PreparedBy          BIGINT NULL,
    PreparedDate        DATETIME2 NULL,
    VerifiedBy          BIGINT NULL,
    VerifiedDate        DATETIME2 NULL,
    ApprovedBy          BIGINT NULL,
    ApprovedDate        DATETIME2 NULL,
    
    -- Remarks
    Remarks             NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    IsCancelled         BIT NOT NULL DEFAULT 0,
    CancelledBy         BIGINT NULL,
    CancelledDate       DATETIME2 NULL,
    
    CONSTRAINT PK_PhysicalStock PRIMARY KEY CLUSTERED (PhysicalStockId),
    CONSTRAINT UQ_PhysicalStock_CompanyVerificationNumber UNIQUE (CompanyId, VerificationNumber),
    CONSTRAINT FK_PhysicalStock_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_PhysicalStock_Godowns FOREIGN KEY (GodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT CK_PhysicalStock_VerificationType CHECK (VerificationType IN ('Full', 'Partial', 'Cycle')),
    CONSTRAINT CK_PhysicalStock_Status CHECK (Status IN ('Draft', 'InProgress', 'Completed', 'Cancelled'))
);
GO

-- Physical Stock Verification Details
CREATE TABLE inventory.PhysicalStockDetails
(
    PhysicalStockDetailId BIGINT IDENTITY(1,1) NOT NULL,
    PhysicalStockId     BIGINT NOT NULL,
    ItemId              BIGINT NOT NULL,
    GodownId            BIGINT NOT NULL,
    LocationId          BIGINT NULL,
    BatchNumber         NVARCHAR(50) NULL,
    ColorCode           NVARCHAR(20) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    
    -- Book (System) Quantity
    BookQuantity        DECIMAL(18,4) NOT NULL DEFAULT 0,
    BookValue           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Physical (Counted) Quantity
    PhysicalQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    PhysicalValue       DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Variance
    VarianceQuantity    AS (PhysicalQuantity - BookQuantity) PERSISTED,
    VarianceValue       AS (PhysicalValue - BookValue) PERSISTED,
    VariancePercent     AS (CASE WHEN BookQuantity > 0 
                              THEN ((PhysicalQuantity - BookQuantity) / BookQuantity) * 100 
                              ELSE 0 END) PERSISTED,
    
    -- Variance Type
    VarianceType        AS (CASE 
                              WHEN PhysicalQuantity > BookQuantity THEN 'Excess'
                              WHEN PhysicalQuantity < BookQuantity THEN 'Short'
                              ELSE 'Match'
                           END) PERSISTED,
    
    -- Unit
    UnitId              BIGINT NOT NULL,
    
    -- Textile Specific
    RollCount           INT NULL,
    Meters              DECIMAL(18,2) NULL,
    Weight              DECIMAL(18,2) NULL,
    
    -- Counted By
    CountedBy           BIGINT NULL,
    CountedDate         DATETIME2 NULL,
    Remarks             NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_PhysicalStockDetails PRIMARY KEY CLUSTERED (PhysicalStockDetailId),
    CONSTRAINT FK_PhysicalStockDetails_PhysicalStock FOREIGN KEY (PhysicalStockId) 
        REFERENCES inventory.PhysicalStock(PhysicalStockId),
    CONSTRAINT FK_PhysicalStockDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_PhysicalStockDetails_Godowns FOREIGN KEY (GodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_PhysicalStockDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_PhysicalStockDetails_PhysicalQuantity CHECK (PhysicalQuantity >= 0)
);
GO

PRINT 'Tables inventory.PhysicalStock, inventory.PhysicalStockDetails created successfully.';
GO
