-- ============================================================================
-- TEXTILE ERP - MASTER EXECUTION SCRIPT
-- ============================================================================
-- Description: Execute all SQL scripts in order to create the complete database
-- Usage: Run this script in SQL Server Management Studio
-- ============================================================================

-- ============================================================================
-- STEP 1: CREATE DATABASE AND SCHEMAS
-- ============================================================================
PRINT 'Step 1: Creating Database and Schemas...';
GO

-- Uncomment the following to create a fresh database
-- :r 01_Schemas\001_Create_Database.sql
-- GO

:r 01_Schemas\002_Create_Schemas.sql
GO

-- ============================================================================
-- STEP 2: MASTER MODULE TABLES
-- ============================================================================
PRINT 'Step 2: Creating Master Module Tables...';
GO

:r 02_Master\001_Companies.sql
GO
:r 02_Master\002_Users.sql
GO
:r 02_Master\003_Roles.sql
GO
:r 02_Master\004_ItemCategories.sql
GO
:r 02_Master\005_Items.sql
GO
:r 02_Master\006_Parties.sql
GO
:r 02_Master\007_Units.sql
GO
:r 02_Master\008_HSNMaster.sql
GO
:r 02_Master\009_StateMasters.sql
GO
:r 02_Master\010_Ledgers.sql
GO
:r 02_Master\011_Godowns.sql
GO
:r 02_Master\012_Transporters.sql
GO

-- ============================================================================
-- STEP 3: INVENTORY MODULE TABLES
-- ============================================================================
PRINT 'Step 3: Creating Inventory Module Tables...';
GO

:r 03_Inventory\001_StockSummary.sql
GO
:r 03_Inventory\002_StockJournals.sql
GO
:r 03_Inventory\003_StockOpening.sql
GO
:r 03_Inventory\004_BatchStock.sql
GO
:r 03_Inventory\005_PhysicalStock.sql
GO

-- ============================================================================
-- STEP 4: PURCHASE MODULE TABLES
-- ============================================================================
PRINT 'Step 4: Creating Purchase Module Tables...';
GO

:r 04_Purchase\001_PurchaseOrders.sql
GO
:r 04_Purchase\002_PurchaseInvoices.sql
GO
:r 04_Purchase\003_PurchaseReturns.sql
GO
:r 04_Purchase\004_GRN.sql
GO

-- ============================================================================
-- STEP 5: SALES MODULE TABLES
-- ============================================================================
PRINT 'Step 5: Creating Sales Module Tables...';
GO

:r 05_Sales\001_SalesOrders.sql
GO
:r 05_Sales\002_ProformaInvoices.sql
GO
:r 05_Sales\003_SalesInvoices.sql
GO
:r 05_Sales\004_DeliveryChallans.sql
GO
:r 05_Sales\005_SalesReturns.sql
GO

-- ============================================================================
-- STEP 6: PRODUCTION MODULE TABLES
-- ============================================================================
PRINT 'Step 6: Creating Production Module Tables...';
GO

:r 06_Production\001_BOMHeaders.sql
GO
:r 06_Production\002_ProductionOrders.sql
GO
:r 06_Production\003_ProductionStages.sql
GO
:r 06_Production\004_ProductionConsumption.sql
GO
:r 06_Production\005_JobWork.sql
GO

-- ============================================================================
-- STEP 7: FINANCE MODULE TABLES
-- ============================================================================
PRINT 'Step 7: Creating Finance Module Tables...';
GO

:r 07_Finance\001_Vouchers.sql
GO
:r 07_Finance\002_BankAccounts.sql
GO
:r 07_Finance\003_Outstanding.sql
GO
:r 07_Finance\004_LedgerBalances.sql
GO

-- ============================================================================
-- STEP 8: TAX MODULE TABLES
-- ============================================================================
PRINT 'Step 8: Creating Tax Module Tables...';
GO

:r 08_Tax\001_GSTInvoices.sql
GO
:r 08_Tax\002_GSTReturns.sql
GO
:r 08_Tax\003_TDS_TCS.sql
GO

-- ============================================================================
-- STEP 9: COMPLIANCE MODULE TABLES
-- ============================================================================
PRINT 'Step 9: Creating Compliance Module Tables...';
GO

