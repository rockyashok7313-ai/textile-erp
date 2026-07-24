-- ============================================================================
-- TEXTILE ERP - INVENTORY MODULE - BATCH STOCK TABLE
-- ============================================================================

USE TextileERP;
GO

-- Batch/Lot Stock Tracking
CREATE TABLE inventory.BatchStock
(
    BatchStockId        BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    ItemId              BIGINT NOT NULL,
    GodownId            BIGINT NOT NULL,
    BatchNumber         NVARCHAR(50) NOT NULL,
    LotNumber           NVARCHAR(50) NULL,
    BatchDate           DATE NULL,
    ExpiryDate          DATE NULL,
    
    -- Quantity
    Quantity            DECIMAL(18,4) NOT NULL DEFAULT 0,
    UnitId              BIGINT NOT NULL,
    
    -- Value
    Rate                DECIMAL(18,4) NOT NULL DEFAULT 0,
    Value               AS (Quantity * Rate) PERSISTED,
    
    -- Textile Specific
    ColorCode           NVARCHAR(20) NULL,
    ColorName           NVARCHAR(50) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    ShadeName           NVARCHAR(50) NULL,
    DesignCode          NVARCHAR(20) NULL,
    DesignName          NVARCHAR(100) NULL,
    QualityGrade        NVARCHAR(10) NULL,
    GSM                 DECIMAL(8,2) NULL,
    Width               DECIMAL(8,2) NULL,
    FiberContent        NVARCHAR(200) NULL,
    
    -- Roll/Batch Info
    RollCount           INT NULL DEFAULT 0,
    MetersPerRoll       DECIMAL(10,2) NULL,
    TotalMeters         DECIMAL(18,2) NULL DEFAULT 0,
    WeightPerRoll       DECIMAL(10,2) NULL,
    TotalWeight         DECIMAL(18,2) NULL DEFAULT 0,
    
    -- Dyeing Info (for dyed fabrics)
    DyeLotNumber        NVARCHAR(50) NULL,
    DyeDate             DATE NULL,
    ShrinkagePercent    DECIMAL(5,2) NULL DEFAULT 0,
    
    -- Status
    BatchStatus         NVARCHAR(20) NOT NULL DEFAULT 'Active',  -- Active, OnHold, Consumed, Expired
    QualityStatus       NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Approved, Rejected
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_BatchStock PRIMARY KEY CLUSTERED (BatchStockId),
    CONSTRAINT UQ_BatchStock_CompanyItemGodownBatch UNIQUE (CompanyId, ItemId, GodownId, BatchNumber),
    CONSTRAINT FK_BatchStock_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_BatchStock_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_BatchStock_Godowns FOREIGN KEY (GodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_BatchStock_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_BatchStock_Quantity CHECK (Quantity >= 0),
    CONSTRAINT CK_BatchStock_BatchStatus CHECK (BatchStatus IN ('Active', 'OnHold', 'Consumed', 'Expired')),
    CONSTRAINT CK_BatchStock_QualityStatus CHECK (QualityStatus IN ('Pending', 'Approved', 'Rejected'))
);
GO

PRINT 'Table inventory.BatchStock created successfully.';
GO
