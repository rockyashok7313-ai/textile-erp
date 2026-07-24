USE TextileERP;
GO

CREATE TABLE maintenance.WorkOrders
(
    WorkOrderId         BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    WorkOrderNumber     NVARCHAR(20) NOT NULL,
    RequestId           BIGINT NULL,
    MachineId           BIGINT NOT NULL,
    WorkOrderType       NVARCHAR(20) NOT NULL DEFAULT 'Reactive', -- Reactive, Preventive, Emergency
    StartDate           DATETIME NOT NULL DEFAULT GETDATE(),
    EndDate             DATETIME NULL,
    TechnicianName      NVARCHAR(100) NULL,
    TechnicianId        BIGINT NULL,
    WorkDescription     NVARCHAR(1000) NULL,
    RootCause           NVARCHAR(500) NULL,
    ActionTaken         NVARCHAR(1000) NULL,
    Findings            NVARCHAR(500) NULL,
    Recommendations     NVARCHAR(500) NULL,
    TotalPartsCost      DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalLaborCost      DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalOutsideCost    DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCost           DECIMAL(18,2) NOT NULL DEFAULT 0,
    Status              NVARCHAR(20) NOT NULL DEFAULT 'Open', -- Open, InProgress, Completed, OnHold, Cancelled
    ApprovedBy          BIGINT NULL,
    ApprovedDate        DATETIME NULL,
    IsCompleted         BIT NOT NULL DEFAULT 0,
    DowntimeHours       DECIMAL(8,2) NOT NULL DEFAULT 0,
    Remarks             NVARCHAR(500) NULL,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME NULL,
    CONSTRAINT PK_WorkOrders PRIMARY KEY (WorkOrderId),
    CONSTRAINT UQ_WorkOrderNumber UNIQUE (CompanyId, WorkOrderNumber),
    CONSTRAINT FK_WorkOrder_Request FOREIGN KEY (RequestId) REFERENCES maintenance.MaintenanceRequests(RequestId),
    CONSTRAINT FK_WorkOrder_Machine FOREIGN KEY (MachineId) REFERENCES maintenance.Machines(MachineId)
);
GO
