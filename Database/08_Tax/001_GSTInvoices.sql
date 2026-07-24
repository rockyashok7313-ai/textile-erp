-- ============================================================================
-- TEXTILE ERP - TAX MODULE - GST INVOICES TABLE
-- ============================================================================

USE TextileERP;
GO

-- GST Invoice Records
CREATE TABLE tax.GSTInvoices
(
    GSTInvoiceId        BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    InvoiceType         NVARCHAR(20) NOT NULL,  -- Sales, Purchase, CreditNote, DebitNote
    InvoiceId           BIGINT NOT NULL,
    InvoiceNumber       NVARCHAR(30) NOT NULL,
    InvoiceDate         DATE NOT NULL,
    
    -- Party
    PartyId             BIGINT NOT NULL,
    PartyGSTIN          NVARCHAR(15) NULL,
    PartyStateCode      NVARCHAR(2) NULL,
    PartyType           NVARCHAR(10) NOT NULL,  -- Customer, Supplier
    
    -- Tax Details
    IsInterState        BIT NOT NULL DEFAULT 0,
    PlaceOfSupply       NVARCHAR(50) NULL,
    PlaceOfSupplyStateCode NVARCHAR(2) NULL,
    ReverseCharge       BIT NOT NULL DEFAULT 0,
    
    -- Amount
    TaxableAmount       DECIMAL(18,2) NOT NULL DEFAULT 0,
    CGSTRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    SGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGSTRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    IGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    CessAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalTaxAmount      AS (CGSTAmount + SGSTAmount + IGSTAmount + CessAmount) PERSISTED,
    InvoiceValue        DECIMAL(18,2) NOT NULL,
    
    -- HSN Summary
    TotalHSNCount       INT NOT NULL DEFAULT 0,
    
    -- Filing Status
    GSTR1Status         NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Filed, Amended
    GSTR1FilingDate     DATE NULL,
    GSTR3BStatus        NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    GSTR3BFilingDate    DATE NULL,
    
    -- ITC
    ITCStatus           NVARCHAR(20) NULL DEFAULT 'Eligible',  -- Eligible, Ineligible, Blocked, Reversed
    ITCReversalAmount   DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_GSTInvoices PRIMARY KEY CLUSTERED (GSTInvoiceId),
    CONSTRAINT FK_GSTInvoices_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_GSTInvoices_Parties FOREIGN KEY (PartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT CK_GSTInvoices_InvoiceType CHECK (InvoiceType IN ('Sales', 'Purchase', 'CreditNote', 'DebitNote')),
    CONSTRAINT CK_GSTInvoices_PartyType CHECK (PartyType IN ('Customer', 'Supplier')),
    CONSTRAINT CK_GSTInvoices_GSTR1Status CHECK (GSTR1Status IN ('Pending', 'Filed', 'Amended')),
    CONSTRAINT CK_GSTInvoices_GSTR3BStatus CHECK (GSTR3BStatus IN ('Pending', 'Filed', 'Amended'))
);
GO

-- GST Invoice Details (HSN-wise)
CREATE TABLE tax.GSTInvoiceDetails
(
    GSTInvoiceDetailId  BIGINT IDENTITY(1,1) NOT NULL,
    GSTInvoiceId        BIGINT NOT NULL,
    HSNCode             NVARCHAR(10) NOT NULL,
    HSNDesc             NVARCHAR(500) NULL,
    UQC                 NVARCHAR(20) NULL,
    Quantity            DECIMAL(18,4) NOT NULL DEFAULT 0,
    TaxableValue        DECIMAL(18,2) NOT NULL DEFAULT 0,
    CGSTRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    SGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGSTRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    IGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    CessAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalValue          AS (TaxableValue + CGSTAmount + SGSTAmount + IGSTAmount + CessAmount) PERSISTED,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_GSTInvoiceDetails PRIMARY KEY CLUSTERED (GSTInvoiceDetailId),
    CONSTRAINT FK_GSTInvoiceDetails_GSTInvoices FOREIGN KEY (GSTInvoiceId) 
        REFERENCES tax.GSTInvoices(GSTInvoiceId),
    CONSTRAINT CK_GSTInvoiceDetails_Quantity CHECK (Quantity >= 0)
);
GO

PRINT 'Tables tax.GSTInvoices, tax.GSTInvoiceDetails created successfully.';
GO
