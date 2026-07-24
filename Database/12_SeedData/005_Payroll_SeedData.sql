USE TextileERP;
GO

-- Default Departments
INSERT INTO payroll.Departments (CompanyId, DepartmentCode, DepartmentName, Description, IsActive)
VALUES (1, 'PROD', 'Production', 'Production and Manufacturing', 1),
       (1, 'MAIN', 'Maintenance', 'Machine Maintenance', 1),
       (1, 'QC', 'Quality Control', 'Quality Assurance and Control', 1),
       (1, 'STORE', 'Store', 'Inventory and Store', 1),
       (1, 'ADM', 'Administration', 'Administrative Department', 1),
       (1, 'FIN', 'Finance', 'Finance and Accounts', 1),
       (1, 'HR', 'Human Resources', 'HR Department', 1),
       (1, 'SALES', 'Sales', 'Sales and Marketing', 1);
GO

-- Default Designations
INSERT INTO payroll.Designations (CompanyId, DesignationCode, DesignationName, Description, IsActive)
VALUES (1, 'OPR', 'Operator', 'Loom Operator', 1),
       (1, 'SUPOP', 'Supervisor', 'Production Supervisor', 1),
       (1, 'MGR', 'Manager', 'Department Manager', 1),
       (1, 'TECH', 'Technician', 'Maintenance Technician', 1),
       (1, 'SRTECH', 'Sr. Technician', 'Senior Technician', 1),
       (1, 'QCINS', 'QC Inspector', 'Quality Inspector', 1),
       (1, 'WORK', 'Worker', 'General Worker', 1),
       (1, 'HELP', 'Helper', 'Helper', 1),
       (1, 'ACC', 'Accountant', 'Accountant', 1),
       (1, 'MGRMAIN', 'Maintenance Manager', 'Maintenance Manager', 1);
GO

-- Default Leave Types (Indian Standard)
INSERT INTO payroll.LeaveTypes (CompanyId, LeaveTypeCode, LeaveTypeName, DaysPerYear, IsCarryForward, MaxCarryForward, IsPaid, IsHalfDayAllowed, SortOrder)
VALUES (1, 'CL', 'Casual Leave', 12, 0, 0, 1, 1, 1),
       (1, 'SL', 'Sick Leave', 6, 1, 6, 1, 1, 2),
       (1, 'EL', 'Earned Leave', 15, 1, 30, 1, 1, 3),
       (1, 'ML', 'Maternity Leave', 182, 0, 0, 1, 0, 4),
       (1, 'PL', 'Paternity Leave', 5, 0, 0, 1, 0, 5),
       (1, 'WO', 'Weekly Off', 0, 0, 0, 1, 0, 6),
       (1, 'HOL', 'Holiday', 0, 0, 0, 1, 0, 7),
       (1, 'LOP', 'Loss of Pay', 0, 0, 0, 0, 1, 8);
GO

-- Default Salary Heads
INSERT INTO payroll.SalaryHeads (CompanyId, HeadCode, HeadName, HeadType, CalculationType, DefaultAmount, DefaultPercent, BasedOn, IsStatutory, StatutoryType, SortOrder)
VALUES 
-- Earnings
(1, 'BASIC', 'Basic Salary', 'Earning', 'Fixed', 0, 0, NULL, 0, NULL, 1),
(1, 'HRA', 'House Rent Allowance', 'Earning', 'Fixed', 0, 0, NULL, 0, NULL, 2),
(1, 'DA', 'Dearness Allowance', 'Earning', 'Fixed', 0, 0, NULL, 0, NULL, 3),
(1, 'CONV', 'Conveyance Allowance', 'Earning', 'Fixed', 0, 0, NULL, 0, NULL, 4),
(1, 'MED', 'Medical Allowance', 'Earning', 'Fixed', 0, 0, NULL, 0, NULL, 5),
(1, 'SPL', 'Special Allowance', 'Earning', 'Fixed', 0, 0, NULL, 0, NULL, 6),
(1, 'OT', 'Overtime', 'Earning', 'Fixed', 0, 0, NULL, 0, NULL, 7),
(1, 'BONUS', 'Bonus', 'Earning', 'Fixed', 0, 0, NULL, 0, NULL, 8),
-- Deductions
(1, 'PF_E', 'PF (Employee)', 'Deduction', 'Percentage', 0, 12, 'Basic', 1, 'PF', 20),
(1, 'ESI_E', 'ESI (Employee)', 'Deduction', 'Percentage', 0, 0.75, 'Gross', 1, 'ESI', 21),
(1, 'PT', 'Professional Tax', 'Deduction', 'Fixed', 200, 0, NULL, 1, 'PT', 22),
(1, 'TDS', 'TDS', 'Deduction', 'Fixed', 0, 0, NULL, 1, 'TDS', 23),
(1, 'PF_ER', 'PF (Employer)', 'Deduction', 'Percentage', 0, 12, 'Basic', 1, 'PF', 30),
(1, 'ESI_ER', 'ESI (Employer)', 'Deduction', 'Percentage', 0, 3.25, 'Gross', 1, 'ESI', 31);
GO

PRINT 'Payroll seed data inserted successfully.';
GO
