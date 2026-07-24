-- ============================================================================
-- TEXTILE ERP - SALES MODULE - SALES RETURNS (CREDIT NOTE) TABLE
-- ============================================================================

USE TextileERP;
GO

-- Sales Returns Headers
CREATE TABLE sales.SalesReturns
(
    SalesReturnId       BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    ReturnNumber        NVARCHAR(30) NOT NULL,
    ReturnDate          DATE NOT NULL,
    ReturnType          NVARCHAR(20) NOT NULL DEFAULT 'Regular',  -- Regular, DeemedExport, SEZ, Export
    ReturnStatus        NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Posted, Cancelled
    
    -- Customer
    CustomerId          BIGINT NOT NULL,
    CustomerGSTIN       NVARCHAR(15) NULL,
    CustomerStateCode   NVARCHAR(2) NULL,
    
    -- Reference
    SalesInvoiceId      BIGINT NULL,
    Reason              NVARCHAR(500) NULL,
    
    -- Tax
    IsInterState        BIT NOT NULL DEFAULT 0,
    PlaceOfSupply       NVARCHAR(50) NULL,
    PlaceOfSupplyStateCode NVARCHAR(2) NULL,
    
    -- Amount
    TotalQuantity       DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalAmount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalTaxableAmount  DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalSGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalIGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCess           DECIMAL(18,2) NOT NULL DEFAULT 0,
    NetAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- E-invoice
    IRN                 NVARCHAR(64) NULL,
    IRNDate             DATETIME2 NULL,
    IsEInvoiceRequired  BIT NOT NULL DEFAULT 0,
    EInvoiceStatus      NVARCHAR(20) NULL DEFAULT 'NotGenerated',
    
    -- Remarks
    Remarks             NVARCHAR(500) NULL,
    
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
    
    CONSTRAINT PK_SalesReturns PRIMARY KEY CLUSTERED (SalesReturnId),
    CONSTRAINT UQ_SalesReturns_CompanyReturnNumber UNIQUE (CompanyId, ReturnNumber),
    CONSTRAINT FK_SalesReturns_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_SalesReturns_Customers FOREIGN KEY (CustomerId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_SalesReturns_SalesInvoices FOREIGN KEY (SalesInvoiceId) 
        REFERENCES sales.SalesInvoices(SalesInvoiceId),
    CONSTRAINT CK_SalesReturns_ReturnType CHECK (ReturnType IN ('Regular', 'DeemedExport', 'SEZ', 'Export')),
    CONSTRAINT CK_SalesReturns_ReturnStatus CHECK (ReturnStatus IN ('Draft', 'Posted', 'Cancelled'))
);
GO

-- Sales Return Details
CREATE TABLE sales.SalesReturnDetails
(
    SalesReturnDetailId BIGINT IDENTITY(1,1) NOT NULL,
    SalesReturnId       BIGINT NOT NULL,
    LineNumber          INT NOT NULL,
    ItemId              BIGINT NOT NULL,
    HSNCode             NVARCHAR(10) NOT NULL,
    Quantity            DECIMAL(18,4) NOT NULL,
    UnitId              BIGINT NOT NULL,
    Rate                DECIMAL(18,4) NOT NULL,
    TaxableAmount       DECIMAL(18,2) NOT NULL,
    GSTRate             DECIMAL(5,2) NOT NULL DEFAULT 0,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalAmount         DECIMAL(18,2) NOT NULL,
    ColorCode           NVARCHAR(20) NULL,
    ShadeCode           NVARCHAR(20) NULL,
    BatchNumber         NVARCHAR(50) NULL,
    SalesInvoiceDetailId BIGINT NULL,
    ItemRemarks         NVARCHAR(500) NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_SalesReturnDetails PRIMARY KEY CLUSTERED (SalesReturnDetailId),
    CONSTRAINT FK_SalesReturnDetails_SalesReturns FOREIGN KEY (SalesReturnId) 
        REFERENCES sales.SalesReturns(SalesReturnId),
    CONSTRAINT FK_SalesReturnDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_SalesReturnDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_SalesReturnDetails_SalesInvoiceDetails FOREIGN KEY (SalesInvoiceDetailId) 
        REFERENCES sales.SalesInvoiceDetails(SalesInvoiceDetailId),
    CONSTRAINT CK_SalesReturnDetails_Quantity CHECK (Quantity > 0)
);
GO

PRINT 'Tables sales.SalesReturns, sales.SalesReturnDetails created successfully.';
GO
