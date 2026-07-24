-- ============================================================================
-- TEXTILE ERP - PRODUCTION MODULE - JOB WORK TABLE
-- ============================================================================

USE TextileERP;
GO

-- Job Work Headers
CREATE TABLE production.JobWork
(
    JobWorkId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    JobWorkNumber       NVARCHAR(30) NOT NULL,
    JobWorkDate         DATE NOT NULL,
    ExpectedDate        DATE NULL,
    ActualDate          DATE NULL,
    JobWorkStatus       NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Sent, InProgress, Received, Completed, Cancelled
    JobWorkType         NVARCHAR(20) NOT NULL DEFAULT 'Outward',  -- Outward, Inward
    
    -- Party
    JobWorkPartyId      BIGINT NOT NULL,
    PartyGSTIN          NVARCHAR(15) NULL,
    PartyStateCode      NVARCHAR(2) NULL,
    
    -- Process
    ProcessName         NVARCHAR(100) NOT NULL,  -- Dyeing, Printing, Finishing, etc.
    ProcessDescription  NVARCHAR(500) NULL,
    
    -- Reference
    ProductionOrderId   BIGINT NULL,
    SalesOrderId        BIGINT NULL,
    
    -- Item Sent
    SentItemId          BIGINT NOT NULL,
    SentQuantity        DECIMAL(18,4) NOT NULL,
    SentUnitId          BIGINT NOT NULL,
    
    -- Item Received
    ReceivedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    RejectedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    PendingQuantity     AS (SentQuantity - ReceivedQuantity - RejectedQuantity) PERSISTED,
    
    -- Rate
    JobWorkRate         DECIMAL(18,4) NOT NULL DEFAULT 0,
    JobWorkAmount       AS (ReceivedQuantity * JobWorkRate) PERSISTED,
    
    -- GST on Job Work
    GSTRate             DECIMAL(5,2) NOT NULL DEFAULT 0,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalAmount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Transport
    DeliveryChallanNumber NVARCHAR(30) NULL,
    VehicleNumber       NVARCHAR(20) NULL,
    EWayBillNumber      NVARCHAR(50) NULL,
    
    -- Godown
    SentGodownId        BIGINT NULL,
    ReceivedGodownId    BIGINT NULL,
    
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
    
    CONSTRAINT PK_JobWork PRIMARY KEY CLUSTERED (JobWorkId),
    CONSTRAINT UQ_JobWork_CompanyJobWorkNumber UNIQUE (CompanyId, JobWorkNumber),
    CONSTRAINT FK_JobWork_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_JobWork_JobWorkParty FOREIGN KEY (JobWorkPartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_JobWork_SentItem FOREIGN KEY (SentItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_JobWork_SentUnit FOREIGN KEY (SentUnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_JobWork_ProductionOrders FOREIGN KEY (ProductionOrderId) 
        REFERENCES production.ProductionOrders(ProductionOrderId),
    CONSTRAINT FK_JobWork_SalesOrders FOREIGN KEY (SalesOrderId) 
        REFERENCES sales.SalesOrders(SalesOrderId),
    CONSTRAINT FK_JobWork_SentGodown FOREIGN KEY (SentGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_JobWork_ReceivedGodown FOREIGN KEY (ReceivedGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT CK_JobWork_JobWorkStatus CHECK (JobWorkStatus IN ('Draft', 'Sent', 'InProgress', 'Received', 'Completed', 'Cancelled')),
    CONSTRAINT CK_JobWork_JobWorkType CHECK (JobWorkType IN ('Outward', 'Inward'))
);
GO

PRINT 'Table production.JobWork created successfully.';
GO
