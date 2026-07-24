-- ============================================================================
-- TEXTILE ERP - PERFORMANCE INDEXES
-- ============================================================================

USE TextileERP;
GO

-- ============================================================================
-- MASTER MODULE INDEXES
-- ============================================================================

-- Companies
CREATE NONCLUSTERED INDEX IX_Companies_GSTIN ON master.Companies(GSTIN) WHERE GSTIN IS NOT NULL;
CREATE NONCLUSTERED INDEX IX_Companies_PAN ON master.Companies(PAN) WHERE PAN IS NOT NULL;

-- Users
CREATE NONCLUSTERED INDEX IX_Users_LoginId ON master.Users(LoginId);
CREATE NONCLUSTERED INDEX IX_Users_CompanyId ON master.Users(CompanyId);

-- Items
CREATE NONCLUSTERED INDEX IX_Items_CompanyId ON master.Items(CompanyId);
CREATE NONCLUSTERED INDEX IX_Items_HSNCode ON master.Items(HSNCode);
CREATE NONCLUSTERED INDEX IX_Items_CategoryId ON master.Items(CategoryId);
CREATE NONCLUSTERED INDEX IX_Items_Barcode ON master.Items(Barcode) WHERE Barcode IS NOT NULL;
CREATE NONCLUSTERED INDEX IX_Items_ItemName ON master.Items(ItemName);

-- Parties
CREATE NONCLUSTERED INDEX IX_Parties_CompanyId ON master.Parties(CompanyId);
CREATE NONCLUSTERED INDEX IX_Parties_GSTIN ON master.Parties(GSTIN) WHERE GSTIN IS NOT NULL;
CREATE NONCLUSTERED INDEX IX_Parties_PAN ON master.Parties(PAN) WHERE PAN IS NOT NULL;
CREATE NONCLUSTERED INDEX IX_Parties_PartyType ON master.Parties(PartyType);
CREATE NONCLUSTERED INDEX IX_Parties_PartyName ON master.Parties(PartyName);

-- HSN Master
CREATE NONCLUSTERED INDEX IX_HSNMaster_HSNCode ON master.HSNMaster(HSNCode);
CREATE NONCLUSTERED INDEX IX_HSNMaster_IsTextile ON master.HSNMaster(IsTextileHSN) WHERE IsTextileHSN = 1;

-- ============================================================================
-- INVENTORY MODULE INDEXES
-- ============================================================================

-- Stock Summary
CREATE NONCLUSTERED INDEX IX_StockSummary_CompanyId ON inventory.StockSummary(CompanyId);
CREATE NONCLUSTERED INDEX IX_StockSummary_ItemId ON inventory.StockSummary(ItemId);
CREATE NONCLUSTERED INDEX IX_StockSummary_GodownId ON inventory.StockSummary(GodownId);
CREATE NONCLUSTERED INDEX IX_StockSummary_CompanyItemGodown ON inventory.StockSummary(CompanyId, ItemId, GodownId);
CREATE NONCLUSTERED INDEX IX_StockSummary_BatchNumber ON inventory.StockSummary(BatchNumber) WHERE BatchNumber IS NOT NULL;

-- Stock Journals
CREATE NONCLUSTERED INDEX IX_StockJournals_CompanyId ON inventory.StockJournals(CompanyId);
CREATE NONCLUSTERED INDEX IX_StockJournals_JournalDate ON inventory.StockJournals(JournalDate);
CREATE NONCLUSTERED INDEX IX_StockJournals_JournalStatus ON inventory.StockJournals(JournalStatus);

-- Batch Stock
CREATE NONCLUSTERED INDEX IX_BatchStock_CompanyId ON inventory.BatchStock(CompanyId);
CREATE NONCLUSTERED INDEX IX_BatchStock_ItemId ON inventory.BatchStock(ItemId);
CREATE NONCLUSTERED INDEX IX_BatchStock_BatchNumber ON inventory.BatchStock(BatchNumber);
CREATE NONCLUSTERED INDEX IX_BatchStock_ExpiryDate ON inventory.BatchStock(ExpiryDate) WHERE ExpiryDate IS NOT NULL;

-- ============================================================================
-- PURCHASE MODULE INDEXES
-- ============================================================================

