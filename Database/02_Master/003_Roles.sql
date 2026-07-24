-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - ROLES TABLE
-- ============================================================================

USE TextileERP;
GO

-- Roles Table
CREATE TABLE master.Roles
(
    RoleId              BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    RoleCode            NVARCHAR(20) NOT NULL,
    RoleName            NVARCHAR(100) NOT NULL,
    RoleDescription     NVARCHAR(500) NULL,
    RoleType            NVARCHAR(20) NOT NULL DEFAULT 'User',  -- Admin, Manager, User, Viewer
    IsSystemRole        BIT NOT NULL DEFAULT 0,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_Roles PRIMARY KEY CLUSTERED (RoleId),
    CONSTRAINT UQ_Roles_CompanyRoleCode UNIQUE (CompanyId, RoleCode),
    CONSTRAINT UQ_Roles_CompanyRoleName UNIQUE (CompanyId, RoleName),
    CONSTRAINT FK_Roles_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_Roles_RoleType CHECK (RoleType IN ('Admin', 'Manager', 'User', 'Viewer'))
);
GO

-- UserRoles Junction Table
CREATE TABLE master.UserRoles
(
    UserRoleId          BIGINT IDENTITY(1,1) NOT NULL,
    UserId              BIGINT NOT NULL,
    RoleId              BIGINT NOT NULL,
    AssignedDate        DATETIME2 NOT NULL DEFAULT GETDATE(),
    AssignedBy          BIGINT NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT PK_UserRoles PRIMARY KEY CLUSTERED (UserRoleId),
    CONSTRAINT UQ_UserRoles UNIQUE (UserId, RoleId),
    CONSTRAINT FK_UserRoles_Users FOREIGN KEY (UserId) 
        REFERENCES master.Users(UserId),
    CONSTRAINT FK_UserRoles_Roles FOREIGN KEY (RoleId) 
        REFERENCES master.Roles(RoleId)
);
GO

-- RolePermissions Table
CREATE TABLE master.RolePermissions
(
    RolePermissionId    BIGINT IDENTITY(1,1) NOT NULL,
    RoleId              BIGINT NOT NULL,
    ModuleName          NVARCHAR(50) NOT NULL,  -- Purchase, Sales, Inventory, etc.
    SubModuleName       NVARCHAR(50) NULL,      -- PurchaseOrder, PurchaseInvoice, etc.
    CanView             BIT NOT NULL DEFAULT 0,
    CanCreate           BIT NOT NULL DEFAULT 0,
    CanEdit             BIT NOT NULL DEFAULT 0,
    CanDelete           BIT NOT NULL DEFAULT 0,
    CanPrint            BIT NOT NULL DEFAULT 0,
    CanExport           BIT NOT NULL DEFAULT 0,
    CanApprove          BIT NOT NULL DEFAULT 0,
    CanOverride         BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT PK_RolePermissions PRIMARY KEY CLUSTERED (RolePermissionId),
    CONSTRAINT UQ_RolePermissions UNIQUE (RoleId, ModuleName, SubModuleName),
    CONSTRAINT FK_RolePermissions_Roles FOREIGN KEY (RoleId) 
        REFERENCES master.Roles(RoleId)
);
GO

PRINT 'Tables master.Roles, master.UserRoles, master.RolePermissions created successfully.';
GO
