USE TextileERP;
GO

CREATE TABLE maintenance.WorkOrderSpareParts
(
    Id                  BIGINT IDENTITY(1,1) NOT NULL,
    WorkOrderId         BIGINT NOT NULL,
    SparePartId         BIGINT NOT NULL,
    QuantityUsed        DECIMAL(10,2) NOT NULL DEFAULT 0,
    UnitCost            DECIMAL(18,4) NOT NULL DEFAULT 0,
    TotalCost           DECIMAL(18,2) NOT NULL DEFAULT 0,
    IsReturned          BIT NOT NULL DEFAULT 0,
    ReturnQuantity      DECIMAL(10,2) NOT NULL DEFAULT 0,
    Remarks             NVARCHAR(200) NULL,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME NULL,
    CONSTRAINT PK_WorkOrderSpareParts PRIMARY KEY (Id),
    CONSTRAINT FK_WOSpareParts_WorkOrder FOREIGN KEY (WorkOrderId) REFERENCES maintenance.WorkOrders(WorkOrderId),
    CONSTRAINT FK_WOSpareParts_SparePart FOREIGN KEY (SparePartId) REFERENCES maintenance.SpareParts(SparePartId)
);
GO
