-- ============================================================================
-- TEXTILE ERP - SALES MODULE - PROFORMA INVOICES TABLE
-- ============================================================================

USE TextileERP;
GO

-- Proforma Invoice Headers
CREATE TABLE sales.ProformaInvoices
(
    ProformaInvoiceId   BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    InvoiceNumber       NVARCHAR(30) NOT NULL,
    InvoiceDate         DATE NOT NULL,
    ValidUntilDate      DATE NULL,
    InvoiceStatus       NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Sent, Accepted, Converted, Cancelled
    
    -- Customer
    CustomerId          BIGINT NOT NULL,
    CustomerGSTIN       NVARCHAR(15) NULL,
    CustomerStateCode   NVARCHAR(2) NULL,
    ContactPerson       NVARCHAR(100) NULL,
    
    -- Address
    BillingAddress      NVARCHAR(500) NULL,
    ShippingAddress     NVARCHAR(500) NULL,
    
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
    NetAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Reference
    SalesOrderId        BIGINT NULL,
    ReferenceNumber     NVARCHAR(50) NULL,
    CustomerPONumber    NVARCHAR(50) NULL,
    
    -- Terms
    PaymentTerms        NVARCHAR(200) NULL,
    DeliveryTerms       NVARCHAR(200) NULL,
    Remarks             NVARCHAR(500) NULL,
    
    -- Conversion
    ConvertedToSalesInvoice BIT NOT NULL DEFAULT 0,
    SalesInvoiceId      BIGINT NULL,
    ConversionDate      DATETIME2 NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    IsCancelled         BIT NOT NULL DEFAULT 0,
    CancelledBy         BIGINT NULL,
    CancelledDate       DATETIME2 NULL,
    
    CONSTRAINT PK_ProformaInvoices PRIMARY KEY CLUSTERED (ProformaInvoiceId),
    CONSTRAINT UQ_ProformaInvoices_CompanyInvoiceNumber UNIQUE (CompanyId, InvoiceNumber),
    CONSTRAINT FK_ProformaInvoices_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_ProformaInvoices_Customers FOREIGN KEY (CustomerId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_ProformaInvoices_SalesOrders FOREIGN KEY (SalesOrderId) 
        REFERENCES sales.SalesOrders(SalesOrderId),
    CONSTRAINT CK_ProformaInvoices_InvoiceStatus CHECK (InvoiceStatus IN ('Draft', 'Sent', 'Accepted', 'Converted', 'Cancelled'))
);
GO

-- Proforma Invoice Details
CREATE TABLE sales.ProformaInvoiceDetails
(
    ProformaInvoiceDetailId BIGINT IDENTITY(1,1) NOT NULL,
    ProformaInvoiceId   BIGINT NOT NULL,
    LineNumber          INT NOT NULL,
    ItemId              BIGINT NOT NULL,
    HSNCode             NVARCHAR(10) NOT NULL,
    Quantity            DECIMAL(18,4) NOT NULL,
    UnitId              BIGINT NOT NULL,
    Rate                DECIMAL(18,4) NOT NULL,
    DiscountPercent     DECIMAL(5,2) NOT NULL DEFAULT 0,
    DiscountAmount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    BasicAmount         DECIMAL(18,2) NOT NULL,
    GSTRate             DECIMAL(5,2) NOT NULL DEFAULT 0,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    TaxableAmount       DECIMAL(18,2) NOT NULL,
    TotalAmount         DECIMAL(18,2) NOT NULL,
    ColorCode           NVARCHAR(20) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    DesignCode          NVARCHAR(20) NULL,
    Width               DECIMAL(8,2) NULL,
    GSM                 DECIMAL(8,2) NULL,
    QualityGrade        NVARCHAR(10) NULL,
    SalesOrderDetailId  BIGINT NULL,
    ItemRemarks         NVARCHAR(500) NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_ProformaInvoiceDetails PRIMARY KEY CLUSTERED (ProformaInvoiceDetailId),
    CONSTRAINT FK_ProformaInvoiceDetails_ProformaInvoices FOREIGN KEY (ProformaInvoiceId) 
        REFERENCES sales.ProformaInvoices(ProformaInvoiceId),
    CONSTRAINT FK_ProformaInvoiceDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_ProformaInvoiceDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_ProformaInvoiceDetails_SalesOrderDetails FOREIGN KEY (SalesOrderDetailId) 
        REFERENCES sales.SalesOrderDetails(SalesOrderDetailId),
    CONSTRAINT CK_ProformaInvoiceDetails_Quantity CHECK (Quantity > 0)
);
GO

PRINT 'Tables sales.ProformaInvoices, sales.ProformaInvoiceDetails created successfully.';
GO
