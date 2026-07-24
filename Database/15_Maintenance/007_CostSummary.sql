USE TextileERP;
GO

CREATE TABLE maintenance.CostSummary
(
    Id                  BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    MachineId           BIGINT NOT NULL,
    PeriodMonth         INT NOT NULL,
    PeriodYear          INT NOT NULL,
    TotalWorkOrders     INT NOT NULL DEFAULT 0,
    ReactiveWorkOrders  INT NOT NULL DEFAULT 0,
    PartsCost           DECIMAL(18,2) NOT NULL DEFAULT 0,
    LaborCost           DECIMAL(18,2) NOT NULL DEFAULT 0,
    OutsideCost         DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalCost           DECIMAL(18,2) NOT NULL DEFAULT 0,
    DowntimeHours       DECIMAL(10,2) NOT NULL DEFAULT 0,
    DowntimeCost        DECIMAL(18,2) NOT NULL DEFAULT 0,
    AverageRepairTime   DECIMAL(10,2) NOT NULL DEFAULT 0,
    MTBF_Hours          DECIMAL(10,2) NULL,    -- Mean Time Between Failures
    MTTR_Hours          DECIMAL(10,2) NULL,    -- Mean Time To Repair
    AvailabilityPercent DECIMAL(5,2) NULL,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME NULL,
    CONSTRAINT PK_CostSummary PRIMARY KEY (Id),
    CONSTRAINT UQ_CostSummary UNIQUE (CompanyId, MachineId, PeriodMonth, PeriodYear),
    CONSTRAINT FK_CostSummary_Machine FOREIGN KEY (MachineId) REFERENCES maintenance.Machines(MachineId)
);
GO
