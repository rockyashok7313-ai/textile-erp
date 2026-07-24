-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - PARTIES TABLE (Customers & Suppliers)
-- ============================================================================

USE TextileERP;
GO

-- Parties Table
CREATE TABLE master.Parties
(
    PartyId             BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    PartyCode           NVARCHAR(20) NOT NULL,
    PartyName           NVARCHAR(200) NOT NULL,
    TradeName           NVARCHAR(200) NULL,
    LegalName           NVARCHAR(200) NULL,
    PartyType           NVARCHAR(20) NOT NULL,  -- Customer, Supplier, Both
    
    -- GST & Tax
    GSTIN               NVARCHAR(15) NULL,
    PAN                 NVARCHAR(10) NULL,
    TAN                 NVARCHAR(10) NULL,
    RegistrationType    NVARCHAR(20) NOT NULL DEFAULT 'Regular',  -- Regular, Composition, Unregistered, SEZ
    IsReverseCharge     BIT NOT NULL DEFAULT 0,
    
    -- TDS/TCS
    IsTDSApplicable     BIT NOT NULL DEFAULT 0,
    TDSSection          NVARCHAR(10) NULL,  -- 194C, 194Q, 194J, 194A
    TDSSectionCode      NVARCHAR(10) NULL,
    TDSRate             DECIMAL(5,2) NULL,
    TDSLimit            DECIMAL(18,2) NULL,  -- Threshold limit
    IsTCSApplicable     BIT NOT NULL DEFAULT 0,
    TCSSection          NVARCHAR(10) NULL,  -- 206C(1H), 206C(1G)
    TCSRate             DECIMAL(5,2) NULL,
    TCSLimit            DECIMAL(18,2) NULL,  -- Threshold limit
    
    -- Contact
    ContactPerson       NVARCHAR(100) NULL,
    ContactPersonDesignation NVARCHAR(50) NULL,
    Phone               NVARCHAR(20) NULL,
    Mobile              NVARCHAR(20) NULL,
    AlternateMobile     NVARCHAR(20) NULL,
    Email               NVARCHAR(100) NULL,
    Website             NVARCHAR(200) NULL,
    Fax                 NVARCHAR(20) NULL,
    
    -- Address
    AddressLine1        NVARCHAR(200) NULL,
    AddressLine2        NVARCHAR(200) NULL,
    AddressLine3        NVARCHAR(200) NULL,
    City                NVARCHAR(100) NULL,
    District            NVARCHAR(100) NULL,
    StateId             BIGINT NULL,
    StateCode           NVARCHAR(2) NULL,
    PinCode             NVARCHAR(10) NULL,
    CountryId           INT NOT NULL DEFAULT 1,
    
    -- Shipping Address
    ShipAddressLine1    NVARCHAR(200) NULL,
    ShipAddressLine2    NVARCHAR(200) NULL,
    ShipAddressLine3    NVARCHAR(200) NULL,
    ShipCity            NVARCHAR(100) NULL,
    ShipDistrict        NVARCHAR(100) NULL,
    ShipStateId         BIGINT NULL,
    ShipStateCode       NVARCHAR(2) NULL,
    ShipPinCode         NVARCHAR(10) NULL,
    
    -- Location (for E-way bill)
    Latitude            DECIMAL(10,8) NULL,
    Longitude           DECIMAL(11,8) NULL,
    GISCode             NVARCHAR(50) NULL,
    
    -- Financial
    OpeningBalance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    OpeningBalanceType  NVARCHAR(10) NULL DEFAULT 'Dr',  -- Dr, Cr
    CreditLimit         DECIMAL(18,2) NOT NULL DEFAULT 0,
    PaymentTermsDays    INT NOT NULL DEFAULT 0,
    DiscountPercent     DECIMAL(5,2) NOT NULL DEFAULT 0,
    PriceGroup          NVARCHAR(20) NULL,  -- Wholesale, Retail, Export
    
    -- Bank Details
    BankName            NVARCHAR(200) NULL,
    BankBranch          NVARCHAR(200) NULL,
    BankAccountNumber   NVARCHAR(50) NULL,
    BankIFSC            NVARCHAR(20) NULL,
    BankMICR            NVARCHAR(15) NULL,
    SWIFTCode           NVARCHAR(20) NULL,
    
    -- Export Details
    IECCode             NVARCHAR(10) NULL,
    BINNumber           NVARCHAR(20) NULL,
    ADCode              NVARCHAR(10) NULL,
    PortCode            NVARCHAR(10) NULL,
    
    -- Status
    IsActive            BIT NOT NULL DEFAULT 1,
    IsBlacklisted       BIT NOT NULL DEFAULT 0,
    BlacklistReason     NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Parties PRIMARY KEY CLUSTERED (PartyId),
    CONSTRAINT UQ_Parties_CompanyPartyCode UNIQUE (CompanyId, PartyCode),
    CONSTRAINT UQ_Parties_GSTIN UNIQUE (GSTIN),
    CONSTRAINT FK_Parties_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_Parties_PartyType CHECK (PartyType IN ('Customer', 'Supplier', 'Both')),
    CONSTRAINT CK_Parties_RegistrationType CHECK (RegistrationType IN ('Regular', 'Composition', 'Unregistered', 'SEZ')),
    CONSTRAINT CK_Parties_OpeningBalanceType CHECK (OpeningBalanceType IN ('Dr', 'Cr', NULL))
);
GO

-- Party Addresses (Multiple Addresses)
CREATE TABLE master.PartyAddresses
(
    AddressId           BIGINT IDENTITY(1,1) NOT NULL,
    PartyId             BIGINT NOT NULL,
    AddressType         NVARCHAR(20) NOT NULL,  -- Billing, Shipping, Registered, Factory
    AddressName         NVARCHAR(100) NULL,
    ContactPerson       NVARCHAR(100) NULL,
    Phone               NVARCHAR(20) NULL,
    Mobile              NVARCHAR(20) NULL,
    Email               NVARCHAR(100) NULL,
    AddressLine1        NVARCHAR(200) NOT NULL,
    AddressLine2        NVARCHAR(200) NULL,
    AddressLine3        NVARCHAR(200) NULL,
    City                NVARCHAR(100) NOT NULL,
    District            NVARCHAR(100) NULL,
    StateId             BIGINT NOT NULL,
    StateCode           NVARCHAR(2) NOT NULL,
    PinCode             NVARCHAR(10) NOT NULL,
    CountryId           INT NOT NULL DEFAULT 1,
    GSTIN               NVARCHAR(15) NULL,
    Latitude            DECIMAL(10,8) NULL,
    Longitude           DECIMAL(11,8) NULL,
    IsDefault           BIT NOT NULL DEFAULT 0,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_PartyAddresses PRIMARY KEY CLUSTERED (AddressId),
    CONSTRAINT FK_PartyAddresses_Parties FOREIGN KEY (PartyId) 
        REFERENCES master.Parties(PartyId),
    CONSTRAINT CK_PartyAddresses_AddressType CHECK (AddressType IN ('Billing', 'Shipping', 'Registered', 'Factory', 'Warehouse'))
);
GO

PRINT 'Tables master.Parties, master.PartyAddresses created successfully.';
GO
