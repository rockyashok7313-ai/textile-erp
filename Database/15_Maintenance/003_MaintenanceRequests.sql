USE TextileERP;
GO

CREATE TABLE maintenance.MaintenanceRequests
(
    RequestId           BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    RequestNumber       NVARCHAR(20) NOT NULL,
    MachineId           BIGINT NOT NULL,
    RequestDate         DATETIME NOT NULL DEFAULT GETDATE(),
    ReportedById        BIGINT NULL,
    FaultDescription    NVARCHAR(1000) NOT NULL,
    FaultCategory       NVARCHAR(50) NULL,       -- Mechanical, Electrical, Electronic, Other
    Priority            NVARCHAR(20) NOT NULL DEFAULT 'Medium', -- Low, Medium, High, Critical
    Status              NVARCHAR(20) NOT NULL DEFAULT 'Open',   -- Open, Assigned, InProgress, Completed, Cancelled
    AssignedToId        BIGINT NULL,
    AssignedTechnician  NVARCHAR(100) NULL,
    AssignedDate        DATETIME NULL,
    ExpectedCompletionDate DATETIME NULL,
    ActualCompletionDate   DATETIME NULL,
    WorkOrderId         BIGINT NULL,
    CompletionRemarks   NVARCHAR(500) NULL,
    EstimatedCost       DECIMAL(18,2) NULL,
    ActualCost          DECIMAL(18,2) NULL,
    IsEmergency         BIT NOT NULL DEFAULT 0,
    Photos              NVARCHAR(500) NULL,     -- comma separated paths
    Remarks             NVARCHAR(500) NULL,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME NULL,
    CONSTRAINT PK_MaintenanceRequests PRIMARY KEY (RequestId),
    CONSTRAINT UQ_RequestNumber UNIQUE (CompanyId, RequestNumber),
    CONSTRAINT FK_Request_Machine FOREIGN KEY (MachineId) REFERENCES maintenance.Machines(MachineId)
);
GO
