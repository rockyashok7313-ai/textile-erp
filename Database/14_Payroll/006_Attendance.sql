USE TextileERP;
GO

CREATE TABLE payroll.Attendance
(
    Id              BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId       BIGINT NOT NULL,
    EmployeeId      BIGINT NOT NULL,
    AttendanceDate  DATE NOT NULL,
    Status          NVARCHAR(20) NOT NULL DEFAULT 'Present', -- Present, Absent, HalfDay, Leave, Holiday, WeeklyOff
    HalfDayType     NVARCHAR(20) NULL,   -- FirstHalf, SecondHalf
    InTime          DATETIME NULL,
    OutTime         DATETIME NULL,
    TotalHours      DECIMAL(5,2) NULL,
    OvertimeHours   DECIMAL(5,2) NOT NULL DEFAULT 0,
    IsOvertimeApproved BIT NOT NULL DEFAULT 0,
    LeaveTypeId     BIGINT NULL,
    Remarks         NVARCHAR(200) NULL,
    CreatedBy       BIGINT NULL,
    CreatedDate     DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedBy      BIGINT NULL,
    ModifiedDate    DATETIME NULL,
    CONSTRAINT PK_Attendance PRIMARY KEY (Id),
    CONSTRAINT UQ_Attendance UNIQUE (EmployeeId, AttendanceDate),
    CONSTRAINT FK_Attendance_Employee FOREIGN KEY (EmployeeId) REFERENCES payroll.Employees(EmployeeId),
    CONSTRAINT FK_Attendance_LeaveType FOREIGN KEY (LeaveTypeId) REFERENCES payroll.LeaveTypes(LeaveTypeId)
);
GO
