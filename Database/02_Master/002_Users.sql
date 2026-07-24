-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - USERS TABLE
-- ============================================================================

USE TextileERP;
GO

-- Users Table
CREATE TABLE master.Users
(
    UserId              BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    UserCode            NVARCHAR(20) NOT NULL,
    UserName            NVARCHAR(100) NOT NULL,
    LoginId             NVARCHAR(50) NOT NULL,
    PasswordHash        NVARCHAR(500) NOT NULL,
    PasswordSalt        NVARCHAR(500) NOT NULL,
    Email               NVARCHAR(100) NULL,
    Mobile              NVARCHAR(20) NULL,
    EmployeeCode        NVARCHAR(20) NULL,
    Department          NVARCHAR(50) NULL,
    Designation         NVARCHAR(50) NULL,
    Photo               VARBINARY(MAX) NULL,
    PhotoPath           NVARCHAR(500) NULL,
    DefaultGodownId     BIGINT NULL,
    DefaultLedgerId     BIGINT NULL,
    IsAdmin             BIT NOT NULL DEFAULT 0,
    IsSuperAdmin        BIT NOT NULL DEFAULT 0,
    IsApprover          BIT NOT NULL DEFAULT 0,
    CanApprovePurchase  BIT NOT NULL DEFAULT 0,
    CanApproveSales     BIT NOT NULL DEFAULT 0,
    CanApprovePayment   BIT NOT NULL DEFAULT 0,
    MaxDiscountPercent  DECIMAL(5,2) NOT NULL DEFAULT 0,
    MaxCreditLimit      DECIMAL(18,2) NOT NULL DEFAULT 0,
    LastLoginDate       DATETIME2 NULL,
    LastPasswordChange  DATETIME2 NULL,
    PasswordExpiryDays  INT NOT NULL DEFAULT 90,
    LoginAttempts       INT NOT NULL DEFAULT 0,
    IsLocked            BIT NOT NULL DEFAULT 0,
    LockedDate          DATETIME2 NULL,
    TwoFactorEnabled    BIT NOT NULL DEFAULT 0,
    TwoFactorSecret     NVARCHAR(100) NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (UserId),
    CONSTRAINT UQ_Users_CompanyUserCode UNIQUE (CompanyId, UserCode),
    CONSTRAINT UQ_Users_LoginId UNIQUE (LoginId),
    CONSTRAINT UQ_Users_Email UNIQUE (Email),
    CONSTRAINT FK_Users_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId)
);
GO

PRINT 'Table master.Users created successfully.';
GO
