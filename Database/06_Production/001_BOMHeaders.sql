-- ============================================================================
-- TEXTILE ERP - PRODUCTION MODULE - BILL OF MATERIALS (BOM) TABLE
-- ============================================================================

USE TextileERP;
GO

-- BOM Headers
CREATE TABLE production.BOMHeaders
(
    BOMId               BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    BOMCode             NVARCHAR(30) NOT NULL,
    BOMName             NVARCHAR(200) NOT NULL,
    BOMDescription      NVARCHAR(500) NULL,
    BOMVersion          NVARCHAR(10) NOT NULL DEFAULT '1.0',
    BOMType             NVARCHAR(20) NOT NULL DEFAULT 'Production',  -- Production, Assembly, Process
    
    -- Product
    FinishedItemId      BIGINT NOT NULL,
    FinishedItemName    NVARCHAR(200) NULL,
    Quantity            DECIMAL(18,4) NOT NULL DEFAULT 1,
    UnitId              BIGINT NOT NULL,
    
    -- Production Details
    ProductionStage     NVARCHAR(50) NULL,  -- Weaving, Dyeing, Finishing, Cutting, Stitching
    EstimatedTime       DECIMAL(10,2) NULL,  -- in hours
    EstimatedCost       DECIMAL(18,2) NULL DEFAULT 0,
    WastagePercent      DECIMAL(5,2) NULL DEFAULT 0,
    
    -- Status
    IsDefault           BIT NOT NULL DEFAULT 0,
    IsActive            BIT NOT NULL DEFAULT 1,
    IsApproved          BIT NOT NULL DEFAULT 0,
    ApprovedBy          BIGINT NULL,
    ApprovedDate        DATETIME2 NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_BOMHeaders PRIMARY KEY CLUSTERED (BOMId),
    CONSTRAINT UQ_BOMHeaders_CompanyBOMCode UNIQUE (CompanyId, BOMCode),
    CONSTRAINT FK_BOMHeaders_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_BOMHeaders_FinishedItem FOREIGN KEY (FinishedItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_BOMHeaders_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_BOMHeaders_BOMType CHECK (BOMType IN ('Production', 'Assembly', 'Process'))
);
GO

-- BOM Details (Raw Materials / Components)
CREATE TABLE production.BOMDetails
(
    BOMDetailId         BIGINT IDENTITY(1,1) NOT NULL,
    BOMId               BIGINT NOT NULL,
    LineNumber          INT NOT NULL,
    ItemId              BIGINT NOT NULL,
    ItemDescription     NVARCHAR(200) NULL,
    HSNCode             NVARCHAR(10) NULL,
    
    -- Quantity
    Quantity            DECIMAL(18,4) NOT NULL,
    UnitId              BIGINT NOT NULL,
    
    -- Rate
    Rate                DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalAmount         AS (Quantity * Rate) PERSISTED,
    
    -- Production
    StageName           NVARCHAR(50) NULL,  -- Which stage this material is used
    ConsumptionType     NVARCHAR(20) NOT NULL DEFAULT 'Fixed',  -- Fixed, Variable
    WastagePercent      DECIMAL(5,2) NULL DEFAULT 0,
    IsOptional          BIT NOT NULL DEFAULT 0,
    
    -- Textile Specific
    ColorCode           NVARCHAR(20) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    GSM                 DECIMAL(8,2) NULL,
    
    -- Remarks
    ItemRemarks         NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_BOMDetails PRIMARY KEY CLUSTERED (BOMDetailId),
    CONSTRAINT FK_BOMDetails_BOMHeaders FOREIGN KEY (BOMId) 
        REFERENCES production.BOMHeaders(BOMId),
    CONSTRAINT FK_BOMDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_BOMDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_BOMDetails_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_BOMDetails_ConsumptionType CHECK (ConsumptionType IN ('Fixed', 'Variable'))
);
GO

PRINT 'Tables production.BOMHeaders, production.BOMDetails created successfully.';
GO
