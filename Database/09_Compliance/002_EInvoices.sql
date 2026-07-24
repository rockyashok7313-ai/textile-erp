-- ============================================================================
-- TEXTILE ERP - COMPLIANCE MODULE - E-INVOICE TABLE
-- ============================================================================

USE TextileERP;
GO

-- E-Invoice Records
CREATE TABLE compliance.EInvoices
(
    EInvoiceId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    IRN                 NVARCHAR(64) NULL,  -- Invoice Reference Number
    IRNDate             DATETIME2 NULL,
    AcknowledgementNumber NVARCHAR(50) NULL,
    AcknowledgementDate DATETIME2 NULL,
    EInvoiceStatus      NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Generated, Cancelled, Failed
    
    -- Reference
    InvoiceType         NVARCHAR(20) NOT NULL,  -- Sales, CreditNote, DebitNote
    InvoiceId           BIGINT NOT NULL,
    InvoiceNumber       NVARCHAR(30) NOT NULL,
    InvoiceDate         DATE NOT NULL,
    InvoiceCategory     NVARCHAR(20) NOT NULL DEFAULT 'B2B',  -- B2B, B2C, SEZ, EXP, DE
    DocumentType        NVARCHAR(10) NOT NULL DEFAULT 'INV',  -- INV, CRN, DBN
    
    -- Supplier
    SupplierGSTIN       NVARCHAR(15) NOT NULL,
    SupplierLegalName   NVARCHAR(200) NULL,
    SupplierTradeName   NVARCHAR(200) NULL,
    SupplierAddress     NVARCHAR(500) NULL,
    SupplierCity        NVARCHAR(100) NULL,
    SupplierStateCode   NVARCHAR(2) NOT NULL,
    SupplierPinCode     NVARCHAR(10) NULL,
    SupplierPhone       NVARCHAR(20) NULL,
    SupplierEmail       NVARCHAR(100) NULL,
    
    -- Recipient
    RecipientGSTIN      NVARCHAR(15) NULL,
    RecipientLegalName  NVARCHAR(200) NULL,
    RecipientTradeName  NVARCHAR(200) NULL,
    RecipientAddress    NVARCHAR(500) NULL,
    RecipientCity       NVARCHAR(100) NULL,
    RecipientStateCode  NVARCHAR(2) NOT NULL,
    RecipientPinCode    NVARCHAR(10) NOT NULL,
    RecipientPhone      NVARCHAR(20) NULL,
    RecipientEmail      NVARCHAR(100) NULL,
    
    -- Place of Supply
    PlaceOfSupplyCode   NVARCHAR(2) NOT NULL,
    PlaceOfSupplyName   NVARCHAR(100) NULL,
    
    -- Items Summary
    TotalItemLines      INT NOT NULL DEFAULT 0,
    TotalQuantity       DECIMAL(18,4) NOT NULL DEFAULT 0,
    
    -- Amount
    TaxableAmount       DECIMAL(18,2) NOT NULL,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessNonAdvolAmount  DECIMAL(18,2) NOT NULL DEFAULT 0,
    OtherCharges        DECIMAL(18,2) NOT NULL DEFAULT 0,
    Discount            DECIMAL(18,2) NOT NULL DEFAULT 0,
    PreGST              BIT NOT NULL DEFAULT 0,
    RoundOffAmount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalInvoiceValue   DECIMAL(18,2) NOT NULL,
    
    -- Export
    IsExport            BIT NOT NULL DEFAULT 0,
    ExportType          NVARCHAR(30) NULL,  -- WithIGST, WithLUT, SEZ
    ShippingBillNumber  NVARCHAR(50) NULL,
    ShippingBillDate    DATE NULL,
    PortCode            NVARCHAR(10) NULL,
    FOBValue            DECIMAL(18,2) NULL,
    CountryCode         NVARCHAR(5) NULL,
    
    -- Reverse Charge
    IsReverseCharge     BIT NOT NULL DEFAULT 0,
    
    -- QR Code
    QRCode              NVARCHAR(MAX) NULL,
    QRCodeImagePath     NVARCHAR(500) NULL,
    
    -- E-way Bill Link
    EWayBillNumber      NVARCHAR(50) NULL,
    EWayBillLinked      BIT NOT NULL DEFAULT 0,
    
    -- Cancellation
    CancelledDate       DATETIME2 NULL,
    CancelledBy         BIGINT NULL,
    CancelReason        NVARCHAR(500) NULL,
    
    -- Bulk Generation
    IsBulkGenerated     BIT NOT NULL DEFAULT 0,
    BulkBatchId         NVARCHAR(50) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_EInvoices PRIMARY KEY CLUSTERED (EInvoiceId),
    CONSTRAINT UQ_EInvoices_IRN UNIQUE (IRN),
    CONSTRAINT FK_EInvoices_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_EInvoices_InvoiceCategory CHECK (InvoiceCategory IN ('B2B', 'B2C', 'SEZ', 'EXP', 'DE', 'ISD', 'REV')),
    CONSTRAINT CK_EInvoices_DocumentType CHECK (DocumentType IN ('INV', 'CRN', 'DBN')),
    CONSTRAINT CK_EInvoices_EInvoiceStatus CHECK (EInvoiceStatus IN ('Pending', 'Generated', 'Cancelled', 'Failed'))
);
GO