-- Purchase Orders
CREATE NONCLUSTERED INDEX IX_PurchaseOrders_CompanyId ON purchase.PurchaseOrders(CompanyId);
CREATE NONCLUSTERED INDEX IX_PurchaseOrders_SupplierId ON purchase.PurchaseOrders(SupplierId);
CREATE NONCLUSTERED INDEX IX_PurchaseOrders_OrderDate ON purchase.PurchaseOrders(OrderDate);
CREATE NONCLUSTERED INDEX IX_PurchaseOrders_OrderStatus ON purchase.PurchaseOrders(OrderStatus);

-- Purchase Invoices
CREATE NONCLUSTERED INDEX IX_PurchaseInvoices_CompanyId ON purchase.PurchaseInvoices(CompanyId);
CREATE NONCLUSTERED INDEX IX_PurchaseInvoices_SupplierId ON purchase.PurchaseInvoices(SupplierId);
CREATE NONCLUSTERED INDEX IX_PurchaseInvoices_InvoiceDate ON purchase.PurchaseInvoices(InvoiceDate);
CREATE NONCLUSTERED INDEX IX_PurchaseInvoices_InvoiceStatus ON purchase.PurchaseInvoices(InvoiceStatus);

-- ============================================================================
-- SALES MODULE INDEXES
-- ============================================================================

-- Sales Orders
CREATE NONCLUSTERED INDEX IX_SalesOrders_CompanyId ON sales.SalesOrders(CompanyId);
CREATE NONCLUSTERED INDEX IX_SalesOrders_CustomerId ON sales.SalesOrders(CustomerId);
CREATE NONCLUSTERED INDEX IX_SalesOrders_OrderDate ON sales.SalesOrders(OrderDate);
CREATE NONCLUSTERED INDEX IX_SalesOrders_OrderStatus ON sales.SalesOrders(OrderStatus);

-- Sales Invoices
CREATE NONCLUSTERED INDEX IX_SalesInvoices_CompanyId ON sales.SalesInvoices(CompanyId);
CREATE NONCLUSTERED INDEX IX_SalesInvoices_CustomerId ON sales.SalesInvoices(CustomerId);
CREATE NONCLUSTERED INDEX IX_SalesInvoices_InvoiceDate ON sales.SalesInvoices(InvoiceDate);
CREATE NONCLUSTERED INDEX IX_SalesInvoices_InvoiceStatus ON sales.SalesInvoices(InvoiceStatus);
CREATE NONCLUSTERED INDEX IX_SalesInvoices_EWayBillNumber ON sales.SalesInvoices(EWayBillNumber) WHERE EWayBillNumber IS NOT NULL;
CREATE NONCLUSTERED INDEX IX_SalesInvoices_IRN ON sales.SalesInvoices(IRN) WHERE IRN IS NOT NULL;

-- ============================================================================
-- FINANCE MODULE INDEXES
-- ============================================================================

-- Vouchers
CREATE NONCLUSTERED INDEX IX_Vouchers_CompanyId ON finance.Vouchers(CompanyId);
CREATE NONCLUSTERED INDEX IX_Vouchers_VoucherDate ON finance.Vouchers(VoucherDate);
CREATE NONCLUSTERED INDEX IX_Vouchers_VoucherType ON finance.Vouchers(VoucherType);
CREATE NONCLUSTERED INDEX IX_Vouchers_VoucherStatus ON finance.Vouchers(VoucherStatus);

-- Outstanding Receivable
CREATE NONCLUSTERED INDEX IX_OutstandingReceivable_CompanyId ON finance.OutstandingReceivable(CompanyId);
CREATE NONCLUSTERED INDEX IX_OutstandingReceivable_CustomerId ON finance.OutstandingReceivable(CustomerId);
CREATE NONCLUSTERED INDEX IX_OutstandingReceivable_DueDate ON finance.OutstandingReceivable(DueDate);
CREATE NONCLUSTERED INDEX IX_OutstandingReceivable_PaymentStatus ON finance.OutstandingReceivable(PaymentStatus);
CREATE NONCLUSTERED INDEX IX_OutstandingReceivable_AgingBucket ON finance.OutstandingReceivable(AgingBucket);

