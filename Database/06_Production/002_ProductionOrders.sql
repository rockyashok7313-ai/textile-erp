-- ============================================================================
-- TEXTILE ERP - PRODUCTION MODULE - PRODUCTION ORDERS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Production Order Headers
CREATE TABLE production.ProductionOrders
(
    ProductionOrderId   BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    OrderNumber         NVARCHAR(30) NOT NULL,
    OrderDate           DATE NOT NULL,
    RequiredDate        DATE NULL,
    ExpectedCompletionDate DATE NULL,
    ActualCompletionDate DATE NULL,
    OrderStatus         NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Planned, InProgress, Completed, Cancelled
    
    -- Product
    BOMId               BIGINT NULL,
    FinishedItemId      BIGINT NOT NULL,
    FinishedItemName    NVARCHAR(200) NULL,
    PlannedQuantity     DECIMAL(18,4) NOT NULL,
    ProducedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    RejectedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    ScrapQuantity       DECIMAL(18,4) NOT NULL DEFAULT 0,
    UnitId              BIGINT NOT NULL,
    
    -- Production Details
    ProductionType      NVARCHAR(20) NOT NULL DEFAULT 'InHouse',  -- InHouse, JobWork
    ProductionStage     NVARCHAR(50) NULL,
    GodownId            BIGINT NULL,
    
    -- Reference
    SalesOrderId        BIGINT NULL,
    CustomerId          BIGINT NULL,
    
    -- Job Work
    JobWorkPartyId      BIGINT NULL,
    JobWorkRate         DECIMAL(18,4) NULL DEFAULT 0,
    
    -- Priority
    Priority            NVARCHAR(10) NOT NULL DEFAULT 'Normal',  -- Low, Normal, High, Urgent
    
    -- Cost
    EstimatedCost       DECIMAL(18,2) NOT NULL DEFAULT 0,
    ActualCost          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CostVariance        AS (ActualCost - EstimatedCost) PERSISTED,
    
    -- Remarks
    Remarks             NVARCHAR(500) NULL,
    InternalRemarks     NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    IsCancelled         BIT NOT NULL DEFAULT 0,
    CancelledBy         BIGINT NULL,
    CancelledDate       DATETIME2 NULL,
    CancelReason        NVARCHAR(500) NULL,
    
    CONSTRAINT PK_ProductionOrders PRIMARY KEY CLUSTERED (ProductionOrderId),
    CONSTRAINT UQ_ProductionOrders_CompanyOrderNumber UNIQUE (CompanyId, OrderNumber),
    CONSTRAINT FK_ProductionOrders_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_ProductionOrders_BOMHeaders FOREIGN KEY (BOMId) 
        REFERENCES production.BOMHeaders(BOMId),
    CONSTRAINT FK_ProductionOrders_FinishedItem FOREIGN KEY (FinishedItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_ProductionOrders_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_ProductionOrders_Godowns FOREIGN KEY (GodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_ProductionOrders_SalesOrders FOREIGN KEY (SalesOrderId) 
        REFERENCES sales.SalesOrders(SalesOrderId),
    CONSTRAINT FK_ProductionOrders_Customers FOREIGN KEY (CustomerId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_ProductionOrders_JobWorkParty FOREIGN KEY (JobWorkPartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT CK_ProductionOrders_OrderStatus CHECK (OrderStatus IN ('Draft', 'Planned', 'InProgress', 'Completed', 'Cancelled')),
    CONSTRAINT CK_ProductionOrders_ProductionType CHECK (ProductionType IN ('InHouse', 'JobWork')),
    CONSTRAINT CK_ProductionOrders_Priority CHECK (Priority IN ('Low', 'Normal', 'High', 'Urgent'))
);
GO

PRINT 'Table production.ProductionOrders created successfully.';
GO