-- E-Invoice Item Details
CREATE TABLE compliance.EInvoiceDetails
(
    EInvoiceDetailId    BIGINT IDENTITY(1,1) NOT NULL,
    EInvoiceId          BIGINT NOT NULL,
    ItemSlNo            INT NOT NULL,
    ItemDescription     NVARCHAR(200) NOT NULL,
    HSNCode             NVARCHAR(10) NOT NULL,
    ItemCode            NVARCHAR(50) NULL,
    IsService           BIT NOT NULL DEFAULT 0,
    
    -- Quantity
    Quantity            DECIMAL(18,4) NOT NULL,
    UQC                 NVARCHAR(20) NOT NULL,
    
    -- Amount
    UnitPrice           DECIMAL(18,4) NOT NULL,
    TotalAmount         DECIMAL(18,2) NOT NULL,
    PreTaxValue         DECIMAL(18,2) NOT NULL,
    Discount            DECIMAL(18,2) NOT NULL DEFAULT 0,
    TaxableValue        DECIMAL(18,2) NOT NULL,
    
    -- Tax
    GSTRate             DECIMAL(5,2) NOT NULL,
    IGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    CessAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessNonAdvolAmount  DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Batch/Serial
    BatchNumber         NVARCHAR(50) NULL,
    SerialNumber        NVARCHAR(50) NULL,
    
    -- Origin
    OriginCountryCode   NVARCHAR(5) NULL,
    
    -- Remarks
    ItemRemarks         NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_EInvoiceDetails PRIMARY KEY CLUSTERED (EInvoiceDetailId),
    CONSTRAINT FK_EInvoiceDetails_EInvoices FOREIGN KEY (EInvoiceId) 
        REFERENCES compliance.EInvoices(EInvoiceId),
    CONSTRAINT CK_EInvoiceDetails_Quantity CHECK (Quantity > 0)
);
GO

-- E-Invoice API Log
CREATE TABLE compliance.IRNLog
(
    IRNLogId            BIGINT IDENTITY(1,1) NOT NULL,
    EInvoiceId          BIGINT NOT NULL,
    CompanyId           BIGINT NOT NULL,
    ActionType          NVARCHAR(20) NOT NULL,  -- Generate, Cancel, GetDetails, Validate
    APIEndpoint         NVARCHAR(500) NULL,
    RequestPayload      NVARCHAR(MAX) NULL,
    ResponsePayload     NVARCHAR(MAX) NULL,
    StatusCode          INT NULL,
    IsSuccess           BIT NOT NULL DEFAULT 0,
    ErrorMessage        NVARCHAR(2000) NULL,
    ErrorCode           NVARCHAR(50) NULL,
    ProcessedDate       DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_IRNLog PRIMARY KEY CLUSTERED (IRNLogId),
    CONSTRAINT FK_IRNLog_EInvoices FOREIGN KEY (EInvoiceId) 
        REFERENCES compliance.EInvoices(EInvoiceId),
    CONSTRAINT FK_IRNLog_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_IRNLog_ActionType CHECK (ActionType IN ('Generate', 'Cancel', 'GetDetails', 'Validate', 'BulkGenerate'))
);
GO

PRINT 'Tables compliance.EInvoices, compliance.EInvoiceDetails, compliance.IRNLog created successfully.';
GO
