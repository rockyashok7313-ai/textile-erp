-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - STATE MASTERS TABLE
-- ============================================================================

USE TextileERP;
GO

-- State Masters (Indian States and UTs)
CREATE TABLE master.StateMasters
(
    StateId             BIGINT IDENTITY(1,1) NOT NULL,
    StateCode           NVARCHAR(2) NOT NULL,  -- GST State Code (01-37, 97)
    StateName           NVARCHAR(100) NOT NULL,
    StateShortName      NVARCHAR(50) NULL,
    StateType           NVARCHAR(20) NOT NULL,  -- State, Union Territory
    CountryId           INT NOT NULL DEFAULT 1,
    IsUTWithLegislature BIT NOT NULL DEFAULT 0,  -- Delhi, Puducherry, J&K
    IsGSTApplicable     BIT NOT NULL DEFAULT 1,
    TANStateCode        NVARCHAR(2) NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_StateMasters PRIMARY KEY CLUSTERED (StateId),
    CONSTRAINT UQ_StateMasters_StateCode UNIQUE (StateCode),
    CONSTRAINT UQ_StateMasters_StateName UNIQUE (StateName),
    CONSTRAINT CK_StateMasters_StateType CHECK (StateType IN ('State', 'Union Territory'))
);
GO

-- Countries Master
CREATE TABLE master.Countries
(
    CountryId           INT IDENTITY(1,1) NOT NULL,
    CountryCode         NVARCHAR(5) NOT NULL,
    CountryName         NVARCHAR(100) NOT NULL,
    CountryShortName    NVARCHAR(50) NULL,
    ISDCode             NVARCHAR(5) NULL,
    CurrencyCode        NVARCHAR(3) NULL,
    CurrencyName        NVARCHAR(50) NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT PK_Countries PRIMARY KEY CLUSTERED (CountryId),
    CONSTRAINT UQ_Countries_CountryCode UNIQUE (CountryCode)
);
GO

PRINT 'Tables master.StateMasters, master.Countries created successfully.';
GO
