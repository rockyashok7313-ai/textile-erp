-- ============================================================================
-- TEXTILE ERP - COMPLIANCE MODULE - DOCUMENT SEQUENCE TABLE
-- ============================================================================

USE TextileERP;
GO

-- Document Sequence (Sequential Numbering with Gap Prevention)
CREATE TABLE compliance.DocumentSequence
(
    SequenceId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    DocumentType        NVARCHAR(30) NOT NULL,  -- PurchaseOrder, SalesOrder, Invoice, etc.
    FinancialYear       NVARCHAR(10) NOT NULL,  -- e.g., '2025-26'
    Prefix              NVARCHAR(20) NOT NULL DEFAULT '',
    Suffix              NVARCHAR(20) NOT NULL DEFAULT '',
    CurrentNumber       BIGINT NOT NULL DEFAULT 0,
    MinDigits           INT NOT NULL DEFAULT 6,
    MaxNumber           BIGINT NULL,
    ResetYearly         BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_DocumentSequence PRIMARY KEY CLUSTERED (SequenceId),
    CONSTRAINT UQ_DocumentSequence_CompanyDocTypeYear UNIQUE (CompanyId, DocumentType, FinancialYear),
    CONSTRAINT FK_DocumentSequence_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_DocumentSequence_DocumentType CHECK (DocumentType IN (
        'PurchaseOrder', 'PurchaseInvoice', 'PurchaseReturn', 'GRN',
        'SalesOrder', 'ProformaInvoice', 'SalesInvoice', 'DeliveryChallan', 'SalesReturn',
        'EWayBill', 'EInvoice',
        'PaymentVoucher', 'ReceiptVoucher', 'JournalVoucher', 'ContraVoucher',
        'CreditNote', 'DebitNote',
        'StockJournal', 'PhysicalStock',
        'ProductionOrder', 'JobWork',
        'TDSChallan', 'TCSChallan'
    ))
);
GO

PRINT 'Table compliance.DocumentSequence created successfully.';
GO
