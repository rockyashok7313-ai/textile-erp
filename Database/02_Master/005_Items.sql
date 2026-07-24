-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - ITEMS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Items Table
CREATE TABLE master.Items
(
    ItemId              BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    ItemCode            NVARCHAR(30) NOT NULL,
    ItemName            NVARCHAR(200) NOT NULL,
    ItemDescription     NVARCHAR(1000) NULL,
    ShortName           NVARCHAR(100) NULL,
    Barcode             NVARCHAR(50) NULL,
    CategoryId          BIGINT NULL,
    SubCategoryId       BIGINT NULL,
    ItemGroupId         BIGINT NULL,
    
    -- HSN & GST
    HSNCode             NVARCHAR(10) NOT NULL,
    GSTGroupId          BIGINT NULL,
    GSTRate             DECIMAL(5,2) NOT NULL DEFAULT 0,
    CessRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    IsGSTApplicable     BIT NOT NULL DEFAULT 1,
    IsCessApplicable    BIT NOT NULL DEFAULT 0,
    
    -- Units
    BaseUnitId          BIGINT NOT NULL,
    PurchaseUnitId      BIGINT NULL,
    SalesUnitId         BIGINT NULL,
    ProductionUnitId    BIGINT NULL,
    UnitConversionFactor DECIMAL(18,6) NOT NULL DEFAULT 1,
    
    -- Pricing
    PurchaseRate        DECIMAL(18,4) NOT NULL DEFAULT 0,
    SalesRate           DECIMAL(18,4) NOT NULL DEFAULT 0,
    MRP                 DECIMAL(18,4) NOT NULL DEFAULT 0,
    WholesaleRate       DECIMAL(18,4) NOT NULL DEFAULT 0,
    RetailRate          DECIMAL(18,4) NOT NULL DEFAULT 0,
    JobWorkRate         DECIMAL(18,4) NOT NULL DEFAULT 0,
    CostingMethod       NVARCHAR(20) NOT NULL DEFAULT 'FIFO',  -- FIFO, LIFO, WeightedAverage, Standard
    
    -- Textile Specific Fields
    FabricType          NVARCHAR(50) NULL,  -- Woven, Knitted, Non-Woven
    FiberContent        NVARCHAR(200) NULL,  -- 100% Cotton, 80/20 Blend, etc.
    FiberComposition1   NVARCHAR(50) NULL,  -- Primary fiber
    FiberComposition2   NVARCHAR(50) NULL,  -- Secondary fiber
    GSM                 DECIMAL(8,2) NULL,  -- Grams per Square Meter
    Width               DECIMAL(8,2) NULL,  -- Width in cm or inches
    WidthUnit           NVARCHAR(10) NULL DEFAULT 'cm',  -- cm, inches
    LengthPerRoll       DECIMAL(10,2) NULL,  -- Meters per roll
    WeightPerRoll       DECIMAL(10,2) NULL,  -- Kg per roll
    RollsPerBundle      INT NULL DEFAULT 1,
    BundlesPerCarton    INT NULL DEFAULT 1,
    ColorCode           NVARCHAR(20) NULL,
    ColorName           NVARCHAR(50) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    DesignCode          NVARCHAR(20) NULL,
    DesignName          NVARCHAR(100) NULL,
    QualityGrade        NVARCHAR(10) NULL,  -- A, B, C, Premium
    ShrinkagePercent    DECIMAL(5,2) NULL DEFAULT 0,
    WastagePercent      DECIMAL(5,2) NULL DEFAULT 0,
    
    -- Inventory Settings
    IsBatchTracked      BIT NOT NULL DEFAULT 0,
    IsSerialTracked     BIT NOT NULL DEFAULT 0,
    IsExpiryTracked     BIT NOT NULL DEFAULT 0,
    IsNegativeStockAllowed BIT NOT NULL DEFAULT 0,
    IsMultiUnit         BIT NOT NULL DEFAULT 0,
    IsMultiGodown       BIT NOT NULL DEFAULT 0,
    
    -- Stock Levels
    MinimumStockLevel   DECIMAL(18,4) NOT NULL DEFAULT 0,
    MaximumStockLevel   DECIMAL(18,4) NOT NULL DEFAULT 0,
    ReorderLevel        DECIMAL(18,4) NOT NULL DEFAULT 0,
    ReorderQuantity     DECIMAL(18,4) NOT NULL DEFAULT 0,
    SafetyStock         DECIMAL(18,4) NOT NULL DEFAULT 0,
    LeadTimeDays        INT NOT NULL DEFAULT 0,
    
    -- Item Properties
    IsPurchaseItem      BIT NOT NULL DEFAULT 1,
    IsSalesItem         BIT NOT NULL DEFAULT 1,
    IsProductionItem    BIT NOT NULL DEFAULT 0,
    IsJobWorkItem       BIT NOT NULL DEFAULT 0,
    IsServiceItem       BIT NOT NULL DEFAULT 0,
    IsComponentItem     BIT NOT NULL DEFAULT 0,  -- Used in BOM
    IsRawMaterial       BIT NOT NULL DEFAULT 0,
    IsFinishedGood      BIT NOT NULL DEFAULT 0,
    IsSemiFinished      BIT NOT NULL DEFAULT 0,
    IsConsumable        BIT NOT NULL DEFAULT 0,
    IsCapitalGoods      BIT NOT NULL DEFAULT 0,
    
    -- E-way Bill & E-invoice
    IsEWayBillApplicable BIT NOT NULL DEFAULT 1,
    IsEInvoiceApplicable BIT NOT NULL DEFAULT 1,
    
    -- Images
    PrimaryImage        VARBINARY(MAX) NULL,
    PrimaryImagePath    NVARCHAR(500) NULL,
    
    -- Status
    IsActive            BIT NOT NULL DEFAULT 1,
    IsDiscontinued      BIT NOT NULL DEFAULT 0,
    DiscontinuedDate    DATETIME2 NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Items PRIMARY KEY CLUSTERED (ItemId),
    CONSTRAINT UQ_Items_CompanyItemCode UNIQUE (CompanyId, ItemCode),
    CONSTRAINT UQ_Items_CompanyBarcode UNIQUE (CompanyId, Barcode),
    CONSTRAINT FK_Items_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_Items_Categories FOREIGN KEY (CategoryId) 
        REFERENCES master.ItemCategories(CategoryId),
    CONSTRAINT FK_Items_SubCategories FOREIGN KEY (SubCategoryId) 
        REFERENCES master.ItemCategories(CategoryId),
    CONSTRAINT FK_Items_ItemGroups FOREIGN KEY (ItemGroupId) 
        REFERENCES master.ItemCategories(CategoryId),
    CONSTRAINT CK_Items_GSTRate CHECK (GSTRate >= 0 AND GSTRate <= 100),
    CONSTRAINT CK_Items_CessRate CHECK (CessRate >= 0 AND CessRate <= 100),
    CONSTRAINT CK_Items_CostingMethod CHECK (CostingMethod IN ('FIFO', 'LIFO', 'WeightedAverage', 'Standard')),
    CONSTRAINT CK_Items_WidthUnit CHECK (WidthUnit IN ('cm', 'inches')),
    CONSTRAINT CK_Items_QualityGrade CHECK (QualityGrade IN ('A', 'B', 'C', 'Premium', 'Standard', NULL))
);
GO

PRINT 'Table master.Items created successfully.';
GO