-- Outstanding Payable
CREATE NONCLUSTERED INDEX IX_OutstandingPayable_CompanyId ON finance.OutstandingPayable(CompanyId);
CREATE NONCLUSTERED INDEX IX_OutstandingPayable_SupplierId ON finance.OutstandingPayable(SupplierId);
CREATE NONCLUSTERED INDEX IX_OutstandingPayable_DueDate ON finance.OutstandingPayable(DueDate);
CREATE NONCLUSTERED INDEX IX_OutstandingPayable_PaymentStatus ON finance.OutstandingPayable(PaymentStatus);
CREATE NONCLUSTERED INDEX IX_OutstandingPayable_AgingBucket ON finance.OutstandingPayable(AgingBucket);

-- ============================================================================
-- TAX MODULE INDEXES
-- ============================================================================

-- GST Invoices
CREATE NONCLUSTERED INDEX IX_GSTInvoices_CompanyId ON tax.GSTInvoices(CompanyId);
CREATE NONCLUSTERED INDEX IX_GSTInvoices_InvoiceType ON tax.GSTInvoices(InvoiceType);
CREATE NONCLUSTERED INDEX IX_GSTInvoices_InvoiceDate ON tax.GSTInvoices(InvoiceDate);
CREATE NONCLUSTERED INDEX IX_GSTInvoices_PartyId ON tax.GSTInvoices(PartyId);
CREATE NONCLUSTERED INDEX IX_GSTInvoices_GSTR1Status ON tax.GSTInvoices(GSTR1Status);

-- TDS Entries
CREATE NONCLUSTERED INDEX IX_TDSEntries_CompanyId ON tax.TDSEntries(CompanyId);
CREATE NONCLUSTERED INDEX IX_TDSEntries_PartyId ON tax.TDSEntries(PartyId);
CREATE NONCLUSTERED INDEX IX_TDSEntries_TDSDate ON tax.TDSEntries(TDSDate);
CREATE NONCLUSTERED INDEX IX_TDSEntries_FinancialYear ON tax.TDSEntries(FinancialYear, Quarter);

-- TCS Entries
CREATE NONCLUSTERED INDEX IX_TCSEntries_CompanyId ON tax.TCSEntries(CompanyId);
CREATE NONCLUSTERED INDEX IX_TCSEntries_PartyId ON tax.TCSEntries(PartyId);
CREATE NONCLUSTERED INDEX IX_TCSEntries_TCSDate ON tax.TCSEntries(TCSDate);
CREATE NONCLUSTERED INDEX IX_TCSEntries_FinancialYear ON tax.TCSEntries(FinancialYear, Quarter);

-- ============================================================================
-- COMPLIANCE MODULE INDEXES
-- ============================================================================

-- E-Way Bills
CREATE NONCLUSTERED INDEX IX_EWayBills_CompanyId ON compliance.EWayBills(CompanyId);
CREATE NONCLUSTERED INDEX IX_EWayBills_EWayBillNumber ON compliance.EWayBills(EWayBillNumber) WHERE EWayBillNumber IS NOT NULL;
CREATE NONCLUSTERED INDEX IX_EWayBills_InvoiceId ON compliance.EWayBills(InvoiceId);
CREATE NONCLUSTERED INDEX IX_EWayBills_EWayBillStatus ON compliance.EWayBills(EWayBillStatus);
CREATE NONCLUSTERED INDEX IX_EWayBills_EWayBillDate ON compliance.EWayBills(EWayBillDate);

-- E-Invoices
CREATE NONCLUSTERED INDEX IX_EInvoices_CompanyId ON compliance.EInvoices(CompanyId);
CREATE NONCLUSTERED INDEX IX_EInvoices_IRN ON compliance.EInvoices(IRN) WHERE IRN IS NOT NULL;
CREATE NONCLUSTERED INDEX IX_EInvoices_InvoiceId ON compliance.EInvoices(InvoiceId);
CREATE NONCLUSTERED INDEX IX_EInvoices_EInvoiceStatus ON compliance.EInvoices(EInvoiceStatus);
CREATE NONCLUSTERED INDEX IX_EInvoices_AcknowledgementNumber ON compliance.EInvoices(AcknowledgementNumber) WHERE AcknowledgementNumber IS NOT NULL;

-- Document Sequence
CREATE NONCLUSTERED INDEX IX_DocumentSequence_CompanyId ON compliance.DocumentSequence(CompanyId);
CREATE NONCLUSTERED INDEX IX_DocumentSequence_DocumentType ON compliance.DocumentSequence(DocumentType);

