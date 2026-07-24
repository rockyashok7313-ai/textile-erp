-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - COMPANIES TABLE
-- ============================================================================

USE TextileERP;
GO

-- Companies Table
CREATE TABLE master.Companies
(
    CompanyId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyCode         NVARCHAR(20) NOT NULL,
    CompanyName         NVARCHAR(200) NOT NULL,
    TradeName           NVARCHAR(200) NULL,
    LegalName           NVARCHAR(200) NULL,
    GSTIN               NVARCHAR(15) NULL,
    PAN                 NVARCHAR(10) NULL,
    TAN                 NVARCHAR(10) NULL,
    CIN                 NVARCHAR(21) NULL,  -- Corporate Identity Number
    IEC                 NVARCHAR(10) NULL,  -- Import Export Code
    RegistrationType    NVARCHAR(20) NOT NULL DEFAULT 'Regular',  -- Regular, Composition, SEZ
    AddressLine1        NVARCHAR(200) NULL,
    AddressLine2        NVARCHAR(200) NULL,
    AddressLine3        NVARCHAR(200) NULL,
    City                NVARCHAR(100) NULL,
    StateId             BIGINT NOT NULL,
    StateCode           NVARCHAR(2) NOT NULL,
    PinCode             NVARCHAR(10) NULL,
    CountryId           INT NOT NULL DEFAULT 1,  -- India = 1
    Phone               NVARCHAR(20) NULL,
    Mobile              NVARCHAR(20) NULL,
    Email               NVARCHAR(100) NULL,
    Website             NVARCHAR(200) NULL,
    Logo                VARBINARY(MAX) NULL,
    LogoPath            NVARCHAR(500) NULL,
    BankName            NVARCHAR(200) NULL,
    BankBranch          NVARCHAR(200) NULL,
    BankAccountNumber   NVARCHAR(50) NULL,
    BankIFSC            NVARCHAR(20) NULL,
    BankMICR            NVARCHAR(15) NULL,
    UdyogAdhaar         NVARCHAR(20) NULL,  -- MSME Registration
    GSTReturnType       NVARCHAR(10) NOT NULL DEFAULT 'GSTR1',  -- GSTR1, GSTR3B
    EWayBillApplicable  BIT NOT NULL DEFAULT 1,
    EInvoiceApplicable  BIT NOT NULL DEFAULT 1,
    TDSApplicable       BIT NOT NULL DEFAULT 0,
    TCSApplicable       BIT NOT NULL DEFAULT 0,
    FiscalYearStartMonth INT NOT NULL DEFAULT 4,  -- April = 4
    DateFormat          NVARCHAR(20) NOT NULL DEFAULT 'DD/MM/YYYY',
    CurrencyCode        NVARCHAR(3) NOT NULL DEFAULT 'INR',
    Timezone            NVARCHAR(50) NOT NULL DEFAULT 'Asia/Kolkata',
    IsActive            BIT NOT NULL DEFAULT 1,
    IsDefault           BIT NOT NULL DEFAULT 0,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Companies PRIMARY KEY CLUSTERED (CompanyId),
    CONSTRAINT UQ_Companies_CompanyCode UNIQUE (CompanyCode),
    CONSTRAINT UQ_Companies_GSTIN UNIQUE (GSTIN),
    CONSTRAINT UQ_Companies_PAN UNIQUE (PAN),
    CONSTRAINT CK_Companies_RegistrationType CHECK (RegistrationType IN ('Regular', 'Composition', 'SEZ', 'Unregistered'))
);
GO

PRINT 'Table master.Companies created successfully.';
GO
