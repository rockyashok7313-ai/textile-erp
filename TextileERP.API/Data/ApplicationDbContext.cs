using Microsoft.EntityFrameworkCore;
using TextileERP.API.Models.Master;
using TextileERP.API.Models.Inventory;
using TextileERP.API.Models.Purchase;
using TextileERP.API.Models.Sales;
using TextileERP.API.Models.Finance;
using TextileERP.API.Models.Tax;
using TextileERP.API.Models.Compliance;
using TextileERP.API.Models.Audit;
using TextileERP.API.Models.Payroll;
using TextileERP.API.Models.Maintenance;

namespace TextileERP.API.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
    {
    }

    #region Master Module
    public DbSet<Company> Companies => Set<Company>();
    public DbSet<User> Users => Set<User>();
    public DbSet<Item> Items => Set<Item>();
    public DbSet<ItemCategory> ItemCategories => Set<ItemCategory>();
    public DbSet<Party> Parties => Set<Party>();
    public DbSet<PartyAddress> PartyAddresses => Set<PartyAddress>();
    public DbSet<Unit> Units => Set<Unit>();
    public DbSet<UnitConversion> UnitConversions => Set<UnitConversion>();
    public DbSet<HSNMaster> HSNMaster => Set<HSNMaster>();
    public DbSet<GSTRate> GSTRates => Set<GSTRate>();
    public DbSet<StateMaster> StateMasters => Set<StateMaster>();
    public DbSet<Country> Countries => Set<Country>();
    public DbSet<LedgerGroup> LedgerGroups => Set<LedgerGroup>();
    public DbSet<Ledger> Ledgers => Set<Ledger>();
    public DbSet<Godown> Godowns => Set<Godown>();
    public DbSet<GodownLocation> GodownLocations => Set<GodownLocation>();
    public DbSet<Transporter> Transporters => Set<Transporter>();
    public DbSet<Vehicle> Vehicles => Set<Vehicle>();
    #endregion

    #region Inventory Module
    public DbSet<StockSummary> StockSummary => Set<StockSummary>();
    public DbSet<StockJournal> StockJournals => Set<StockJournal>();
    public DbSet<StockJournalDetail> StockJournalDetails => Set<StockJournalDetail>();
    #endregion

    #region Purchase Module
    public DbSet<PurchaseOrder> PurchaseOrders => Set<PurchaseOrder>();
    public DbSet<PurchaseOrderDetail> PurchaseOrderDetails => Set<PurchaseOrderDetail>();
    public DbSet<PurchaseInvoice> PurchaseInvoices => Set<PurchaseInvoice>();
    public DbSet<PurchaseInvoiceDetail> PurchaseInvoiceDetails => Set<PurchaseInvoiceDetail>();
    #endregion

    #region Sales Module
    public DbSet<SalesOrder> SalesOrders => Set<SalesOrder>();
    public DbSet<SalesOrderDetail> SalesOrderDetails => Set<SalesOrderDetail>();
    public DbSet<SalesInvoice> SalesInvoices => Set<SalesInvoice>();
    public DbSet<SalesInvoiceDetail> SalesInvoiceDetails => Set<SalesInvoiceDetail>();
    public DbSet<ProformaInvoice> ProformaInvoices => Set<ProformaInvoice>();
    public DbSet<ProformaInvoiceDetail> ProformaInvoiceDetails => Set<ProformaInvoiceDetail>();
    #endregion

    #region Tax Module
    public DbSet<GSTInvoice> GSTInvoices => Set<GSTInvoice>();
    public DbSet<GSTInvoiceDetail> GSTInvoiceDetails => Set<GSTInvoiceDetail>();
    public DbSet<TDSEntry> TDSEntries => Set<TDSEntry>();
    public DbSet<TCSEntry> TCSEntries => Set<TCSEntry>();
    #endregion

    #region Compliance Module
    public DbSet<EWayBill> EWayBills => Set<EWayBill>();
    public DbSet<EWayBillVehicle> EWayBillVehicles => Set<EWayBillVehicle>();
    public DbSet<EInvoice> EInvoices => Set<EInvoice>();
    public DbSet<EInvoiceDetail> EInvoiceDetails => Set<EInvoiceDetail>();
    public DbSet<DocumentSequence> DocumentSequences => Set<DocumentSequence>();
    #endregion

    #region Finance Module
    public DbSet<Voucher> Vouchers => Set<Voucher>();
    public DbSet<VoucherDetail> VoucherDetails => Set<VoucherDetail>();
    public DbSet<BankAccount> BankAccounts => Set<BankAccount>();
    public DbSet<BankTransaction> BankTransactions => Set<BankTransaction>();
    public DbSet<OutstandingReceivable> OutstandingReceivables => Set<OutstandingReceivable>();
    public DbSet<OutstandingPayable> OutstandingPayables => Set<OutstandingPayable>();
    #endregion

    #region Audit Module
    public DbSet<ActivityLog> ActivityLogs => Set<ActivityLog>();
    public DbSet<ErrorLog> ErrorLogs => Set<ErrorLog>();
    public DbSet<LoginHistory> LoginHistories => Set<LoginHistory>();
    #endregion

    #region Payroll Module
    public DbSet<Department> Departments => Set<Department>();
    public DbSet<Designation> Designations => Set<Designation>();
    public DbSet<Employee> Employees => Set<Employee>();
    public DbSet<LeaveType> LeaveTypes => Set<LeaveType>();
    public DbSet<LeaveBalance> LeaveBalances => Set<LeaveBalance>();
    public DbSet<Attendance> Attendances => Set<Attendance>();
    public DbSet<PayrollPeriod> PayrollPeriods => Set<PayrollPeriod>();
    public DbSet<PayrollHeader> PayrollHeaders => Set<PayrollHeader>();
    public DbSet<PayrollDetail> PayrollDetails => Set<PayrollDetail>();
    public DbSet<SalaryHead> SalaryHeads => Set<SalaryHead>();
    #endregion

    #region Maintenance Module
    public DbSet<Machine> Machines => Set<Machine>();
    public DbSet<SparePart> SpareParts => Set<SparePart>();
    public DbSet<MaintenanceRequest> MaintenanceRequests => Set<MaintenanceRequest>();
    public DbSet<WorkOrder> WorkOrders => Set<WorkOrder>();
    public DbSet<WorkOrderSparePart> WorkOrderSpareParts => Set<WorkOrderSparePart>();
    public DbSet<DowntimeLog> DowntimeLogs => Set<DowntimeLog>();
    public DbSet<CostSummary> CostSummaries => Set<CostSummary>();
    #endregion

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Apply configurations
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ApplicationDbContext).Assembly);
    }
}
