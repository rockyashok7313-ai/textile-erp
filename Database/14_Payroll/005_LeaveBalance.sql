USE TextileERP;
GO

CREATE TABLE payroll.LeaveBalance
(
    Id             BIGINT IDENTITY(1,1) NOT NULL,
    EmployeeId     BIGINT NOT NULL,
    LeaveTypeId    BIGINT NOT NULL,
    LeaveYear      INT NOT NULL,
    TotalDays      DECIMAL(5,1) NOT NULL DEFAULT 0,
    UsedDays       DECIMAL(5,1) NOT NULL DEFAULT 0,
    BalanceDays    DECIMAL(5,1) NOT NULL DEFAULT 0,
    CarryForwardDays DECIMAL(5,1) NOT NULL DEFAULT 0,
    AdjustedDays   DECIMAL(5,1) NOT NULL DEFAULT 0,
    CreatedBy      BIGINT NULL,
    CreatedDate    DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy     BIGINT NULL,
    ModifiedDate   DATETIME NULL,
    CONSTRAINT PK_LeaveBalance PRIMARY KEY (Id),
    CONSTRAINT UQ_LeaveBalance UNIQUE (EmployeeId, LeaveTypeId, LeaveYear),
    CONSTRAINT FK_LeaveBalance_Employee FOREIGN KEY (EmployeeId) REFERENCES payroll.Employees(EmployeeId),
    CONSTRAINT FK_LeaveBalance_LeaveType FOREIGN KEY (LeaveTypeId) REFERENCES payroll.LeaveTypes(LeaveTypeId)
);
GO
