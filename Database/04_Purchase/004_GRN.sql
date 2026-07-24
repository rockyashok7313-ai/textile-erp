-- ============================================================================
-- TEXTILE ERP - PURCHASE MODULE - GRN (GOODS RECEIPT NOTE) TABLE
-- ============================================================================

USE TextileERP;
GO

-- GRN Headers
CREATE TABLE purchase.GRN
(
    GRNId               BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    GRNNumber           NVARCHAR(30) NOT NULL,
    GRNDate             DATE NOT NULL,
    GRNTime             TIME NULL,
    GRNStatus           NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Received, Inspected, Accepted, Rejected, PartiallyAccepted
    
    -- Supplier
    SupplierId          BIGINT NOT NULL,
    SupplierGSTIN       NVARCHAR(15) NULL,
    
    -- Reference
    PurchaseOrderId     BIGINT NULL,
    PurchaseInvoiceId   BIGINT NULL,
    
    -- Delivery
    DeliveryChallanNumber NVARCHAR(50) NULL,
    DeliveryChallanDate DATE NULL,
    VehicleNumber       NVARCHAR(20) NULL,
    TransporterName     NVARCHAR(200) NULL,
    DriverName          NVARCHAR(100) NULL,
    DriverMobile        NVARCHAR(20) NULL,
    
    -- Godown
    ReceivedGodownId    BIGINT NOT NULL,
    ReceivedBy          BIGINT NULL,
    
    -- Quantity
    TotalItems          INT NOT NULL DEFAULT 0,
    TotalQuantity       DECIMAL(18,4) NOT NULL DEFAULT 0,
    AcceptedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    RejectedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    PendingQuantity     AS (TotalQuantity - AcceptedQuantity - RejectedQuantity) PERSISTED,
    
    -- Weight
    TotalGrossWeight    DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalTareWeight     DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalNetWeight      AS (TotalGrossWeight - TotalTareWeight) PERSISTED,
    
    -- Textile Specific
    TotalRolls          INT NOT NULL DEFAULT 0,
    TotalBundles        INT NOT NULL DEFAULT 0,
    TotalMeters         DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Inspection
    InspectionRequired  BIT NOT NULL DEFAULT 1,
    InspectionBy        BIGINT NULL,
    InspectionDate      DATETIME2 NULL,
    InspectionRemarks   NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    IsCancelled         BIT NOT NULL DEFAULT 0,
    CancelledBy         BIGINT NULL,
    CancelledDate       DATETIME2 NULL,
    
    CONSTRAINT PK_GRN PRIMARY KEY CLUSTERED (GRNId),
    CONSTRAINT UQ_GRN_CompanyGRNNumber UNIQUE (CompanyId, GRNNumber),
    CONSTRAINT FK_GRN_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_GRN_Suppliers FOREIGN KEY (SupplierId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_GRN_PurchaseOrders FOREIGN KEY (PurchaseOrderId) 
        REFERENCES purchase.PurchaseOrders(PurchaseOrderId),
    CONSTRAINT FK_GRN_PurchaseInvoices FOREIGN KEY (PurchaseInvoiceId) 
        REFERENCES purchase.PurchaseInvoices(PurchaseInvoiceId),
    CONSTRAINT FK_GRN_ReceivedGodown FOREIGN KEY (ReceivedGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT CK_GRN_GRNStatus CHECK (GRNStatus IN ('Draft', 'Received', 'Inspected', 'Accepted', 'Rejected', 'PartiallyAccepted'))
);
GO

-- GRN Details
CREATE TABLE purchase.GRNDetails
(
    GRNDetailId         BIGINT IDENTITY(1,1) NOT NULL,
    GRNId               BIGINT NOT NULL,
    LineNumber          INT NOT NULL,
    ItemId              BIGINT NOT NULL,
    PurchaseOrderId     BIGINT NULL,
    PurchaseOrderDetailId BIGINT NULL,
    
    -- Quantity
    OrderedQuantity     DECIMAL(18,4) NULL,
    ReceivedQuantity    DECIMAL(18,4) NOT NULL,
    AcceptedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    RejectedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    UnitId              BIGINT NOT NULL,
    
    -- Batch
    BatchNumber         NVARCHAR(50) NULL,
    LotNumber           NVARCHAR(50) NULL,
    
    -- Textile Specific
    ColorCode           NVARCHAR(20) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    DesignCode          NVARCHAR(20) NULL,
    RollCount           INT NULL DEFAULT 0,
    MetersPerRoll       DECIMAL(10,2) NULL,
    TotalMeters         DECIMAL(18,2) NULL,
    GrossWeight         DECIMAL(18,4) NULL,
    TareWeight          DECIMAL(18,4) NULL,
    NetWeight           AS (ISNULL(GrossWeight, 0) - ISNULL(TareWeight, 0)) PERSISTED,
    Width               DECIMAL(8,2) NULL,
    GSM                 DECIMAL(8,2) NULL,
    QualityGrade        NVARCHAR(10) NULL,
    
    -- Quality Check
    QualityStatus       NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Accepted, Rejected, Hold
    QualityRemarks      NVARCHAR(500) NULL,
    InspectedBy         BIGINT NULL,
    InspectedDate       DATETIME2 NULL,
    
    -- Remarks
    ItemRemarks         NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_GRNDetails PRIMARY KEY CLUSTERED (GRNDetailId),
    CONSTRAINT FK_GRNDetails_GRN FOREIGN KEY (GRNId) 
        REFERENCES purchase.GRN(GRNId),
    CONSTRAINT FK_GRNDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_GRNDetails_PurchaseOrders FOREIGN KEY (PurchaseOrderId) 
        REFERENCES purchase.PurchaseOrders(PurchaseOrderId),
    CONSTRAINT FK_GRNDetails_PurchaseOrderDetails FOREIGN KEY (PurchaseOrderDetailId) 
        REFERENCES purchase.PurchaseOrderDetails(PurchaseOrderDetailId),
    CONSTRAINT FK_GRNDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_GRNDetails_ReceivedQuantity CHECK (ReceivedQuantity > 0),
    CONSTRAINT CK_GRNDetails_QualityStatus CHECK (QualityStatus IN ('Pending', 'Accepted', 'Rejected', 'Hold'))
);
GO

PRINT 'Tables purchase.GRN, purchase.GRNDetails created successfully.';
GO