-- ============================================================================
-- AUDIT MODULE INDEXES
-- ============================================================================

-- Activity Logs
CREATE NONCLUSTERED INDEX IX_ActivityLogs_CompanyId ON audit.ActivityLogs(CompanyId);
CREATE NONCLUSTERED INDEX IX_ActivityLogs_UserId ON audit.ActivityLogs(UserId);
CREATE NONCLUSTERED INDEX IX_ActivityLogs_ActivityDate ON audit.ActivityLogs(ActivityDate);
CREATE NONCLUSTERED INDEX IX_ActivityLogs_ActivityType ON audit.ActivityLogs(ActivityType);
CREATE NONCLUSTERED INDEX IX_ActivityLogs_ModuleName ON audit.ActivityLogs(ModuleName);

-- Data Changes
CREATE NONCLUSTERED INDEX IX_DataChanges_CompanyId ON audit.DataChanges(CompanyId);
CREATE NONCLUSTERED INDEX IX_DataChanges_UserId ON audit.DataChanges(UserId);
CREATE NONCLUSTERED INDEX IX_DataChanges_TableName ON audit.DataChanges(TableName);
CREATE NONCLUSTERED INDEX IX_DataChanges_RecordId ON audit.DataChanges(RecordId);
CREATE NONCLUSTERED INDEX IX_DataChanges_ChangedDate ON audit.DataChanges(ChangedDate);

-- Error Logs
CREATE NONCLUSTERED INDEX IX_ErrorLogs_CompanyId ON audit.ErrorLogs(CompanyId);
CREATE NONCLUSTERED INDEX IX_ErrorLogs_ErrorLevel ON audit.ErrorLogs(ErrorLevel);
CREATE NONCLUSTERED INDEX IX_ErrorLogs_ErrorDate ON audit.ErrorLogs(ErrorDate);
CREATE NONCLUSTERED INDEX IX_ErrorLogs_IsResolved ON audit.ErrorLogs(IsResolved);

-- Login History
CREATE NONCLUSTERED INDEX IX_LoginHistory_UserId ON audit.LoginHistory(UserId);
CREATE NONCLUSTERED INDEX IX_LoginHistory_CompanyId ON audit.LoginHistory(CompanyId);
CREATE NONCLUSTERED INDEX IX_LoginHistory_LoginDate ON audit.LoginHistory(LoginDate);
CREATE NONCLUSTERED INDEX IX_LoginHistory_LoginStatus ON audit.LoginHistory(LoginStatus);

-- ============================================================================
-- PAYROLL MODULE INDEXES
-- ============================================================================

-- Employees
CREATE NONCLUSTERED INDEX IX_Employees_CompanyId ON payroll.Employees(CompanyId);
CREATE NONCLUSTERED INDEX IX_Employees_DepartmentId ON payroll.Employees(DepartmentId);
CREATE NONCLUSTERED INDEX IX_Employees_DesignationId ON payroll.Employees(DesignationId);
CREATE NONCLUSTERED INDEX IX_Employees_IsActive ON payroll.Employees(IsActive);
CREATE NONCLUSTERED INDEX IX_Employees_PAN ON payroll.Employees(PAN) WHERE PAN IS NOT NULL;

-- Attendance
CREATE NONCLUSTERED INDEX IX_Attendance_EmployeeId ON payroll.Attendance(EmployeeId);
CREATE NONCLUSTERED INDEX IX_Attendance_CompanyId ON payroll.Attendance(CompanyId);
CREATE NONCLUSTERED INDEX IX_Attendance_Date ON payroll.Attendance(AttendanceDate);
CREATE NONCLUSTERED INDEX IX_Attendance_Status ON payroll.Attendance(Status);
CREATE NONCLUSTERED INDEX IX_Attendance_EmpDate ON payroll.Attendance(EmployeeId, AttendanceDate);

-- LeaveBalance
CREATE NONCLUSTERED INDEX IX_LeaveBalance_EmployeeId ON payroll.LeaveBalance(EmployeeId);
CREATE NONCLUSTERED INDEX IX_LeaveBalance_Year ON payroll.LeaveBalance(LeaveYear);

-- Payroll
CREATE NONCLUSTERED INDEX IX_Payroll_CompanyId ON payroll.Payroll(CompanyId);
CREATE NONCLUSTERED INDEX IX_Payroll_PeriodId ON payroll.Payroll(PeriodId);
CREATE NONCLUSTERED INDEX IX_Payroll_Status ON payroll.Payroll(Status);

