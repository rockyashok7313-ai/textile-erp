USE TextileERP;
GO

CREATE TABLE maintenance.DowntimeLog
(
    DowntimeId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    MachineId           BIGINT NOT NULL,
    StartDateTime       DATETIME NOT NULL,
    EndDateTime         DATETIME NULL,
    DurationMinutes     DECIMAL(10,2) NOT NULL DEFAULT 0,
    Reason              NVARCHAR(500) NOT NULL,
    Category            NVARCHAR(30) NOT NULL DEFAULT 'Breakdown', -- Breakdown, Repair, Inspection, Setup, Idle
    IsPlanned           BIT NOT NULL DEFAULT 0,
    WorkOrderId         BIGINT NULL,
    RequestId           BIGINT NULL,
    ProductionLossMeters DECIMAL(10,2) NULL,
    ProductionLossPieces DECIMAL(10,2) NULL,
    EstimatedCostImpact DECIMAL(18,2) NULL,
    ReportedById        BIGINT NULL,
    Remarks             NVARCHAR(500) NULL,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME NULL,
    CONSTRAINT PK_DowntimeLog PRIMARY KEY (DowntimeId),
    CONSTRAINT FK_Downtime_Machine FOREIGN KEY (MachineId) REFERENCES maintenance.Machines(MachineId),
    CONSTRAINT FK_Downtime_WorkOrder FOREIGN KEY (WorkOrderId) REFERENCES maintenance.WorkOrders(WorkOrderId)
);
GO
