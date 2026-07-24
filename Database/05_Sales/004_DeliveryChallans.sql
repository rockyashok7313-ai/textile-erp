-- ============================================================================
-- TEXTILE ERP - SALES MODULE - DELIVERY CHALLANS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Delivery Challan Headers
CREATE TABLE sales.DeliveryChallans
(
    DeliveryChallanId   BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    ChallanNumber       NVARCHAR(30) NOT NULL,
    ChallanDate         DATE NOT NULL,
    ChallanType         NVARCHAR(20) NOT NULL DEFAULT 'Outward',  -- Outward, Inward, JobWork
    ChallanStatus       NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Dispatched, Received, Cancelled
    
    -- Customer
    CustomerId          BIGINT NOT NULL,
    CustomerGSTIN       NVARCHAR(15) NULL,
    CustomerStateCode   NVARCHAR(2) NULL,
    ContactPerson       NVARCHAR(100) NULL,
    
    -- Address
    BillingAddress      NVARCHAR(500) NULL,
    ShippingAddress     NVARCHAR(500) NULL,
    
    -- Delivery
    DispatchGodownId    BIGINT NULL,
    DispatchDate        DATE NULL,
    ExpectedReturnDate  DATE NULL,
    ActualReturnDate    DATE NULL,
    
    -- Transport
    VehicleNumber       NVARCHAR(20) NULL,
    TransporterName     NVARCHAR(200) NULL,
    TransporterId       BIGINT NULL,
    DriverName          NVARCHAR(100) NULL,
    DriverMobile        NVARCHAR(20) NULL,
    
    -- Reference
    SalesOrderId        BIGINT NULL,
    SalesInvoiceId      BIGINT NULL,
    
    -- E-way Bill
    EWayBillNumber      NVARCHAR(50) NULL,
    EWayBillDate        DATETIME2 NULL,
    IsEWayBillRequired  BIT NOT NULL DEFAULT 0,
    
    -- Amount
    TotalQuantity       DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalAmount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    
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
    
    CONSTRAINT PK_DeliveryChallans PRIMARY KEY CLUSTERED (DeliveryChallanId),
    CONSTRAINT UQ_DeliveryChallans_CompanyChallanNumber UNIQUE (CompanyId, ChallanNumber),
    CONSTRAINT FK_DeliveryChallans_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_DeliveryChallans_Customers FOREIGN KEY (CustomerId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_DeliveryChallans_DispatchGodown FOREIGN KEY (DispatchGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_DeliveryChallans_Transporters FOREIGN KEY (TransporterId) 
        REFERENCES master.Transporters(TransporterId),
    CONSTRAINT FK_DeliveryChallans_SalesOrders FOREIGN KEY (SalesOrderId) 
        REFERENCES sales.SalesOrders(SalesOrderId),
    CONSTRAINT FK_DeliveryChallans_SalesInvoices FOREIGN KEY (SalesInvoiceId) 
        REFERENCES sales.SalesInvoices(SalesInvoiceId),
    CONSTRAINT CK_DeliveryChallans_ChallanType CHECK (ChallanType IN ('Outward', 'Inward', 'JobWork')),
    CONSTRAINT CK_DeliveryChallans_ChallanStatus CHECK (ChallanStatus IN ('Draft', 'Dispatched', 'Received', 'Cancelled'))
);
GO

-- Delivery Challan Details
CREATE TABLE sales.DeliveryChallanDetails
(
    DeliveryChallanDetailId BIGINT IDENTITY(1,1) NOT NULL,
    DeliveryChallanId   BIGINT NOT NULL,
    LineNumber          INT NOT NULL,
    ItemId              BIGINT NOT NULL,
    HSNCode             NVARCHAR(10) NOT NULL,
    Quantity            DECIMAL(18,4) NOT NULL,
    UnitId              BIGINT NOT NULL,
    Rate                DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalAmount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    ColorCode           NVARCHAR(20) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    DesignCode          NVARCHAR(20) NULL,
    BatchNumber         NVARCHAR(50) NULL,
    RollCount           INT NULL,
    Meters              DECIMAL(18,2) NULL,
    Weight              DECIMAL(18,2) NULL,
    SalesOrderDetailId  BIGINT NULL,
    ItemRemarks         NVARCHAR(500) NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_DeliveryChallanDetails PRIMARY KEY CLUSTERED (DeliveryChallanDetailId),
    CONSTRAINT FK_DeliveryChallanDetails_DeliveryChallans FOREIGN KEY (DeliveryChallanId) 
        REFERENCES sales.DeliveryChallans(DeliveryChallanId),
    CONSTRAINT FK_DeliveryChallanDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_DeliveryChallanDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_DeliveryChallanDetails_SalesOrderDetails FOREIGN KEY (SalesOrderDetailId) 
        REFERENCES sales.SalesOrderDetails(SalesOrderDetailId),
    CONSTRAINT CK_DeliveryChallanDetails_Quantity CHECK (Quantity > 0)
);
GO

PRINT 'Tables sales.DeliveryChallans, sales.DeliveryChallanDetails created successfully.';
GO
