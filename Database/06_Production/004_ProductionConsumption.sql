-- ============================================================================
-- TEXTILE ERP - PRODUCTION MODULE - PRODUCTION CONSUMPTION TABLE
-- ============================================================================

USE TextileERP;
GO

-- Production Material Consumption
CREATE TABLE production.ProductionConsumption
(
    ConsumptionId       BIGINT IDENTITY(1,1) NOT NULL,
    ProductionOrderId   BIGINT NOT NULL,
    ProductionStageId   BIGINT NULL,
    
    -- Material
    ItemId              BIGINT NOT NULL,
    ItemDescription     NVARCHAR(200) NULL,
    HSNCode             NVARCHAR(10) NULL,
    
    -- Quantity
    BOMQuantity         DECIMAL(18,4) NOT NULL DEFAULT 0,  -- As per BOM
    PlannedQuantity     DECIMAL(18,4) NOT NULL DEFAULT 0,  -- After wastage calculation
    ActualQuantity      DECIMAL(18,4) NOT NULL DEFAULT 0,  -- Actually consumed
    WastageQuantity     AS (ActualQuantity - BOMQuantity) PERSISTED,
    UnitId              BIGINT NOT NULL,
    
    -- Rate
    Rate                DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalAmount         AS (ActualQuantity * Rate) PERSISTED,
    
    -- Source
    GodownId            BIGINT NOT NULL,
    BatchNumber         NVARCHAR(50) NULL,
    ColorCode           NVARCHAR(20) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    
    -- Consumption Type
    ConsumptionType     NVARCHAR(20) NOT NULL DEFAULT 'Actual',  -- BOM, Actual, Return
    IsReturnable        BIT NOT NULL DEFAULT 0,
    ReturnQuantity      DECIMAL(18,4) NOT NULL DEFAULT 0,
    
    -- Status
    IsIssued            BIT NOT NULL DEFAULT 0,
    IssuedDate          DATE NULL,
    IssuedBy            BIGINT NULL,
    
    -- Remarks
    ConsumptionRemarks  NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_ProductionConsumption PRIMARY KEY CLUSTERED (ConsumptionId),
    CONSTRAINT FK_ProductionConsumption_ProductionOrders FOREIGN KEY (ProductionOrderId) 
        REFERENCES production.ProductionOrders(ProductionOrderId),
    CONSTRAINT FK_ProductionConsumption_ProductionStages FOREIGN KEY (ProductionStageId) 
        REFERENCES production.ProductionStages(ProductionStageId),
    CONSTRAINT FK_ProductionConsumption_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_ProductionConsumption_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_ProductionConsumption_Godowns FOREIGN KEY (GodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT CK_ProductionConsumption_ConsumptionType CHECK (ConsumptionType IN ('BOM', 'Actual', 'Return'))
);
GO

-- Production Output (Finished Goods)
CREATE TABLE production.ProductionOutput
(
    OutputId            BIGINT IDENTITY(1,1) NOT NULL,
    ProductionOrderId   BIGINT NOT NULL,
    ProductionStageId   BIGINT NULL,
    
    -- Product
    ItemId              BIGINT NOT NULL,
    ItemDescription     NVARCHAR(200) NULL,
    HSNCode             NVARCHAR(10) NULL,
    
    -- Quantity
    PlannedQuantity     DECIMAL(18,4) NOT NULL,
    ActualQuantity      DECIMAL(18,4) NOT NULL DEFAULT 0,
    RejectedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    AcceptedQuantity    AS (ActualQuantity - RejectedQuantity) PERSISTED,
    UnitId              BIGINT NOT NULL,
    
    -- Rate
    Rate                DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalAmount         AS (AcceptedQuantity * Rate) PERSISTED,
    
    -- Destination
    GodownId            BIGINT NOT NULL,
    LocationId          BIGINT NULL,
    BatchNumber         NVARCHAR(50) NULL,
    LotNumber           NVARCHAR(50) NULL,
    
    -- Textile Specific
    ColorCode           NVARCHAR(20) NULL,
    ColorName           NVARCHAR(50) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    DesignCode          NVARCHAR(20) NULL,
    QualityGrade        NVARCHAR(10) NULL,
    GSM                 DECIMAL(8,2) NULL,
    Width               DECIMAL(8,2) NULL,
    RollCount           INT NULL DEFAULT 0,
    MetersPerRoll       DECIMAL(10,2) NULL,
    TotalMeters         DECIMAL(18,2) NULL,
    
    -- Status
    IsReceived          BIT NOT NULL DEFAULT 0,
    ReceivedDate        DATE NULL,
    ReceivedBy          BIGINT NULL,
    QualityStatus       NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Approved, Rejected
    
    -- Remarks
    OutputRemarks       NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_ProductionOutput PRIMARY KEY CLUSTERED (OutputId),
    CONSTRAINT FK_ProductionOutput_ProductionOrders FOREIGN KEY (ProductionOrderId) 
        REFERENCES production.ProductionOrders(ProductionOrderId),
    CONSTRAINT FK_ProductionOutput_ProductionStages FOREIGN KEY (ProductionStageId) 
        REFERENCES production.ProductionStages(ProductionStageId),
    CONSTRAINT FK_ProductionOutput_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_ProductionOutput_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_ProductionOutput_Godowns FOREIGN KEY (GodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT CK_ProductionOutput_QualityStatus CHECK (QualityStatus IN ('Pending', 'Approved', 'Rejected'))
);
GO

PRINT 'Tables production.ProductionConsumption, production.ProductionOutput created successfully.';
GO
