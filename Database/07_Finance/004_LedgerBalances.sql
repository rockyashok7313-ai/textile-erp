-- ============================================================================
-- TEXTILE ERP - FINANCE MODULE - LEDGER BALANCES TABLE
-- ============================================================================

USE TextileERP;
GO

-- Ledger Balances (Running Balances)
CREATE TABLE finance.LedgerBalances
(
    LedgerBalanceId     BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    LedgerId            BIGINT NOT NULL,
    FinancialYear       NVARCHAR(10) NOT NULL,  -- e.g., '2025-26'
    PeriodMonth         INT NOT NULL,  -- 1-12
    
    -- Opening
    OpeningDebit        DECIMAL(18,2) NOT NULL DEFAULT 0,
    OpeningCredit       DECIMAL(18,2) NOT NULL DEFAULT 0,
    OpeningBalance      AS (OpeningDebit - OpeningCredit) PERSISTED,
    
    -- Movement
    PeriodDebit         DECIMAL(18,2) NOT NULL DEFAULT 0,
    PeriodCredit        DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Closing
    ClosingDebit        AS (OpeningDebit + PeriodDebit) PERSISTED,
    ClosingCredit       AS (OpeningCredit + PeriodCredit) PERSISTED,
    ClosingBalance      AS ((OpeningDebit + PeriodDebit) - (OpeningCredit + PeriodCredit)) PERSISTED,
    
    -- Audit
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_LedgerBalances PRIMARY KEY CLUSTERED (LedgerBalanceId),
    CONSTRAINT UQ_LedgerBalances_CompanyLedgerYearMonth UNIQUE (CompanyId, LedgerId, FinancialYear, PeriodMonth),
    CONSTRAINT FK_LedgerBalances_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_LedgerBalances_Ledgers FOREIGN KEY (LedgerId) 
        REFERENCES master.Ledgers(LedgerId),
    CONSTRAINT CK_LedgerBalances_PeriodMonth CHECK (PeriodMonth >= 1 AND PeriodMonth <= 12)
);
GO

-- Financial Year
CREATE TABLE finance.FiscalYear
(
    FiscalYearId        BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    FinancialYear       NVARCHAR(10) NOT NULL,  -- e.g., '2025-26'
    YearStartDate       DATE NOT NULL,
    YearEndDate         DATE NOT NULL,
    IsDefault           BIT NOT NULL DEFAULT 0,
    IsClosed            BIT NOT NULL DEFAULT 0,
    ClosedBy            BIGINT NULL,
    ClosedDate          DATETIME2 NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_FiscalYear PRIMARY KEY CLUSTERED (FiscalYearId),
    CONSTRAINT UQ_FiscalYear_CompanyFinancialYear UNIQUE (CompanyId, FinancialYear),
    CONSTRAINT FK_FiscalYear_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId)
);
GO

-- Interest Calculations
CREATE TABLE finance.InterestCalculations
(
    InterestId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    PartyId             BIGINT NOT NULL,
    CalculationDate     DATE NOT NULL,
    FromDate            DATE NOT NULL,
    ToDate              DATE NOT NULL,
    OutstandingAmount   DECIMAL(18,2) NOT NULL,
    InterestRate        DECIMAL(5,2) NOT NULL,  -- Annual rate
    DaysCalculated      INT NOT NULL,
    InterestAmount      AS (OutstandingAmount * InterestRate * DaysCalculated / 36500) PERSISTED,
    IsPosted            BIT NOT NULL DEFAULT 0,
    VoucherId           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_InterestCalculations PRIMARY KEY CLUSTERED (InterestId),
    CONSTRAINT FK_InterestCalculations_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_InterestCalculations_Parties FOREIGN KEY (PartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT FK_InterestCalculations_Vouchers FOREIGN KEY (VoucherId) 
        REFERENCES finance.Vouchers(VoucherId)
);
GO

PRINT 'Tables finance.LedgerBalances, finance.FiscalYear, finance.InterestCalculations created successfully.';
GO
