-- ============================================================================
-- TEXTILE ERP - FINANCE MODULE - BANK ACCOUNTS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Bank Accounts
CREATE TABLE finance.BankAccounts
(
    BankAccountId       BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    BankAccountCode     NVARCHAR(20) NOT NULL,
    BankAccountName     NVARCHAR(200) NOT NULL,
    BankName            NVARCHAR(200) NOT NULL,
    BankBranch          NVARCHAR(200) NULL,
    AccountNumber       NVARCHAR(50) NOT NULL,
    AccountHolderName   NVARCHAR(200) NULL,
    IFSCCode            NVARCHAR(20) NOT NULL,
    MICRCode            NVARCHAR(15) NULL,
    SWIFTCode           NVARCHAR(20) NULL,
    AccountType         NVARCHAR(20) NOT NULL DEFAULT 'Current',  -- Current, Savings, OD, CC
    CurrencyCode        NVARCHAR(3) NOT NULL DEFAULT 'INR',
    OpeningBalance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    CurrentBalance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Linked Ledger
    LedgerId            BIGINT NOT NULL,
    
    -- Settings
    IsDefault           BIT NOT NULL DEFAULT 0,
    IsActive            BIT NOT NULL DEFAULT 1,
    IsReconciled        BIT NOT NULL DEFAULT 0,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_BankAccounts PRIMARY KEY CLUSTERED (BankAccountId),
    CONSTRAINT UQ_BankAccounts_CompanyBankAccountCode UNIQUE (CompanyId, BankAccountCode),
    CONSTRAINT UQ_BankAccounts_CompanyAccountNumber UNIQUE (CompanyId, AccountNumber),
    CONSTRAINT FK_BankAccounts_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_BankAccounts_Ledgers FOREIGN KEY (LedgerId) 
        REFERENCES master.Ledgers(LedgerId),
    CONSTRAINT CK_BankAccounts_AccountType CHECK (AccountType IN ('Current', 'Savings', 'OD', 'CC'))
);
GO

-- Bank Transactions
CREATE TABLE finance.BankTransactions
(
    BankTransactionId   BIGINT IDENTITY(1,1) NOT NULL,
    BankAccountId       BIGINT NOT NULL,
    TransactionDate     DATE NOT NULL,
    TransactionType     NVARCHAR(20) NOT NULL,  -- Deposit, Withdrawal, Transfer
    TransactionStatus   NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Cleared, Bounced
    
    -- Amount
    DebitAmount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    CreditAmount        DECIMAL(18,2) NOT NULL DEFAULT 0,
    BalanceAfter        DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Reference
    ChequeNumber        NVARCHAR(50) NULL,
    ChequeDate          DATE NULL,
    TransactionRef      NVARCHAR(100) NULL,
    UTRNumber           NVARCHAR(100) NULL,
    
    -- Party
    PartyId             BIGINT NULL,
    PartyName           NVARCHAR(200) NULL,
    
    -- Narration
    Narration           NVARCHAR(500) NULL,
    
    -- Reconciliation
    IsReconciled        BIT NOT NULL DEFAULT 0,
    ReconciledDate      DATE NULL,
    ReconciledBy        BIGINT NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_BankTransactions PRIMARY KEY CLUSTERED (BankTransactionId),
    CONSTRAINT FK_BankTransactions_BankAccounts FOREIGN KEY (BankAccountId) 
        REFERENCES finance.BankAccounts(BankAccountId),
    CONSTRAINT FK_BankTransactions_Parties FOREIGN KEY (PartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT CK_BankTransactions_TransactionType CHECK (TransactionType IN ('Deposit', 'Withdrawal', 'Transfer')),
    CONSTRAINT CK_BankTransactions_TransactionStatus CHECK (TransactionStatus IN ('Pending', 'Cleared', 'Bounced'))
);
GO

-- Bank Reconciliation
CREATE TABLE finance.BankReconciliation
(
    ReconciliationId    BIGINT IDENTITY(1,1) NOT NULL,
    BankAccountId       BIGINT NOT NULL,
    ReconciliationDate  DATE NOT NULL,
    StatementDate       DATE NOT NULL,
    OpeningBalance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    ClosingBalance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    BookBalance         DECIMAL(18,2) NOT NULL DEFAULT 0,
    Difference          AS (ClosingBalance - BookBalance) PERSISTED,
    IsReconciled        BIT NOT NULL DEFAULT 0,
    ReconciledBy        BIGINT NULL,
    Remarks             NVARCHAR(500) NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_BankReconciliation PRIMARY KEY CLUSTERED (ReconciliationId),
    CONSTRAINT FK_BankReconciliation_BankAccounts FOREIGN KEY (BankAccountId) 
        REFERENCES finance.BankAccounts(BankAccountId)
);
GO

PRINT 'Tables finance.BankAccounts, finance.BankTransactions, finance.BankReconciliation created successfully.';
GO
