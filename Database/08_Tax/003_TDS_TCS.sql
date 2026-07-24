-- ============================================================================
-- TEXTILE ERP - TAX MODULE - TDS/TCS TABLES
-- ============================================================================

USE TextileERP;
GO

-- TDS Entries
CREATE TABLE tax.TDSEntries
(
    TDSEntryId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    TDSDate             DATE NOT NULL,
    
    -- Party
    PartyId             BIGINT NOT NULL,
    PartyName           NVARCHAR(200) NULL,
    PartyGSTIN          NVARCHAR(15) NULL,
    PartyPAN            NVARCHAR(10) NULL,
    IsPANValidated      BIT NOT NULL DEFAULT 0,
    
    -- TDS Details
    TDSSection          NVARCHAR(10) NOT NULL,  -- 194C, 194Q, 194J, 194I(a), 194I(b), 194A
    TDSSectionDescription NVARCHAR(200) NULL,
    TDSRate             DECIMAL(5,2) NOT NULL,
    IsIndividual        BIT NOT NULL DEFAULT 0,  -- Different rate for individual vs others
    
    -- Reference
    ReferenceType       NVARCHAR(20) NOT NULL,  -- Purchase, Payment, Journal
    ReferenceId         BIGINT NOT NULL,
    ReferenceNumber     NVARCHAR(30) NOT NULL,
    ReferenceDate       DATE NOT NULL,
    
    -- Amount
    GrossAmount         DECIMAL(18,2) NOT NULL,
    TDSDeducted         DECIMAL(18,2) NOT NULL,
    NetAmount           AS (GrossAmount - TDSDeducted) PERSISTED,
    
    -- Threshold
    ThresholdLimit      DECIMAL(18,2) NULL,
    IsAboveThreshold    BIT NOT NULL DEFAULT 1,
    
    -- Quarter
    FinancialYear       NVARCHAR(10) NOT NULL,
    Quarter             NVARCHAR(5) NOT NULL,  -- Q1, Q2, Q3, Q4
    
    -- Status
    IsDeducted          BIT NOT NULL DEFAULT 1,
    DeductedDate        DATE NULL,
    IsDeposited         BIT NOT NULL DEFAULT 0,
    DepositDate         DATE NULL,
    ChallanNumber       NVARCHAR(50) NULL,
    
    -- Return
    IsIncludedInReturn  BIT NOT NULL DEFAULT 0,
    ReturnFilingDate    DATE NULL,
    
    -- Certificate
    IsCertificateGenerated BIT NOT NULL DEFAULT 0,
    CertificateNumber   NVARCHAR(50) NULL,
    CertificateDate     DATE NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_TDSEntries PRIMARY KEY CLUSTERED (TDSEntryId),
    CONSTRAINT FK_TDSEntries_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_TDSEntries_Parties FOREIGN KEY (PartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT CK_TDSEntries_TDSSection CHECK (TDSSection IN ('194C', '194Q', '194J', '194I(a)', '194I(b)', '194A', '194H', '194B')),
    CONSTRAINT CK_TDSEntries_ReferenceType CHECK (ReferenceType IN ('Purchase', 'Payment', 'Journal'))
);
GO

-- TCS Entries
CREATE TABLE tax.TCSEntries
(
    TCSEntryId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    TCSDate             DATE NOT NULL,
    
    -- Party
    PartyId             BIGINT NOT NULL,
    PartyName           NVARCHAR(200) NULL,
    PartyGSTIN          NVARCHAR(15) NULL,
    PartyPAN            NVARCHAR(10) NULL,
    
    -- TCS Details
    TCSSection          NVARCHAR(10) NOT NULL,  -- 206C(1H), 206C(1G), 206C(1F), 206C(1E)
    TCSSectionDescription NVARCHAR(200) NULL,
    TCSRate             DECIMAL(5,2) NOT NULL,
    
    -- Reference
    ReferenceType       NVARCHAR(20) NOT NULL,  -- Sales, Receipt
    ReferenceId         BIGINT NOT NULL,
    ReferenceNumber     NVARCHAR(30) NOT NULL,
    ReferenceDate       DATE NOT NULL,
    
    -- Amount
    GrossAmount         DECIMAL(18,2) NOT NULL,
    TCSAmount           DECIMAL(18,2) NOT NULL,
    NetAmount           AS (GrossAmount + TCSAmount) PERSISTED,
    
    -- Threshold
    ThresholdLimit      DECIMAL(18,2) NULL,
    IsAboveThreshold    BIT NOT NULL DEFAULT 1,
    
    -- Quarter
    FinancialYear       NVARCHAR(10) NOT NULL,
    Quarter             NVARCHAR(5) NOT NULL,
    
    -- Status
    IsCollected         BIT NOT NULL DEFAULT 1,
    CollectionDate      DATE NULL,
    IsDeposited         BIT NOT NULL DEFAULT 0,
    DepositDate         DATE NULL,
    ChallanNumber       NVARCHAR(50) NULL,
    
    -- Return
    IsIncludedInReturn  BIT NOT NULL DEFAULT 0,
    ReturnFilingDate    DATE NULL,
    
    -- Certificate
    IsCertificateGenerated BIT NOT NULL DEFAULT 0,
    CertificateNumber   NVARCHAR(50) NULL,
    CertificateDate     DATE NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_TCSEntries PRIMARY KEY CLUSTERED (TCSEntryId),
    CONSTRAINT FK_TCSEntries_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_TCSEntries_Parties FOREIGN KEY (PartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT CK_TCSEntries_TCSSection CHECK (TCSSection IN ('206C(1H)', '206C(1G)', '206C(1F)', '206C(1E)')),
    CONSTRAINT CK_TCSEntries_ReferenceType CHECK (ReferenceType IN ('Sales', 'Receipt'))
);
GO

-- TDS/TCS Challans
CREATE TABLE tax.TDSChallans
(
    ChallanId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    ChallanType         NVARCHAR(3) NOT NULL,  -- TDS, TCS
    ChallanDate         DATE NOT NULL,
    ChallanNumber       NVARCHAR(50) NOT NULL,
    BankBSRCode         NVARCHAR(10) NULL,
    
    -- Amount
    ChallanAmount       DECIMAL(18,2) NOT NULL,
    InterestAmount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    PenaltyAmount       DECIMAL(18,2) NOT NULL DEFAULT 0,
    OtherCharges        DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalAmount         AS (ChallanAmount + InterestAmount + PenaltyAmount + OtherCharges) PERSISTED,
    
    -- Details
    FinancialYear       NVARCHAR(10) NOT NULL,
    Quarter             NVARCHAR(5) NOT NULL,
    SectionCode         NVARCHAR(10) NOT NULL,
    
    -- Payment
    PaymentMode         NVARCHAR(20) NOT NULL DEFAULT 'NetBanking',
    TransactionRef      NVARCHAR(100) NULL,
    IsDeposited         BIT NOT NULL DEFAULT 0,
    DepositDate         DATE NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_TDSChallans PRIMARY KEY CLUSTERED (ChallanId),
    CONSTRAINT FK_TDSChallans_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_TDSChallans_ChallanType CHECK (ChallanType IN ('TDS', 'TCS')),
    CONSTRAINT CK_TDSChallans_PaymentMode CHECK (PaymentMode IN ('NetBanking', 'ChallanAtBank', 'EPayment'))
);
GO

-- TDS/TCS Certificates
CREATE TABLE tax.TDSCertificates
(
    CertificateId       BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    CertificateType     NVARCHAR(5) NOT NULL,  -- 16A, 27D
    CertificateNumber   NVARCHAR(50) NOT NULL,
    CertificateDate     DATE NOT NULL,
    
    -- Party
    PartyId             BIGINT NOT NULL,
    PartyName           NVARCHAR(200) NULL,
    PartyPAN            NVARCHAR(10) NULL,
    
    -- Details
    FinancialYear       NVARCHAR(10) NOT NULL,
    Quarter             NVARCHAR(5) NOT NULL,
    SectionCode         NVARCHAR(10) NOT NULL,
    TDSRate             DECIMAL(5,2) NOT NULL,
    
    -- Amount
    GrossAmount         DECIMAL(18,2) NOT NULL,
    TDSAmount           DECIMAL(18,2) NOT NULL,
    
    -- Status
    IsIssued            BIT NOT NULL DEFAULT 0,
    IssuedDate          DATE NULL,
    IssuedToParty       BIT NOT NULL DEFAULT 0,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_TDSCertificates PRIMARY KEY CLUSTERED (CertificateId),
    CONSTRAINT FK_TDSCertificates_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_TDSCertificates_Parties FOREIGN KEY (PartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT CK_TDSCertificates_CertificateType CHECK (CertificateType IN ('16A', '27D'))
);
GO

PRINT 'Tables tax.TDSEntries, tax.TCSEntries, tax.TDSChallans, tax.TDSCertificates created successfully.';
GO
