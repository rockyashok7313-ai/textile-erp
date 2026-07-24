-- ============================================================================
-- TEXTILE ERP - PURCHASE MODULE - PURCHASE ORDERS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Purchase Order Headers
CREATE TABLE purchase.PurchaseOrders
(
    PurchaseOrderId     BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    OrderNumber         NVARCHAR(30) NOT NULL,
    OrderDate           DATE NOT NULL,
    ExpectedDate        DATE NULL,
    DeliveryDate        DATE NULL,
    OrderStatus         NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Confirmed, PartiallyReceived, Received, Cancelled
    
    -- Party
    SupplierId          BIGINT NOT NULL,
    SupplierGSTIN       NVARCHAR(15) NULL,
    SupplierStateCode   NVARCHAR(2) NULL,
    ContactPerson       NVARCHAR(100) NULL,
    ContactPhone        NVARCHAR(20) NULL,
    
    -- Address
    BillingAddress      NVARCHAR(500) NULL,
    ShippingAddress     NVARCHAR(500) NULL,
    
    -- Delivery
    DeliveryGodownId    BIGINT NULL,
    ExpectedDeliveryDate DATE NULL,
    
    -- Tax
    IsInterState        BIT NOT NULL DEFAULT 0,
    PlaceOfSupply       NVARCHAR(50) NULL,
    PlaceOfSupplyStateCode NVARCHAR(2) NULL,
    
    -- Amount
    TotalQuantity       DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalAmount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalDiscount       DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalTaxableAmount  DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalSGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalIGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCess           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalTDS            DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalTCS            DECIMAL(18,2) NOT NULL DEFAULT 0,
    GrossAmount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    RoundOff            DECIMAL(18,2) NOT NULL DEFAULT 0,
    NetAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Currency
    CurrencyCode        NVARCHAR(3) NOT NULL DEFAULT 'INR',
    ExchangeRate        DECIMAL(10,4) NOT NULL DEFAULT 1,
    
    -- References
    ReferenceNumber     NVARCHAR(50) NULL,
    ProjectCode         NVARCHAR(50) NULL,
    
    -- Terms
    PaymentTerms        NVARCHAR(200) NULL,
    DeliveryTerms       NVARCHAR(200) NULL,
    Remarks             NVARCHAR(500) NULL,
    InternalRemarks     NVARCHAR(500) NULL,
    
    -- Approval
    ApprovedBy          BIGINT NULL,
    ApprovedDate        DATETIME2 NULL,
    ApprovalRemarks     NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    IsCancelled         BIT NOT NULL DEFAULT 0,
    CancelledBy         BIGINT NULL,
    CancelledDate       DATETIME2 NULL,
    CancelReason        NVARCHAR(500) NULL,
    
    CONSTRAINT PK_PurchaseOrders PRIMARY KEY CLUSTERED (PurchaseOrderId),
    CONSTRAINT UQ_PurchaseOrders_CompanyOrderNumber UNIQUE (CompanyId, OrderNumber),
    CONSTRAINT FK_PurchaseOrders_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_PurchaseOrders_Suppliers FOREIGN KEY (SupplierId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_PurchaseOrders_DeliveryGodown FOREIGN KEY (DeliveryGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT CK_PurchaseOrders_OrderStatus CHECK (OrderStatus IN ('Draft', 'Confirmed', 'PartiallyReceived', 'Received', 'Cancelled'))
);
GO

-- Purchase Order Details (Line Items)
CREATE TABLE purchase.PurchaseOrderDetails
(
    PurchaseOrderDetailId BIGINT IDENTITY(1,1) NOT NULL,
    PurchaseOrderId     BIGINT NOT NULL,
    LineNumber          INT NOT NULL,
    ItemId              BIGINT NOT NULL,
    ItemDescription     NVARCHAR(500) NULL,
    HSNCode             NVARCHAR(10) NOT NULL,
    
    -- Quantity
    OrderedQuantity     DECIMAL(18,4) NOT NULL,
    ReceivedQuantity    DECIMAL(18,4) NOT NULL DEFAULT 0,
    PendingQuantity     AS (OrderedQuantity - ReceivedQuantity) PERSISTED,
    UnitId              BIGINT NOT NULL,
    
    -- Rate
    Rate                DECIMAL(18,4) NOT NULL,
    DiscountPercent     DECIMAL(5,2) NOT NULL DEFAULT 0,
    DiscountAmount      AS (Rate * OrderedQuantity * DiscountPercent / 100) PERSISTED,
    BasicAmount         AS (Rate * OrderedQuantity * (1 - DiscountPercent / 100)) PERSISTED,
    
    -- Tax
    GSTRate             DECIMAL(5,2) NOT NULL DEFAULT 0,
    CGSTRate            AS (GSTRate / 2) PERSISTED,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTRate            AS (GSTRate / 2) PERSISTED,
    SGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGSTRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    IGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    CessAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- TDS/TCS
    TDSApplicable       BIT NOT NULL DEFAULT 0,
    TDSRate             DECIMAL(5,2) NOT NULL DEFAULT 0,
    TDSAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TCSApplicable       BIT NOT NULL DEFAULT 0,
    TCSRate             DECIMAL(5,2) NOT NULL DEFAULT 0,
    TCSAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Textile Specific
    ColorCode           NVARCHAR(20) NULL,
    ColorName           NVARCHAR(50) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    DesignCode          NVARCHAR(20) NULL,
    Width               DECIMAL(8,2) NULL,
    GSM                 DECIMAL(8,2) NULL,
    QualityGrade        NVARCHAR(10) NULL,
    
    -- Taxable Amount
    TaxableAmount       AS (BasicAmount + CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + TCSAmount - TDSAmount) PERSISTED,
    TotalAmount         AS (BasicAmount + CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + TCSAmount - TDSAmount) PERSISTED,
    
    -- Remarks
    ItemRemarks         NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_PurchaseOrderDetails PRIMARY KEY CLUSTERED (PurchaseOrderDetailId),
    CONSTRAINT FK_PurchaseOrderDetails_PurchaseOrders FOREIGN KEY (PurchaseOrderId) 
        REFERENCES purchase.PurchaseOrders(PurchaseOrderId),
    CONSTRAINT FK_PurchaseOrderDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_PurchaseOrderDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_PurchaseOrderDetails_OrderedQuantity CHECK (OrderedQuantity > 0),
    CONSTRAINT CK_PurchaseOrderDetails_Rate CHECK (Rate >= 0)
);
GO

PRINT 'Tables purchase.PurchaseOrders, purchase.PurchaseOrderDetails created successfully.';
GO
