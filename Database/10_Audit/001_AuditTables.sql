-- ============================================================================
-- TEXTILE ERP - AUDIT MODULE - AUDIT TABLES
-- ============================================================================

USE TextileERP;
GO

-- Activity Logs (User Activity Tracking)
CREATE TABLE audit.ActivityLogs
(
    ActivityLogId       BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    UserId              BIGINT NULL,
    UserName            NVARCHAR(100) NULL,
    
    -- Activity
    ActivityType        NVARCHAR(30) NOT NULL,  -- Login, Logout, Create, Update, Delete, View, Print, Export
    ModuleName          NVARCHAR(50) NOT NULL,  -- Purchase, Sales, Inventory, etc.
    SubModuleName       NVARCHAR(50) NULL,
    ActivityDescription NVARCHAR(500) NULL,
    
    -- Reference
    ReferenceType       NVARCHAR(30) NULL,
    ReferenceId         BIGINT NULL,
    ReferenceNumber     NVARCHAR(50) NULL,
    
    -- Details
    OldValue            NVARCHAR(MAX) NULL,
    NewValue            NVARCHAR(MAX) NULL,
    ChangedColumns      NVARCHAR(1000) NULL,
    
    -- System
    IPAddress           NVARCHAR(50) NULL,
    BrowserInfo         NVARCHAR(200) NULL,
    DeviceInfo          NVARCHAR(200) NULL,
    
    -- Audit
    ActivityDate        DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_ActivityLogs PRIMARY KEY CLUSTERED (ActivityLogId),
    CONSTRAINT FK_ActivityLogs_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_ActivityLogs_Users FOREIGN KEY (UserId) 
        REFERENCES master.Users(UserId),
    CONSTRAINT CK_ActivityLogs_ActivityType CHECK (ActivityType IN ('Login', 'Logout', 'Create', 'Update', 'Delete', 'View', 'Print', 'Export', 'Import', 'Approve', 'Cancel'))
);
GO

-- Data Changes (Detailed Change Tracking)
CREATE TABLE audit.DataChanges
(
    DataChangeId        BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    UserId              BIGINT NULL,
    TableName           NVARCHAR(100) NOT NULL,
    RecordId            BIGINT NOT NULL,
    ChangeType          NVARCHAR(10) NOT NULL,  -- INSERT, UPDATE, DELETE
    
    -- Changes
    ColumnName          NVARCHAR(100) NOT NULL,
    OldValue            NVARCHAR(MAX) NULL,
    NewValue            NVARCHAR(MAX) NULL,
    DataType            NVARCHAR(50) NULL,
    
    -- Audit
    ChangedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_DataChanges PRIMARY KEY CLUSTERED (DataChangeId),
    CONSTRAINT FK_DataChanges_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_DataChanges_Users FOREIGN KEY (UserId) 
        REFERENCES master.Users(UserId),
    CONSTRAINT CK_DataChanges_ChangeType CHECK (ChangeType IN ('INSERT', 'UPDATE', 'DELETE'))
);
GO

-- Error Logs
CREATE TABLE audit.ErrorLogs
(
    ErrorLogId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NULL,
    UserId              BIGINT NULL,
    
    -- Error
    ErrorLevel          NVARCHAR(10) NOT NULL,  -- Error, Warning, Information
    ErrorSource         NVARCHAR(200) NULL,
    ErrorNumber         INT NULL,
    ErrorMessage        NVARCHAR(MAX) NOT NULL,
    ErrorProcedure      NVARCHAR(200) NULL,
    ErrorLine           INT NULL,
    ErrorStackTrace     NVARCHAR(MAX) NULL,
    
    -- Context
    RequestUrl          NVARCHAR(500) NULL,
    RequestMethod       NVARCHAR(10) NULL,
    RequestBody         NVARCHAR(MAX) NULL,
    IPAddress           NVARCHAR(50) NULL,
    UserAgent           NVARCHAR(500) NULL,
    
    -- Resolution
    IsResolved          BIT NOT NULL DEFAULT 0,
    ResolvedBy          BIGINT NULL,
    ResolvedDate        DATETIME2 NULL,
    ResolutionNotes     NVARCHAR(500) NULL,
    
    -- Audit
    ErrorDate           DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_ErrorLogs PRIMARY KEY CLUSTERED (ErrorLogId),
    CONSTRAINT FK_ErrorLogs_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_ErrorLogs_Users FOREIGN KEY (UserId) 
        REFERENCES master.Users(UserId),
    CONSTRAINT CK_ErrorLogs_ErrorLevel CHECK (ErrorLevel IN ('Error', 'Warning', 'Information'))
);
GO

-- Login History
CREATE TABLE audit.LoginHistory
(
    LoginHistoryId      BIGINT IDENTITY(1,1) NOT NULL,
    UserId              BIGINT NOT NULL,
    CompanyId           BIGINT NOT NULL,
    LoginDate           DATETIME2 NOT NULL DEFAULT GETDATE(),
    LogoutDate          DATETIME2 NULL,
    SessionDuration     AS (DATEDIFF(MINUTE, LoginDate, LogoutDate)) PERSISTED,
    
    -- Status
    LoginStatus         NVARCHAR(20) NOT NULL,  -- Success, Failed, Blocked
    FailureReason       NVARCHAR(200) NULL,
    
    -- System
    IPAddress           NVARCHAR(50) NULL,
    BrowserInfo         NVARCHAR(200) NULL,
    DeviceInfo          NVARCHAR(200) NULL,
    Location            NVARCHAR(200) NULL,
    
    -- Session
    SessionId           NVARCHAR(100) NULL,
    TokenExpiry         DATETIME2 NULL,
    
    CONSTRAINT PK_LoginHistory PRIMARY KEY CLUSTERED (LoginHistoryId),
    CONSTRAINT FK_LoginHistory_Users FOREIGN KEY (UserId) 
        REFERENCES master.Users(UserId),
    CONSTRAINT FK_LoginHistory_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT CK_LoginHistory_LoginStatus CHECK (LoginStatus IN ('Success', 'Failed', 'Blocked'))
);
GO

PRINT 'Tables audit.ActivityLogs, audit.DataChanges, audit.ErrorLogs, audit.LoginHistory created successfully.';
GO
