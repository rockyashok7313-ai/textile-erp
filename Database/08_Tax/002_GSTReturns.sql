-- ============================================================================
-- TEXTILE ERP - TAX MODULE - GST RETURNS TABLE
-- ============================================================================

USE TextileERP;
GO

-- GST Return Filings
CREATE TABLE tax.GSTReturns
(
    GSTReturnId         BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    ReturnType          NVARCHAR(10) NOT NULL,  -- GSTR1, GSTR3B, GSTR2B, GSTR9
    ReturnPeriod        NVARCHAR(10) NOT NULL,  -- MMYYYY
    ReturnYear          INT NOT NULL,
    FilingFrequency     NVARCHAR(10) NOT NULL,  -- Monthly, Quarterly
    DueDate             DATE NOT NULL,
    FilingDate          DATE NULL,
    FilingStatus        NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Ready, Filed, Late, Amended
    
    -- Summary
    TotalInvoices       INT NOT NULL DEFAULT 0,
    TotalTaxableValue   DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalTaxAmount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalSGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalIGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCess           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- GSTR3B Specific
    Table3_1A           DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Outward taxable supplies
    Table3_1B           DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Outward taxable supplies (zero rated)
    Table3_2            DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Inter-state supplies
    Table4A             DECIMAL(18,2) NOT NULL DEFAULT 0,  -- ITC Available
    Table4B             DECIMAL(18,2) NOT NULL DEFAULT 0,  -- ITC Reversed
    Table5              DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Exempt, Nil, Non-GST
    Table6_1            DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Cash Ledger
    Table6_2            DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Credit Ledger
    Table6_3            DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Net ITC
    
    -- Filing Details
    ARN                 NVARCHAR(50) NULL,  -- Acknowledgement Reference Number
    ARNDate             DATE NULL,
    GSTIN               NVARCHAR(15) NULL,
    
    -- Export/Import
    ExportDataGenerated BIT NOT NULL DEFAULT 0,
    JSONFilePath        NVARCHAR(500) NULL,
    ExcelFilePath       NVARCHAR(500) NULL,
    
    -- Remarks
    Remarks             NVARCHAR(500) NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_GSTReturns PRIMARY KEY CLUSTERED (GSTReturnId),
    CONSTRAINT UQ_GSTReturns_CompanyReturnTypePeriod UNIQUE (CompanyId, ReturnType, ReturnPeriod, ReturnYear),
    CONSTRAINT FK_GSTReturns_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_GSTReturns_ReturnType CHECK (ReturnType IN ('GSTR1', 'GSTR3B', 'GSTR2B', 'GSTR9', 'GSTR9C')),
    CONSTRAINT CK_GSTReturns_FilingStatus CHECK (FilingStatus IN ('Pending', 'Ready', 'Filed', 'Late', 'Amended'))
);
GO

-- GSTR-1 Details (Monthly/Quarterly)
CREATE TABLE tax.GSTR1Details
(
    GSTR1DetailId       BIGINT IDENTITY(1,1) NOT NULL,
    GSTReturnId         BIGINT NOT NULL,
    SectionCode         NVARCHAR(10) NOT NULL,  -- 4A, 4B, 4C, 5, 6, 7, 8, 9A, 9B, 10, 11
    SectionDescription  NVARCHAR(100) NULL,
    
    -- Summary
    TotalInvoices       INT NOT NULL DEFAULT 0,
    TotalTaxableValue   DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalSGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalIGST           DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCess           DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_GSTR1Details PRIMARY KEY CLUSTERED (GSTR1DetailId),
    CONSTRAINT FK_GSTR1Details_GSTReturns FOREIGN KEY (GSTReturnId) 
        REFERENCES tax.GSTReturns(GSTReturnId),
    CONSTRAINT CK_GSTR1Details_SectionCode CHECK (SectionCode IN ('4A', '4B', '4C', '5', '6', '7', '8', '9A', '9B', '10', '11'))
);
GO

-- GSTR-3B Details
CREATE TABLE tax.GSTR3BDetails
(
    GSTR3BDetailId      BIGINT IDENTITY(1,1) NOT NULL,
    GSTReturnId         BIGINT NOT NULL,
    TableNumber         NVARCHAR(10) NOT NULL,  -- 3.1, 3.2, 4, 5, 6.1
    Description         NVARCHAR(100) NULL,
    TaxableValue        DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGST                DECIMAL(18,2) NOT NULL DEFAULT 0,
    CGST                DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGST                DECIMAL(18,2) NOT NULL DEFAULT 0,
    Cess                DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_GSTR3BDetails PRIMARY KEY CLUSTERED (GSTR3BDetailId),
    CONSTRAINT FK_GSTR3BDetails_GSTReturns FOREIGN KEY (GSTReturnId) 
        REFERENCES tax.GSTReturns(GSTReturnId),
    CONSTRAINT CK_GSTR3BDetails_TableNumber CHECK (TableNumber IN ('3.1', '3.2', '4', '5', '6.1', '6.2', '6.3'))
);
GO

PRINT 'Tables tax.GSTReturns, tax.GSTR1Details, tax.GSTR3BDetails created successfully.';
GO
