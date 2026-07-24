-- ============================================================================
-- TEXTILE ERP - INVENTORY MODULE - STOCK JOURNALS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Stock Journal Headers (Stock Transfer)
CREATE TABLE inventory.StockJournals
(
    JournalId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    JournalNumber       NVARCHAR(30) NOT NULL,
    JournalDate         DATE NOT NULL,
    JournalType         NVARCHAR(30) NOT NULL,  -- Transfer, Opening, Physical, Consumption, Production
    JournalStatus       NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Approved, Cancelled
    
    -- Source
    FromGodownId        BIGINT NULL,
    FromLocationId      BIGINT NULL,
    ToGodownId          BIGINT NULL,
    ToLocationId        BIGINT NULL,
    
    -- References
    ReferenceType       NVARCHAR(30) NULL,  -- Purchase, Sales, Production, Manual
    ReferenceId         BIGINT NULL,
    ReferenceNumber     NVARCHAR(30) NULL,
    
    -- Details
    Reason              NVARCHAR(500) NULL,
    Remarks             NVARCHAR(500) NULL,
    TotalQuantity       DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalValue          DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Approval
    ApprovedBy          BIGINT NULL,
    ApprovedDate        DATETIME2 NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    IsCancelled         BIT NOT NULL DEFAULT 0,
    CancelledBy         BIGINT NULL,
    CancelledDate       DATETIME2 NULL,
    CancelReason        NVARCHAR(500) NULL,
    
    CONSTRAINT PK_StockJournals PRIMARY KEY CLUSTERED (JournalId),
    CONSTRAINT UQ_StockJournals_CompanyJournalNumber UNIQUE (CompanyId, JournalNumber),
    CONSTRAINT FK_StockJournals_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_StockJournals_FromGodown FOREIGN KEY (FromGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_StockJournals_ToGodown FOREIGN KEY (ToGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT CK_StockJournals_JournalType CHECK (JournalType IN ('Transfer', 'Opening', 'Physical', 'Consumption', 'Production')),
    CONSTRAINT CK_StockJournals_JournalStatus CHECK (JournalStatus IN ('Draft', 'Approved', 'Cancelled'))
);
GO

-- Stock Journal Details (Line Items)
CREATE TABLE inventory.StockJournalDetails
(
    JournalDetailId     BIGINT IDENTITY(1,1) NOT NULL,
    JournalId           BIGINT NOT NULL,
    ItemId              BIGINT NOT NULL,
    BatchNumber         NVARCHAR(50) NULL,
    LotNumber           NVARCHAR(50) NULL,
    ColorCode           NVARCHAR(20) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    
    -- Source (From)
    FromGodownId        BIGINT NULL,
    FromLocationId      BIGINT NULL,
    FromBatchNumber     NVARCHAR(50) NULL,
    
    -- Destination (To)
    ToGodownId          BIGINT NULL,
    ToLocationId        BIGINT NULL,
    ToBatchNumber       NVARCHAR(50) NULL,
    
    -- Quantity
    Quantity            DECIMAL(18,4) NOT NULL,
    UnitId              BIGINT NOT NULL,
    UnitRate            DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalAmount         AS (Quantity * UnitRate) PERSISTED,
    
    -- Textile Specific
    RollCount           INT NULL DEFAULT 0,
    BundleCount         INT NULL DEFAULT 0,
    Meters              DECIMAL(18,2) NULL DEFAULT 0,
    Weight              DECIMAL(18,2) NULL DEFAULT 0,
    
    -- Remarks
    ItemRemarks         NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_StockJournalDetails PRIMARY KEY CLUSTERED (JournalDetailId),
    CONSTRAINT FK_StockJournalDetails_StockJournals FOREIGN KEY (JournalId) 
        REFERENCES inventory.StockJournals(JournalId),
    CONSTRAINT FK_StockJournalDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_StockJournalDetails_FromGodown FOREIGN KEY (FromGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_StockJournalDetails_ToGodown FOREIGN KEY (ToGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_StockJournalDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_StockJournalDetails_Quantity CHECK (Quantity > 0)
);
GO

PRINT 'Tables inventory.StockJournals, inventory.StockJournalDetails created successfully.';
GO
