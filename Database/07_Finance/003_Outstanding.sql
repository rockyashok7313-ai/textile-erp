-- ============================================================================
-- TEXTILE ERP - FINANCE MODULE - OUTSTANDING TABLES
-- ============================================================================

USE TextileERP;
GO

-- Outstanding Receivable (Customer)
CREATE TABLE finance.OutstandingReceivable
(
    ReceivableId        BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    CustomerId          BIGINT NOT NULL,
    
    -- Reference
    ReferenceType       NVARCHAR(20) NOT NULL,  -- Sales Invoice, Credit Note
    ReferenceId         BIGINT NOT NULL,
    ReferenceNumber     NVARCHAR(30) NOT NULL,
    ReferenceDate       DATE NOT NULL,
    
    -- Amount
    InvoiceAmount       DECIMAL(18,2) NOT NULL,
    PaidAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    BalanceAmount       AS (InvoiceAmount - PaidAmount) PERSISTED,
    
    -- Aging
    DueDate             DATE NOT NULL,
    DaysOverdue         AS (DATEDIFF(DAY, DueDate, GETDATE())) PERSISTED,
    AgingBucket         NVARCHAR(20) NULL,  -- Current, 30, 60, 90, 120, 180, 365, Above365
    
    -- Status
    PaymentStatus       NVARCHAR(20) NOT NULL DEFAULT 'Unpaid',  -- Unpaid, Partial, Paid, Overdue
    IsActive            BIT NOT NULL DEFAULT 1,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_OutstandingReceivable PRIMARY KEY CLUSTERED (ReceivableId),
    CONSTRAINT FK_OutstandingReceivable_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_OutstandingReceivable_Customers FOREIGN KEY (CustomerId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT CK_OutstandingReceivable_ReferenceType CHECK (ReferenceType IN ('Sales Invoice', 'Credit Note', 'Debit Note')),
    CONSTRAINT CK_OutstandingReceivable_PaymentStatus CHECK (PaymentStatus IN ('Unpaid', 'Partial', 'Paid', 'Overdue'))
);
GO

-- Outstanding Payable (Supplier)
CREATE TABLE finance.OutstandingPayable
(
    PayableId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    SupplierId          BIGINT NOT NULL,
    
    -- Reference
    ReferenceType       NVARCHAR(20) NOT NULL,  -- Purchase Invoice, Debit Note
    ReferenceId         BIGINT NOT NULL,
    ReferenceNumber     NVARCHAR(30) NOT NULL,
    ReferenceDate       DATE NOT NULL,
    
    -- Amount
    InvoiceAmount       DECIMAL(18,2) NOT NULL,
    PaidAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    BalanceAmount       AS (InvoiceAmount - PaidAmount) PERSISTED,
    
    -- Aging
    DueDate             DATE NOT NULL,
    DaysOverdue         AS (DATEDIFF(DAY, DueDate, GETDATE())) PERSISTED,
    AgingBucket         NVARCHAR(20) NULL,  -- Current, 30, 60, 90, 120, 180, 365, Above365
    
    -- Status
    PaymentStatus       NVARCHAR(20) NOT NULL DEFAULT 'Unpaid',  -- Unpaid, Partial, Paid, Overdue
    IsActive            BIT NOT NULL DEFAULT 1,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_OutstandingPayable PRIMARY KEY CLUSTERED (PayableId),
    CONSTRAINT FK_OutstandingPayable_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_OutstandingPayable_Suppliers FOREIGN KEY (SupplierId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT CK_OutstandingPayable_ReferenceType CHECK (ReferenceType IN ('Purchase Invoice', 'Debit Note', 'Credit Note')),
    CONSTRAINT CK_OutstandingPayable_PaymentStatus CHECK (PaymentStatus IN ('Unpaid', 'Partial', 'Paid', 'Overdue'))
);
GO

-- Payment Allocation (track payments against invoices)
CREATE TABLE finance.PaymentAllocation
(
    AllocationId        BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    VoucherId           BIGINT NOT NULL,
    ReferenceType       NVARCHAR(20) NOT NULL,  -- Receivable, Payable
    ReferenceId         BIGINT NOT NULL,
    AllocatedAmount     DECIMAL(18,2) NOT NULL,
    AllocationDate      DATE NOT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_PaymentAllocation PRIMARY KEY CLUSTERED (AllocationId),
    CONSTRAINT FK_PaymentAllocation_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_PaymentAllocation_Vouchers FOREIGN KEY (VoucherId) 
        REFERENCES finance.Vouchers(VoucherId),
    CONSTRAINT CK_PaymentAllocation_ReferenceType CHECK (ReferenceType IN ('Receivable', 'Payable'))
);
GO

PRINT 'Tables finance.OutstandingReceivable, finance.OutstandingPayable, finance.PaymentAllocation created successfully.';
GO
