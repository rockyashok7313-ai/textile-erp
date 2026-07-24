-- ============================================================================
-- TEXTILE ERP - FINANCE MODULE - VOUCHERS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Voucher Headers
CREATE TABLE finance.Vouchers
(
    VoucherId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    VoucherNumber       NVARCHAR(30) NOT NULL,
    VoucherDate         DATE NOT NULL,
    VoucherType         NVARCHAR(30) NOT NULL,  -- Receipt, Payment, Journal, Contra, CreditNote, DebitNote
    VoucherStatus       NVARCHAR(20) NOT NULL DEFAULT 'Draft',  -- Draft, Posted, Cancelled
    
    -- Reference
    ReferenceType       NVARCHAR(30) NULL,  -- Purchase, Sales, Journal
    ReferenceId         BIGINT NULL,
    ReferenceNumber     NVARCHAR(50) NULL,
    
    -- Amount
    TotalDebit          DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCredit         DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Payment/Receipt Specific
    PaymentMode         NVARCHAR(20) NULL,  -- Cash, Cheque, NEFT, RTGS, UPI
    ChequeNumber        NVARCHAR(50) NULL,
    ChequeDate          DATE NULL,
    BankName            NVARCHAR(200) NULL,
    TransactionRef      NVARCHAR(100) NULL,
    
    -- TDS/TCS
    TDSAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TCSAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Narration
    Narration           NVARCHAR(2000) NULL,
    
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
    
    CONSTRAINT PK_Vouchers PRIMARY KEY CLUSTERED (VoucherId),
    CONSTRAINT UQ_Vouchers_CompanyVoucherNumber UNIQUE (CompanyId, VoucherNumber),
    CONSTRAINT FK_Vouchers_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_Vouchers_VoucherType CHECK (VoucherType IN ('Receipt', 'Payment', 'Journal', 'Contra', 'CreditNote', 'DebitNote')),
    CONSTRAINT CK_Vouchers_VoucherStatus CHECK (VoucherStatus IN ('Draft', 'Posted', 'Cancelled'))
);
GO

-- Voucher Details (Double Entry)
CREATE TABLE finance.VoucherDetails
(
    VoucherDetailId     BIGINT IDENTITY(1,1) NOT NULL,
    VoucherId           BIGINT NOT NULL,
    LineNumber          INT NOT NULL,
    LedgerId            BIGINT NOT NULL,
    DebitAmount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    CreditAmount        DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Party
    PartyId             BIGINT NULL,
    PartyType           NVARCHAR(10) NULL,  -- Customer, Supplier
    
    -- Bill Reference
    BillReferenceNumber NVARCHAR(50) NULL,
    BillReferenceDate   DATE NULL,
    
    -- GST
    GSTLedgerType       NVARCHAR(20) NULL,  -- CGST, SGST, IGST
    GSTAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- TDS/TCS
    TDSLedgerId         BIGINT NULL,
    TDSAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TCSLedgerId         BIGINT NULL,
    TCSAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Cost Center
    CostCenterCode      NVARCHAR(20) NULL,
    ProjectCode         NVARCHAR(50) NULL,
    
    -- Narration
    LineNarration       NVARCHAR(500) NULL,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_VoucherDetails PRIMARY KEY CLUSTERED (VoucherDetailId),
    CONSTRAINT FK_VoucherDetails_Vouchers FOREIGN KEY (VoucherId) 
        REFERENCES finance.Vouchers(VoucherId),
    CONSTRAINT FK_VoucherDetails_Ledgers FOREIGN KEY (LedgerId) 
        REFERENCES master.Ledgers(LedgerId),
    CONSTRAINT FK_VoucherDetails_Parties FOREIGN KEY (PartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_VoucherDetails_TDSLedger FOREIGN KEY (TDSLedgerId) 
        REFERENCES master.Ledgers(LedgerId),
    CONSTRAINT FK_VoucherDetails_TCSLedger FOREIGN KEY (TCSLedgerId) 
        REFERENCES master.Ledgers(LedgerId),
    CONSTRAINT CK_VoucherDetails_DebitAmount CHECK (DebitAmount >= 0),
    CONSTRAINT CK_VoucherDetails_CreditAmount CHECK (CreditAmount >= 0),
    CONSTRAINT CK_VoucherDetails_DebitCredit CHECK (DebitAmount > 0 OR CreditAmount > 0)
);
GO

PRINT 'Tables finance.Vouchers, finance.VoucherDetails created successfully.';
GO
