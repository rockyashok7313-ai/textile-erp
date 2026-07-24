-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - LEDGERS TABLE (Chart of Accounts)
-- ============================================================================

USE TextileERP;
GO

-- Ledger Groups (Account Groups)
CREATE TABLE master.LedgerGroups
(
    LedgerGroupId       BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    GroupCode           NVARCHAR(20) NOT NULL,
    GroupName           NVARCHAR(100) NOT NULL,
    ParentGroupId       BIGINT NULL,
    GroupType           NVARCHAR(30) NOT NULL,  -- Assets, Liabilities, Income, Expenses
    GroupNature         NVARCHAR(30) NOT NULL,  -- Debit, Credit
    AffectsProfitLoss   BIT NOT NULL DEFAULT 0,
    IsSystemGroup       BIT NOT NULL DEFAULT 0,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_LedgerGroups PRIMARY KEY CLUSTERED (LedgerGroupId),
    CONSTRAINT UQ_LedgerGroups_CompanyGroupCode UNIQUE (CompanyId, GroupCode),
    CONSTRAINT FK_LedgerGroups_ParentGroup FOREIGN KEY (ParentGroupId) 
        REFERENCES master.LedgerGroups(LedgerGroupId),
    CONSTRAINT FK_LedgerGroups_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_LedgerGroups_GroupType CHECK (GroupType IN ('Assets', 'Liabilities', 'Income', 'Expenses'))
);
GO

-- Ledgers (Chart of Accounts)
CREATE TABLE master.Ledgers
(
    LedgerId            BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    LedgerCode          NVARCHAR(20) NOT NULL,
    LedgerName          NVARCHAR(200) NOT NULL,
    LedgerDisplayName   NVARCHAR(200) NULL,
    LedgerGroupId       BIGINT NOT NULL,
    ParentLedgerId      BIGINT NULL,
    LedgerType          NVARCHAR(30) NOT NULL,  -- General, Bank, Cash, GST, TDS, TCS
    OpeningBalance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    OpeningBalanceType  NVARCHAR(2) NOT NULL DEFAULT 'Dr',  -- Dr, Cr
    CurrentBalance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    CurrencyCode        NVARCHAR(3) NOT NULL DEFAULT 'INR',
    GSTINApplicable     BIT NOT NULL DEFAULT 0,
    IsGSTLedger         BIT NOT NULL DEFAULT 0,
    IsTDSLedger         BIT NOT NULL DEFAULT 0,
    IsTCSLedger         BIT NOT NULL DEFAULT 0,
    IsBankLedger        BIT NOT NULL DEFAULT 0,
    IsCashLedger        BIT NOT NULL DEFAULT 0,
    IsSystemLedger      BIT NOT NULL DEFAULT 0,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Ledgers PRIMARY KEY CLUSTERED (LedgerId),
    CONSTRAINT UQ_Ledgers_CompanyLedgerCode UNIQUE (CompanyId, LedgerCode),
    CONSTRAINT FK_Ledgers_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_Ledgers_LedgerGroups FOREIGN KEY (LedgerGroupId) 
        REFERENCES master.LedgerGroups(LedgerGroupId),
    CONSTRAINT FK_Ledgers_ParentLedger FOREIGN KEY (ParentLedgerId) 
        REFERENCES master.Ledgers(LedgerId),
    CONSTRAINT CK_Ledgers_LedgerType CHECK (LedgerType IN ('General', 'Bank', 'Cash', 'GST', 'TDS', 'TCS'))
);
GO

PRINT 'Tables master.LedgerGroups, master.Ledgers created successfully.';
GO
