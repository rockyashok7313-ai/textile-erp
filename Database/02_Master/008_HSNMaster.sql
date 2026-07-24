-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - HSN MASTER TABLE
-- ============================================================================

USE TextileERP;
GO

-- HSN Code Master
CREATE TABLE master.HSNMaster
(
    HSNId               BIGINT IDENTITY(1,1) NOT NULL,
    HSNCode             NVARCHAR(10) NOT NULL,
    HSNDescription      NVARCHAR(500) NOT NULL,
    HSNLevel            INT NOT NULL,  -- 2, 4, 6, 8 digit
    ParentHSNCode       NVARCHAR(10) NULL,
    GSTRate             DECIMAL(5,2) NOT NULL DEFAULT 0,
    CessRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    IsGSTRApplicable    BIT NOT NULL DEFAULT 1,
    UQC                 NVARCHAR(20) NULL,  -- Unit Quantity Code for GST
    IsTextileHSN        BIT NOT NULL DEFAULT 0,  -- Flag for textile HSN
    TextileCategory     NVARCHAR(50) NULL,  -- Cotton, Synthetic, Silk, etc.
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_HSNMaster PRIMARY KEY CLUSTERED (HSNId),
    CONSTRAINT UQ_HSNMaster_HSNCode UNIQUE (HSNCode),
    CONSTRAINT CK_HSNMaster_HSNLevel CHECK (HSNLevel IN (2, 4, 6, 8))
);
GO

-- GST Rates Master
CREATE TABLE master.GSTRates
(
    GSTRateId           BIGINT IDENTITY(1,1) NOT NULL,
    GSTRateCode         NVARCHAR(20) NOT NULL,
    GSTRateName         NVARCHAR(100) NOT NULL,
    CGSTRate            DECIMAL(5,2) NOT NULL,
    SGSTRate            DECIMAL(5,2) NOT NULL,
    IGSTRate            DECIMAL(5,2) NOT NULL,
    CessRate            DECIMAL(5,2) NOT NULL DEFAULT 0,
    EffectiveFrom       DATE NOT NULL,
    EffectiveTo         DATE NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_GSTRates PRIMARY KEY CLUSTERED (GSTRateId),
    CONSTRAINT UQ_GSTRates_GSTRateCode UNIQUE (GSTRateCode),
    CONSTRAINT CK_GSTRates_Rates CHECK (CGSTRate >= 0 AND SGSTRate >= 0 AND IGSTRate >= 0)
);
GO

PRINT 'Tables master.HSNMaster, master.GSTRates created successfully.';
GO