-- PayrollDetails
CREATE NONCLUSTERED INDEX IX_PayrollDetails_PayrollId ON payroll.PayrollDetails(PayrollId);
CREATE NONCLUSTERED INDEX IX_PayrollDetails_EmployeeId ON payroll.PayrollDetails(EmployeeId);

-- ============================================================================
-- MAINTENANCE MODULE INDEXES
-- ============================================================================

-- Machines
CREATE NONCLUSTERED INDEX IX_Machines_CompanyId ON maintenance.Machines(CompanyId);
CREATE NONCLUSTERED INDEX IX_Machines_MachineType ON maintenance.Machines(MachineType);
CREATE NONCLUSTERED INDEX IX_Machines_Status ON maintenance.Machines(Status);
CREATE NONCLUSTERED INDEX IX_Machines_Location ON maintenance.Machines(Location);

-- SpareParts
CREATE NONCLUSTERED INDEX IX_SpareParts_CompanyId ON maintenance.SpareParts(CompanyId);
CREATE NONCLUSTERED INDEX IX_SpareParts_Category ON maintenance.SpareParts(Category);
CREATE NONCLUSTERED INDEX IX_SpareParts_IsCritical ON maintenance.SpareParts(IsCriticalSpare);
CREATE NONCLUSTERED INDEX IX_SpareParts_StockLevel ON maintenance.SpareParts(CurrentStock, ReorderLevel);

-- MaintenanceRequests
CREATE NONCLUSTERED INDEX IX_MaintenanceRequests_CompanyId ON maintenance.MaintenanceRequests(CompanyId);
CREATE NONCLUSTERED INDEX IX_MaintenanceRequests_MachineId ON maintenance.MaintenanceRequests(MachineId);
CREATE NONCLUSTERED INDEX IX_MaintenanceRequests_Status ON maintenance.MaintenanceRequests(Status);
CREATE NONCLUSTERED INDEX IX_MaintenanceRequests_Priority ON maintenance.MaintenanceRequests(Priority);
CREATE NONCLUSTERED INDEX IX_MaintenanceRequests_Date ON maintenance.MaintenanceRequests(RequestDate);

-- WorkOrders
CREATE NONCLUSTERED INDEX IX_WorkOrders_CompanyId ON maintenance.WorkOrders(CompanyId);
CREATE NONCLUSTERED INDEX IX_WorkOrders_MachineId ON maintenance.WorkOrders(MachineId);
CREATE NONCLUSTERED INDEX IX_WorkOrders_Status ON maintenance.WorkOrders(Status);
CREATE NONCLUSTERED INDEX IX_WorkOrders_RequestId ON maintenance.WorkOrders(RequestId);
CREATE NONCLUSTERED INDEX IX_WorkOrders_StartDate ON maintenance.WorkOrders(StartDate);

-- WorkOrderSpareParts
CREATE NONCLUSTERED INDEX IX_WOSpareParts_WorkOrderId ON maintenance.WorkOrderSpareParts(WorkOrderId);
CREATE NONCLUSTERED INDEX IX_WOSpareParts_SparePartId ON maintenance.WorkOrderSpareParts(SparePartId);

-- DowntimeLog
CREATE NONCLUSTERED INDEX IX_DowntimeLog_CompanyId ON maintenance.DowntimeLog(CompanyId);
CREATE NONCLUSTERED INDEX IX_DowntimeLog_MachineId ON maintenance.DowntimeLog(MachineId);
CREATE NONCLUSTERED INDEX IX_DowntimeLog_StartDate ON maintenance.DowntimeLog(StartDateTime);
CREATE NONCLUSTERED INDEX IX_DowntimeLog_Category ON maintenance.DowntimeLog(Category);

-- CostSummary
CREATE NONCLUSTERED INDEX IX_CostSummary_CompanyId ON maintenance.CostSummary(CompanyId);
CREATE NONCLUSTERED INDEX IX_CostSummary_MachineId ON maintenance.CostSummary(MachineId);
CREATE NONCLUSTERED INDEX IX_CostSummary_Period ON maintenance.CostSummary(PeriodYear, PeriodMonth);

PRINT 'All performance indexes created successfully.';
GO
