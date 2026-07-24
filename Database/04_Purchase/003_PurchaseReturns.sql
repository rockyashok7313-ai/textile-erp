-- ============================================================================
-- TEXTILE ERP - PURCHASE MODULE - PURCHASE RETURNS (DEBIT NOTE) TABLE
-- ============================================================================

USE TextileERP;
GO

-- Purchase Returns Headers
CREATE TABLE purchase.PurchaseReturns
(
    PurchaseReturnId    BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    ReturnNumber        NVARCHAR(30) NOT NULL,
    ReturnDate          DATE NOT NULL,
    ReturnStatus        NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Posted, Cancelled
    
    -- Supplier
    SupplierId          BIGINT NOT NULL,
    SupplierGSTIN       NVARCHAR(15) NULL,
    SupplierStateCode   NVARCHAR(2) NULL,
    SupplierReturnNumber NVARCHAR(50) NULL,
    
    -- Reference
    PurchaseInvoiceId   BIGINT NULL,
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
    
    CONSTRAINT PK_PurchaseReturns PRIMARY KEY CLUSTERED (PurchaseReturnId),
    CONSTRAINT UQ_PurchaseReturns_CompanyReturnNumber UNIQUE (CompanyId, ReturnNumber),
    CONSTRAINT FK_PurchaseReturns_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_PurchaseReturns_Suppliers FOREIGN KEY (SupplierId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_PurchaseReturns_PurchaseInvoices FOREIGN KEY (PurchaseInvoiceId) 
        REFERENCES purchase.PurchaseInvoices(PurchaseInvoiceId),
    CONSTRAINT CK_PurchaseReturns_ReturnStatus CHECK (ReturnStatus IN ('Draft', 'Posted', 'Cancelled'))
);
GO

-- Purchase Return Details
CREATE TABLE purchase.PurchaseReturnDetails
(
    PurchaseReturnDetailId BIGINT IDENTITY(1,1) NOT NULL,
    PurchaseReturnId    BIGINT NOT NULL,
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
    PurchaseInvoiceDetailId BIGINT NULL,
    ItemRemarks         NVARCHAR(500) NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_PurchaseReturnDetails PRIMARY KEY CLUSTERED (PurchaseReturnDetailId),
    CONSTRAINT FK_PurchaseReturnDetails_PurchaseReturns FOREIGN KEY (PurchaseReturnId) 
        REFERENCES purchase.PurchaseReturns(PurchaseReturnId),
    CONSTRAINT FK_PurchaseReturnDetails_Items FOREIGN KEY (ItemId) 
        REFERENCES master.Items(ItemId),
    CONSTRAINT FK_PurchaseReturnDetails_Units FOREIGN KEY (UnitId) 
        REFERENCES master.Units(UnitId),
    CONSTRAINT FK_PurchaseReturnDetails_PurchaseInvoiceDetails FOREIGN KEY (PurchaseInvoiceDetailId) 
        REFERENCES purchase.PurchaseInvoiceDetails(PurchaseInvoiceDetailId),
    CONSTRAINT CK_PurchaseReturnDetails_Quantity CHECK (Quantity > 0)
);
GO

PRINT 'Tables purchase.PurchaseReturns, purchase.PurchaseReturnDetails created successfully.';
GO
