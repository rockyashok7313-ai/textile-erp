-- ============================================================================
-- TEXTILE ERP - PRODUCTION MODULE - PRODUCTION STAGES TABLE
-- ============================================================================

USE TextileERP;
GO

-- Production Stage Master
CREATE TABLE production.ProductionStageMaster
(
    StageMasterId       BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    StageCode           NVARCHAR(20) NOT NULL,
    StageName           NVARCHAR(100) NOT NULL,
    StageDescription    NVARCHAR(500) NULL,
    StageSequence       INT NOT NULL,
    StageType           NVARCHAR(30) NOT NULL,  -- Weaving, Knitting, Dyeing, Printing, Finishing, Cutting, Stitching
    IsTextileSpecific   BIT NOT NULL DEFAULT 1,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_ProductionStageMaster PRIMARY KEY CLUSTERED (StageMasterId),
    CONSTRAINT UQ_ProductionStageMaster_CompanyStageCode UNIQUE (CompanyId, StageCode),
    CONSTRAINT FK_ProductionStageMaster_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_ProductionStageMaster_StageType CHECK (StageType IN ('Weaving', 'Knitting', 'Dyeing', 'Printing', 'Finishing', 'Cutting', 'Stitching', 'QualityCheck', 'Packaging'))
);
GO

-- Production Order Stages (Tracking)
CREATE TABLE production.ProductionStages
(
    ProductionStageId   BIGINT IDENTITY(1,1) NOT NULL,
    ProductionOrderId   BIGINT NOT NULL,
    StageMasterId       BIGINT NOT NULL,
    StageSequence       INT NOT NULL,
    StageStatus         NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, InProgress, Completed, Skipped
    
    -- Dates
    PlannedStartDate    DATE NULL,
    PlannedEndDate      DATE NULL,
    ActualStartDate     DATE NULL,
    ActualEndDate       DATE NULL,
    
    -- Quantity
    InputQuantity       DECIMAL(18,4) NOT NULL DEFAULT 0,
    OutputQuantity      DECIMAL(18,4) NOT NULL DEFAULT 0,
    RejectedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    UnitId              BIGINT NULL,
    
    -- Resource
    MachineId           BIGINT NULL,
    OperatorId          BIGINT NULL,
    ShiftId             INT NULL,
    
    -- Quality
    QualityStatus       NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Approved, Rejected
    QualityRemarks      NVARCHAR(500) NULL,
    
    -- Cost
    LabourCost          DECIMAL(18,2) NOT NULL DEFAULT 0,
    MachineCost         DECIMAL(18,2) NOT NULL DEFAULT 0,
    ChemicalCost        DECIMAL(18,2) NOT NULL DEFAULT 0,
    OtherCost           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalStageCost      AS (LabourCost + MachineCost + ChemicalCost + OtherCost) PERSISTED,
    
    -- Textile Specific
    ShrinkagePercent    DECIMAL(5,2) NULL DEFAULT 0,
    GSM                 DECIMAL(8,2) NULL,
    Width               DECIMAL(8,2) NULL,
    ColorFastness       NVARCHAR(20) NULL,
    
    -- Remarks
    StageRemarks        NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_ProductionStages PRIMARY KEY CLUSTERED (ProductionStageId),
    CONSTRAINT FK_ProductionStages_ProductionOrders FOREIGN KEY (ProductionOrderId) 
        REFERENCES production.ProductionOrders(ProductionOrderId),
    CONSTRAINT FK_ProductionStages_StageMaster FOREIGN KEY (StageMasterId) 
        REFERENCES production.ProductionStageMaster(StageMasterId),
    CONSTRAINT FK_ProductionStages_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_ProductionStages_StageStatus CHECK (StageStatus IN ('Pending', 'InProgress', 'Completed', 'Skipped')),
    CONSTRAINT CK_ProductionStages_QualityStatus CHECK (QualityStatus IN ('Pending', 'Approved', 'Rejected'))
);
GO

PRINT 'Tables production.ProductionStageMaster, production.ProductionStages created successfully.';
GO
