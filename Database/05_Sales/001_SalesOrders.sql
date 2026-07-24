-- ============================================================================
-- TEXTILE ERP - SALES MODULE - SALES ORDERS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Sales Order Headers
CREATE TABLE sales.SalesOrders
(
    SalesOrderId        BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    OrderNumber         NVARCHAR(30) NOT NULL,
    OrderDate           DATE NOT NULL,
    ExpectedDate        DATE NULL,
    DeliveryDate        DATE NULL,
    OrderStatus         NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Confirmed, PartiallyDelivered, Delivered, Cancelled
    
    -- Customer
    CustomerId          BIGINT NOT NULL,
    CustomerGSTIN       NVARCHAR(15) NULL,
    CustomerStateCode   NVARCHAR(2) NULL,
    ContactPerson       NVARCHAR(100) NULL,
    ContactPhone        NVARCHAR(20) NULL,
    
    -- Address
    BillingAddress      NVARCHAR(500) NULL,
    ShippingAddress     NVARCHAR(500) NULL,
    ShippingAddressId   BIGINT NULL,
    
    -- Delivery
    DispatchGodownId    BIGINT NULL,
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
    CustomerPONumber    NVARCHAR(50) NULL,
    CustomerPODate      DATE NULL,
    ProjectCode         NVARCHAR(50) NULL,
    
    -- Terms
    PaymentTerms        NVARCHAR(200) NULL,
    DeliveryTerms       NVARCHAR(200) NULL,
    ShippingTerms       NVARCHAR(200) NULL,
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
    
    CONSTRAINT PK_SalesOrders PRIMARY KEY CLUSTERED (SalesOrderId),
    CONSTRAINT UQ_SalesOrders_CompanyOrderNumber UNIQUE (CompanyId, OrderNumber),
    CONSTRAINT FK_SalesOrders_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_SalesOrders_Customers FOREIGN KEY (CustomerId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_SalesOrders_DispatchGodown FOREIGN KEY (DispatchGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_SalesOrders_ShippingAddress FOREIGN KEY (ShippingAddressId) 
        REFERENCES master.PartyAddresses(AddressId),
    CONSTRAINT CK_SalesOrders_OrderStatus CHECK (OrderStatus IN ('Draft', 'Confirmed', 'PartiallyDelivered', 'Delivered', 'Cancelled'))
);
GO

-- Sales Order Details (Line Items)
CREATE TABLE sales.SalesOrderDetails
(
    SalesOrderDetailId  BIGINT IDENTITY(1,1) NOT NULL,
    SalesOrderId        BIGINT NOT NULL,
    LineNumber          INT NOT NULL,
    ItemId              BIGINT NOT NULL,
    ItemDescription     NVARCHAR(500) NULL,
    HSNCode             NVARCHAR(10) NOT NULL,
    
    -- Quantity
    OrderedQuantity     DECIMAL(18,4) NOT NULL,
    DeliveredQuantity   DECIMAL(18,4) NOT NULL DEFAULT 0,
    PendingQuantity     AS (OrderedQuantity - DeliveredQuantity) PERSISTED,
    UnitId              BIGINT NOT NULL,
    
    -- Rate
    Rate                DECIMAL(18,4) NOT NULL,
    DiscountPercent     DECIMAL(5,2) NOT NULL DEFAULT 0,
    DiscountAmount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    BasicAmount         DECIMAL(18,2) NOT NULL,
    
    -- Tax
    GSTRate             DECIMAL(5,2) NOT NULL DEFAULT 0,
    CGSTRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
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
    
    -- Total
    TaxableAmount       DECIMAL(18,2) NOT NULL,
    TotalAmount         DECIMAL(18,2) NOT NULL,
    
    -- Textile Specific
    ColorCode           NVARCHAR(20) NULL,
    ColorName           NVARCHAR(50) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    DesignCode          NVARCHAR(20) NULL,
    DesignName          NVARCHAR(100) NULL,
    Width               DECIMAL(8,2) NULL,
    GSM                 DECIMAL(8,2) NULL,
    QualityGrade        NVARCHAR(10) NULL,
    
    -- Remarks
    ItemRemarks         NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_SalesOrderDetails PRIMARY KEY CLUSTERED (SalesOrderDetailId),
    CONSTRAINT FK_SalesOrderDetails_SalesOrders FOREIGN KEY (SalesOrderId) 
        REFERENCES sales.SalesOrders(SalesOrderId),
    CONSTRAINT FK_SalesOrderDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_SalesOrderDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT CK_SalesOrderDetails_OrderedQuantity CHECK (OrderedQuantity > 0),
    CONSTRAINT CK_SalesOrderDetails_Rate CHECK (Rate >= 0)
);
GO

PRINT 'Tables sales.SalesOrders, sales.SalesOrderDetails created successfully.';
GO