:r 09_Compliance\001_EWayBills.sql
GO
:r 09_Compliance\002_EInvoices.sql
GO
:r 09_Compliance\003_DocumentSequence.sql
GO

-- ============================================================================
-- STEP 10: AUDIT MODULE TABLES
-- ============================================================================
PRINT 'Step 10: Creating Audit Module Tables...';
GO

:r 10_Audit\001_AuditTables.sql
GO

-- ============================================================================
-- STEP 11: PAYROLL MODULE TABLES
-- ============================================================================
PRINT 'Step 11: Creating Payroll Module Tables...';
GO

:r 14_Payroll\001_Departments.sql
GO
:r 14_Payroll\002_Designations.sql
GO
:r 14_Payroll\003_Employees.sql
GO
:r 14_Payroll\004_LeaveTypes.sql
GO
:r 14_Payroll\005_LeaveBalance.sql
GO
:r 14_Payroll\006_Attendance.sql
GO
:r 14_Payroll\007_PayrollPeriods.sql
GO
:r 14_Payroll\008_Payroll.sql
GO
:r 14_Payroll\009_PayrollDetails.sql
GO
:r 14_Payroll\010_SalaryHeads.sql
GO

-- ============================================================================
-- STEP 12: MAINTENANCE MODULE TABLES
-- ============================================================================
PRINT 'Step 12: Creating Maintenance Module Tables...';
GO

:r 15_Maintenance\001_Machines.sql
GO
:r 15_Maintenance\002_SpareParts.sql
GO
:r 15_Maintenance\003_MaintenanceRequests.sql
GO
:r 15_Maintenance\004_WorkOrders.sql
GO
:r 15_Maintenance\005_WorkOrderSpareParts.sql
GO
:r 15_Maintenance\006_DowntimeLog.sql
GO
:r 15_Maintenance\007_CostSummary.sql
GO

-- ============================================================================
-- STEP 13: STORED PROCEDURES
-- ============================================================================
PRINT 'Step 13: Creating Stored Procedures...';
GO

:r 11_Procedures\001_Procedures.sql
GO

-- ============================================================================
-- STEP 14: SEED DATA
-- ============================================================================
PRINT 'Step 14: Inserting Seed Data...';
GO

:r 12_SeedData\001_IndianStates.sql
GO
:r 12_SeedData\002_HSNCodes_Textile.sql
GO
:r 12_SeedData\003_GSTRates.sql
GO
:r 12_SeedData\004_Units.sql
GO
:r 12_SeedData\005_Payroll_SeedData.sql
GO
:r 12_SeedData\006_Maintenance_SeedData.sql
GO

-- ============================================================================
-- STEP 15: PERFORMANCE INDEXES
-- ============================================================================
PRINT 'Step 15: Creating Performance Indexes...';
GO

:r 13_Indexes\001_Performance_Indexes.sql
GO

-- ============================================================================
-- COMPLETION
-- ============================================================================
PRINT '========================================';
PRINT 'Textile ERP Database Created Successfully!';
PRINT '========================================';
PRINT '';
PRINT 'Tables Created:';
PRINT '- Master Module: 15 tables';
PRINT '- Inventory Module: 8 tables';
PRINT '- Purchase Module: 7 tables';
PRINT '- Sales Module: 9 tables';
PRINT '- Production Module: 6 tables';
PRINT '- Finance Module: 10 tables';
PRINT '- Tax Module: 8 tables';
PRINT '- Compliance Module: 5 tables';
PRINT '- Audit Module: 4 tables';
PRINT '- Payroll Module: 10 tables';
PRINT '- Maintenance Module: 7 tables';
PRINT '';
PRINT 'Total Tables: 89';
PRINT '';
PRINT 'Stored Procedures: 12';
PRINT 'Seed Data: Indian States, HSN Codes, GST Rates, Units';
PRINT 'Performance Indexes: 100+';
PRINT '';
PRINT 'Next Steps:';
PRINT '1. Update CompanyId in Units seed data after creating your company';
PRINT '2. Create your first company using the Companies table';
PRINT '3. Create default user and roles';
PRINT '4. Configure ledger groups and ledgers';
PRINT '5. Setup departments and designations for payroll';
PRINT '6. Register machines (AirJet/Sulzer looms) for maintenance';
PRINT '';
GO
