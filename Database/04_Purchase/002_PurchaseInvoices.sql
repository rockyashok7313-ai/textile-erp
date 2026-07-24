-- ============================================================================
-- TEXTILE ERP - PURCHASE MODULE - PURCHASE INVOICES TABLE
-- ============================================================================

USE TextileERP;
GO

-- Purchase Invoice Headers
CREATE TABLE purchase.PurchaseInvoices
(
    PurchaseInvoiceId   BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    InvoiceNumber       NVARCHAR(30) NOT NULL,
    InvoiceDate         DATE NOT NULL,
    DueDate             DATE NULL,
    InvoiceStatus       NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Posted, Paid, PartiallyPaid, Cancelled
    
    -- Supplier
    SupplierId          BIGINT NOT NULL,
    SupplierGSTIN       NVARCHAR(15) NULL,
    SupplierStateCode   NVARCHAR(2) NULL,
    SupplierInvoiceNumber NVARCHAR(50) NULL,  -- Supplier's invoice number
    SupplierInvoiceDate DATE NULL,
    
    -- Address
    BillingAddress      NVARCHAR(500) NULL,
    ShippingAddress     NVARCHAR(500) NULL,
    
    -- Delivery
    ReceivedGodownId    BIGINT NULL,
    DeliveryDate        DATE NULL,
    
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
    AmountPaid          DECIMAL(18,2) NOT NULL DEFAULT 0,
    BalanceAmount       AS (NetAmount - AmountPaid) PERSISTED,
    PaymentStatus       AS (CASE 
                              WHEN AmountPaid = 0 THEN 'Unpaid'
                              WHEN AmountPaid >= NetAmount THEN 'Paid'
                              ELSE 'Partial'
                           END) PERSISTED,
    
    -- Currency
    CurrencyCode        NVARCHAR(3) NOT NULL DEFAULT 'INR',
    ExchangeRate        DECIMAL(10,4) NOT NULL DEFAULT 1,
    
    -- References
    PurchaseOrderId     BIGINT NULL,
    ReferenceNumber     NVARCHAR(50) NULL,
    ProjectCode         NVARCHAR(50) NULL,
    
    -- Terms
    PaymentTerms        NVARCHAR(200) NULL,
    Remarks             NVARCHAR(500) NULL,
    InternalRemarks     NVARCHAR(500) NULL,
    
    -- ITC
    ITCStatus           NVARCHAR(20) NULL DEFAULT 'Eligible',  -- Eligible, Ineligible, Blocked
    ITCReason           NVARCHAR(500) NULL,
    
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
    
    CONSTRAINT PK_PurchaseInvoices PRIMARY KEY CLUSTERED (PurchaseInvoiceId),
    CONSTRAINT UQ_PurchaseInvoices_CompanyInvoiceNumber UNIQUE (CompanyId, InvoiceNumber),
    CONSTRAINT FK_PurchaseInvoices_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_PurchaseInvoices_Suppliers FOREIGN KEY (SupplierId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_PurchaseInvoices_ReceivedGodown FOREIGN KEY (ReceivedGodownId) 
        REFERENCES master.Godowns(GodownId),
    CONSTRAINT FK_PurchaseInvoices_PurchaseOrders FOREIGN KEY (PurchaseOrderId) 
        REFERENCES purchase.PurchaseOrders(PurchaseOrderId),
    CONSTRAINT CK_PurchaseInvoices_InvoiceStatus CHECK (InvoiceStatus IN ('Draft', 'Posted', 'Paid', 'PartiallyPaid', 'Cancelled')),
    CONSTRAINT CK_PurchaseInvoices_ITCStatus CHECK (ITCStatus IN ('Eligible', 'Ineligible', 'Blocked', NULL))
);
GO

-- Purchase Invoice Details (Line Items)
CREATE TABLE purchase.PurchaseInvoiceDetails
(
    PurchaseInvoiceDetailId BIGINT IDENTITY(1,1) NOT NULL,
    PurchaseInvoiceId   BIGINT NOT NULL,
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
    Width               DECIMAL(8,2) NULL,
    GSM                 DECIMAL(8,2) NULL,
    QualityGrade        NVARCHAR(10) NULL,
    BatchNumber         NVARCHAR(50) NULL,
    
    -- Reference
    PurchaseOrderDetailId BIGINT NULL,
    
    -- Remarks
    ItemRemarks         NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_PurchaseInvoiceDetails PRIMARY KEY CLUSTERED (PurchaseInvoiceDetailId),
    CONSTRAINT FK_PurchaseInvoiceDetails_PurchaseInvoices FOREIGN KEY (PurchaseInvoiceId) 
        REFERENCES purchase.PurchaseInvoices(PurchaseInvoiceId),
    CONSTRAINT FK_PurchaseInvoiceDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_PurchaseInvoiceDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_PurchaseInvoiceDetails_PurchaseOrderDetails FOREIGN KEY (PurchaseOrderDetailId) 
        REFERENCES purchase.PurchaseOrderDetails(PurchaseOrderDetailId),
    CONSTRAINT CK_PurchaseInvoiceDetails_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_PurchaseInvoiceDetails_Rate CHECK (Rate >= 0)
);
GO

PRINT 'Tables purchase.PurchaseInvoices, purchase.PurchaseInvoiceDetails created successfully.';
GO
