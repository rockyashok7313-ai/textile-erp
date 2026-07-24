-- ============================================================================
-- TEXTILE ERP - SALES MODULE - SALES INVOICES TABLE
-- ============================================================================

USE TextileERP;
GO

-- Sales Invoice Headers
CREATE TABLE sales.SalesInvoices
(
    SalesInvoiceId      BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    InvoiceNumber       NVARCHAR(30) NOT NULL,
    InvoiceDate         DATE NOT NULL,
    DueDate             DATE NULL,
    InvoiceType         NVARCHAR(20) NOT NULL DEFAULT 'Regular',  -- Regular, SEZ, Export, DeemedExport, ISD, ReverseCharge
    InvoiceStatus       NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Posted, Sent, Cancelled
    
    -- Customer
    CustomerId          BIGINT NOT NULL,
    CustomerGSTIN       NVARCHAR(15) NULL,
    CustomerPAN         NVARCHAR(10) NULL,
    CustomerStateCode   NVARCHAR(2) NULL,
    CustomerName        NVARCHAR(200) NULL,
    ContactPerson       NVARCHAR(100) NULL,
    
    -- Address
    BillingAddress      NVARCHAR(500) NULL,
    ShippingAddress     NVARCHAR(500) NULL,
    ShippingAddressId   BIGINT NULL,
    
    -- Delivery
    DispatchGodownId    BIGINT NULL,
    DeliveryDate        DATE NULL,
    DeliveryChallanNumber NVARCHAR(30) NULL,
    
    -- Tax
    IsInterState        BIT NOT NULL DEFAULT 0,
    IsReverseCharge     BIT NOT NULL DEFAULT 0,
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
    
    -- Payment
    AmountReceived      DECIMAL(18,2) NOT NULL DEFAULT 0,
    BalanceAmount       AS (NetAmount - AmountReceived) PERSISTED,
    PaymentStatus       AS (CASE 
                              WHEN AmountReceived = 0 THEN 'Unpaid'
                              WHEN AmountReceived >= NetAmount THEN 'Paid'
                              ELSE 'Partial'
                           END) PERSISTED,
    
    -- Currency
    CurrencyCode        NVARCHAR(3) NOT NULL DEFAULT 'INR',
    ExchangeRate        DECIMAL(10,4) NOT NULL DEFAULT 1,
    
    -- References
    SalesOrderId        BIGINT NULL,
    ProformaInvoiceId   BIGINT NULL,
    CustomerPONumber    NVARCHAR(50) NULL,
    CustomerPODate      DATE NULL,
    ReferenceNumber     NVARCHAR(50) NULL,
    ProjectCode         NVARCHAR(50) NULL,
    
    -- E-way Bill
    EWayBillNumber      NVARCHAR(50) NULL,
    EWayBillDate        DATETIME2 NULL,
    EWayBillValidUpto   DATETIME2 NULL,
    IsEWayBillRequired  BIT NOT NULL DEFAULT 0,
    
    -- E-invoice
    IRN                 NVARCHAR(64) NULL,
    IRNDate             DATETIME2 NULL,
    EInvoiceAckNumber   NVARCHAR(50) NULL,
    EInvoiceQRCode      NVARCHAR(MAX) NULL,
    IsEInvoiceRequired  BIT NOT NULL DEFAULT 0,
    EInvoiceStatus      NVARCHAR(20) NULL DEFAULT 'NotGenerated',  -- NotGenerated, Generated, Cancelled
    
    -- Export
    IsExport            BIT NOT NULL DEFAULT 0,
    ExportType          NVARCHAR(30) NULL,  -- WithPayment, WithoutPayment, LUT
    ShippingBillNumber  NVARCHAR(50) NULL,
    ShippingBillDate    DATE NULL,
    PortCode            NVARCHAR(10) NULL,
    FOBValue            DECIMAL(18,2) NULL,
    
    -- Terms
    PaymentTerms        NVARCHAR(200) NULL,
    DeliveryTerms       NVARCHAR(200) NULL,
    Remarks             NVARCHAR(500) NULL,
    InternalRemarks     NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    PostedBy            BIGINT NULL,
    PostedDate          DATETIME2 NULL,
    IsCancelled         BIT NOT NULL DEFAULT 0,
    CancelledBy         BIGINT NULL,
    CancelledDate       DATETIME2 NULL,
    CancelReason        NVARCHAR(500) NULL,
    
    CONSTRAINT PK_SalesInvoices PRIMARY KEY CLUSTERED (SalesInvoiceId),
    CONSTRAINT UQ_SalesInvoices_CompanyInvoiceNumber UNIQUE (CompanyId, InvoiceNumber),
    CONSTRAINT FK_SalesInvoices_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_SalesInvoices_Customers FOREIGN KEY (CustomerId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_SalesInvoices_DispatchGodown FOREIGN KEY (DispatchGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_SalesInvoices_ShippingAddress FOREIGN KEY (ShippingAddressId) 
        REFERENCES master.PartyAddresses(AddressId),
    CONSTRAINT FK_SalesInvoices_SalesOrders FOREIGN KEY (SalesOrderId) 
        REFERENCES sales.SalesOrders(SalesOrderId),
    CONSTRAINT FK_SalesInvoices_ProformaInvoices FOREIGN KEY (ProformaInvoiceId) 
        REFERENCES sales.ProformaInvoices(ProformaInvoiceId),
    CONSTRAINT CK_SalesInvoices_InvoiceType CHECK (InvoiceType IN ('Regular', 'SEZ', 'Export', 'DeemedExport', 'ISD', 'ReverseCharge')),
    CONSTRAINT CK_SalesInvoices_InvoiceStatus CHECK (InvoiceStatus IN ('Draft', 'Posted', 'Sent', 'Cancelled')),
    CONSTRAINT CK_SalesInvoices_EInvoiceStatus CHECK (EInvoiceStatus IN ('NotGenerated', 'Generated', 'Cancelled', NULL))
);
GO

-- Sales Invoice Details (Line Items)
CREATE TABLE sales.SalesInvoiceDetails
(
    SalesInvoiceDetailId BIGINT IDENTITY(1,1) NOT NULL,
    SalesInvoiceId      BIGINT NOT NULL,
    LineNumber          INT NOT NULL,
    ItemId              BIGINT NOT NULL,
    ItemDescription     NVARCHAR(500) NULL,
    HSNCode             NVARCHAR(10) NOT NULL,
    
    -- Quantity
    Quantity            DECIMAL(18,4) NOT NULL,
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
    BatchNumber         NVARCHAR(50) NULL,
    
    -- Reference
    SalesOrderDetailId  BIGINT NULL,
    ProformaInvoiceDetailId BIGINT NULL,
    
    -- Remarks
    ItemRemarks         NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_SalesInvoiceDetails PRIMARY KEY CLUSTERED (SalesInvoiceDetailId),
    CONSTRAINT FK_SalesInvoiceDetails_SalesInvoices FOREIGN KEY (SalesInvoiceId) 
        REFERENCES sales.SalesInvoices(SalesInvoiceId),
    CONSTRAINT FK_SalesInvoiceDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_SalesInvoiceDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_SalesInvoiceDetails_SalesOrderDetails FOREIGN KEY (SalesOrderDetailId) 
        REFERENCES sales.SalesOrderDetails(SalesOrderDetailId),
    CONSTRAINT FK_SalesInvoiceDetails_ProformaInvoiceDetails FOREIGN KEY (ProformaInvoiceDetailId) 
        REFERENCES sales.ProformaInvoiceDetails(ProformaInvoiceDetailId),
    CONSTRAINT CK_SalesInvoiceDetails_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_SalesInvoiceDetails_Rate CHECK (Rate >= 0)
);
GO

PRINT 'Tables sales.SalesInvoices, sales.SalesInvoiceDetails created successfully.';
GO
