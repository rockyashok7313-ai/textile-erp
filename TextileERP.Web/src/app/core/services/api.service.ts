import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import {
  LoginRequest,
  LoginResponse,
  User,
  ChangePasswordRequest,
  Item,
  Party,
  SalesInvoice,
  SalesOrder,
  ProformaInvoice,
  PurchaseInvoice,
  PurchaseOrder,
  StockSummary,
  StockJournal,
  Employee,
  Attendance,
  PayrollHeader,
  LeaveType,
  LeaveBalance,
  Machine,
  SparePart,
  MaintenanceRequest,
  WorkOrder,
  DowntimeLog,
  EWayBill,
  GSTInvoice,
  TDSEntry,
  TCSEntry,
  EInvoice,
  DocumentSequence,
  BankAccount,
  BankTransaction,
  OutstandingReceivable,
  OutstandingPayable,
  Voucher,
  CostSummary,
  Transporter,
  Vehicle,
  Company,
  StateMaster,
  Country,
  Department,
  Designation,
  SalaryHead,
  PayrollPeriod,
  ItemCategory,
  Unit,
  HSNMaster,
  GSTRate,
  Godown,
  GodownLocation,
  PartyAddress,
  LedgerGroup,
  Ledger,
  SalesInvoiceDetail,
  SalesOrderDetail,
  ProformaInvoiceDetail,
  PurchaseInvoiceDetail,
  PurchaseOrderDetail,
  GSTInvoiceDetail,
  EInvoiceDetail,
  EWayBillVehicle,
  StockJournalDetail,
  VoucherDetail,
  WorkOrderSparePart,
} from '../models';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private readonly http = inject(HttpClient);

  private readonly API_URL = environment.apiUrl;

  private get<T>(path: string, params?: HttpParams): Observable<T> {
    return this.http.get<T>(`${this.API_URL}${path}`, { params });
  }

  private post<T>(path: string, body: unknown = {}): Observable<T> {
    return this.http.post<T>(`${this.API_URL}${path}`, body);
  }

  private put<T>(path: string, body: unknown = {}): Observable<T> {
    return this.http.put<T>(`${this.API_URL}${path}`, body);
  }

  private delete<T>(path: string): Observable<T> {
    return this.http.delete<T>(`${this.API_URL}${path}`);
  }

  // ============================================================
  // AUTH
  // ============================================================

  login(request: LoginRequest): Observable<LoginResponse> {
    return this.post<LoginResponse>('/auth/login', request);
  }

  refreshToken(refreshToken: string): Observable<LoginResponse> {
    return this.post<LoginResponse>('/auth/refresh', { refreshToken });
  }

  getCurrentUser(): Observable<User> {
    return this.get<User>('/auth/me');
  }

  changePassword(request: ChangePasswordRequest): Observable<void> {
    return this.post<void>('/auth/changepassword', request);
  }

  // ============================================================
  // COMPANIES
  // ============================================================

  getAllCompanies(): Observable<Company[]> {
    return this.get<Company[]>('/companies');
  }

  getCompanyById(id: number): Observable<Company> {
    return this.get<Company>(`/companies/${id}`);
  }

  createCompany(company: Partial<Company>): Observable<Company> {
    return this.post<Company>('/companies', company);
  }

  updateCompany(id: number, company: Partial<Company>): Observable<Company> {
    return this.put<Company>(`/companies/${id}`, company);
  }

  // ============================================================
  // MASTER DATA - States, Countries
  // ============================================================

  getAllStates(): Observable<StateMaster[]> {
    return this.get<StateMaster[]>('/states');
  }

  getStateById(id: number): Observable<StateMaster> {
    return this.get<StateMaster>(`/states/${id}`);
  }

  getAllCountries(): Observable<Country[]> {
    return this.get<Country[]>('/countries');
  }

  getCountryById(id: number): Observable<Country> {
    return this.get<Country>(`/countries/${id}`);
  }

  // ============================================================
  // MASTER DATA - Items
  // ============================================================

  getAllItems(): Observable<Item[]> {
    return this.get<Item[]>('/items');
  }

  getItemById(id: number): Observable<Item> {
    return this.get<Item>(`/items/${id}`);
  }

  getItemByCode(code: string): Observable<Item> {
    return this.get<Item>(`/items/code/${code}`);
  }

  getItemByBarcode(barcode: string): Observable<Item> {
    return this.get<Item>(`/items/barcode/${barcode}`);
  }

  getItemsByCategory(categoryId: number): Observable<Item[]> {
    return this.get<Item[]>(`/items/category/${categoryId}`);
  }

  getTextileItems(): Observable<Item[]> {
    return this.get<Item[]>('/items/textile');
  }

  getLowStockItems(): Observable<Item[]> {
    return this.get<Item[]>('/items/lowstock');
  }

  createItem(item: Partial<Item>): Observable<Item> {
    return this.post<Item>('/items', item);
  }

  updateItem(id: number, item: Partial<Item>): Observable<Item> {
    return this.put<Item>(`/items/${id}`, item);
  }

  deleteItem(id: number): Observable<void> {
    return this.delete<void>(`/items/${id}`);
  }

  // ============================================================
  // MASTER DATA - Item Categories
  // ============================================================

  getAllItemCategories(): Observable<ItemCategory[]> {
    return this.get<ItemCategory[]>('/itemcategories');
  }

  getItemCategoryById(id: number): Observable<ItemCategory> {
    return this.get<ItemCategory>(`/itemcategories/${id}`);
  }

  createItemCategory(category: Partial<ItemCategory>): Observable<ItemCategory> {
    return this.post<ItemCategory>('/itemcategories', category);
  }

  updateItemCategory(id: number, category: Partial<ItemCategory>): Observable<ItemCategory> {
    return this.put<ItemCategory>(`/itemcategories/${id}`, category);
  }

  deleteItemCategory(id: number): Observable<void> {
    return this.delete<void>(`/itemcategories/${id}`);
  }

  // ============================================================
  // MASTER DATA - Units
  // ============================================================

  getAllUnits(): Observable<Unit[]> {
    return this.get<Unit[]>('/units');
  }

  getUnitById(id: number): Observable<Unit> {
    return this.get<Unit>(`/units/${id}`);
  }

  createUnit(unit: Partial<Unit>): Observable<Unit> {
    return this.post<Unit>('/units', unit);
  }

  updateUnit(id: number, unit: Partial<Unit>): Observable<Unit> {
    return this.put<Unit>(`/units/${id}`, unit);
  }

  deleteUnit(id: number): Observable<void> {
    return this.delete<void>(`/units/${id}`);
  }

  // ============================================================
  // MASTER DATA - HSN
  // ============================================================

  getAllHSN(): Observable<HSNMaster[]> {
    return this.get<HSNMaster[]>('/hsn');
  }

  getHSNById(id: number): Observable<HSNMaster> {
    return this.get<HSNMaster>(`/hsn/${id}`);
  }

  createHSN(hsn: Partial<HSNMaster>): Observable<HSNMaster> {
    return this.post<HSNMaster>('/hsn', hsn);
  }

  updateHSN(id: number, hsn: Partial<HSNMaster>): Observable<HSNMaster> {
    return this.put<HSNMaster>(`/hsn/${id}`, hsn);
  }

  deleteHSN(id: number): Observable<void> {
    return this.delete<void>(`/hsn/${id}`);
  }

  // ============================================================
  // MASTER DATA - GST Rates
  // ============================================================

  getAllGSTRates(): Observable<GSTRate[]> {
    return this.get<GSTRate[]>('/gstrates');
  }

  getGSTRateById(id: number): Observable<GSTRate> {
    return this.get<GSTRate>(`/gstrates/${id}`);
  }

  createGSTRate(rate: Partial<GSTRate>): Observable<GSTRate> {
    return this.post<GSTRate>('/gstrates', rate);
  }

  updateGSTRate(id: number, rate: Partial<GSTRate>): Observable<GSTRate> {
    return this.put<GSTRate>(`/gstrates/${id}`, rate);
  }

  deleteGSTRate(id: number): Observable<void> {
    return this.delete<void>(`/gstrates/${id}`);
  }

  // ============================================================
  // MASTER DATA - Godowns
  // ============================================================

  getAllGodowns(): Observable<Godown[]> {
    return this.get<Godown[]>('/godowns');
  }

  getGodownById(id: number): Observable<Godown> {
    return this.get<Godown>(`/godowns/${id}`);
  }

  createGodown(godown: Partial<Godown>): Observable<Godown> {
    return this.post<Godown>('/godowns', godown);
  }

  updateGodown(id: number, godown: Partial<Godown>): Observable<Godown> {
    return this.put<Godown>(`/godowns/${id}`, godown);
  }

  deleteGodown(id: number): Observable<void> {
    return this.delete<void>(`/godowns/${id}`);
  }

  getAllGodownLocations(godownId?: number): Observable<GodownLocation[]> {
    const path = godownId ? `/godowns/${godownId}/locations` : '/godownlocations';
    return this.get<GodownLocation[]>(path);
  }

  createGodownLocation(location: Partial<GodownLocation>): Observable<GodownLocation> {
    return this.post<GodownLocation>('/godownlocations', location);
  }

  updateGodownLocation(id: number, location: Partial<GodownLocation>): Observable<GodownLocation> {
    return this.put<GodownLocation>(`/godownlocations/${id}`, location);
  }

  deleteGodownLocation(id: number): Observable<void> {
    return this.delete<void>(`/godownlocations/${id}`);
  }

  // ============================================================
  // PARTIES
  // ============================================================

  getAllParties(): Observable<Party[]> {
    return this.get<Party[]>('/parties');
  }

  getPartyById(id: number): Observable<Party> {
    return this.get<Party>(`/parties/${id}`);
  }

  getPartyByCode(code: string): Observable<Party> {
    return this.get<Party>(`/parties/code/${code}`);
  }

  getPartyByGSTIN(gstin: string): Observable<Party> {
    return this.get<Party>(`/parties/gstin/${gstin}`);
  }

  getCustomers(): Observable<Party[]> {
    return this.get<Party[]>('/parties/customers');
  }

  getSuppliers(): Observable<Party[]> {
    return this.get<Party[]>('/parties/suppliers');
  }

  createParty(party: Partial<Party>): Observable<Party> {
    return this.post<Party>('/parties', party);
  }

  updateParty(id: number, party: Partial<Party>): Observable<Party> {
    return this.put<Party>(`/parties/${id}`, party);
  }

  deleteParty(id: number): Observable<void> {
    return this.delete<void>(`/parties/${id}`);
  }

  getPartyAddresses(partyId: number): Observable<PartyAddress[]> {
    return this.get<PartyAddress[]>(`/parties/${partyId}/addresses`);
  }

  createPartyAddress(partyId: number, address: Partial<PartyAddress>): Observable<PartyAddress> {
    return this.post<PartyAddress>(`/parties/${partyId}/addresses`, address);
  }

  updatePartyAddress(partyId: number, addressId: number, address: Partial<PartyAddress>): Observable<PartyAddress> {
    return this.put<PartyAddress>(`/parties/${partyId}/addresses/${addressId}`, address);
  }

  deletePartyAddress(partyId: number, addressId: number): Observable<void> {
    return this.delete<void>(`/parties/${partyId}/addresses/${addressId}`);
  }

  // ============================================================
  // SALES INVOICES
  // ============================================================

  getAllSalesInvoices(): Observable<SalesInvoice[]> {
    return this.get<SalesInvoice[]>('/salesinvoices');
  }

  getSalesInvoiceById(id: number): Observable<SalesInvoice> {
    return this.get<SalesInvoice>(`/salesinvoices/${id}`);
  }

  getSalesInvoiceByNumber(number: string): Observable<SalesInvoice> {
    return this.get<SalesInvoice>(`/salesinvoices/number/${number}`);
  }

  getSalesInvoicesByCustomer(customerId: number): Observable<SalesInvoice[]> {
    return this.get<SalesInvoice[]>(`/salesinvoices/customer/${customerId}`);
  }

  createSalesInvoice(invoice: Partial<SalesInvoice>): Observable<SalesInvoice> {
    return this.post<SalesInvoice>('/salesinvoices', invoice);
  }

  updateSalesInvoice(id: number, invoice: Partial<SalesInvoice>): Observable<SalesInvoice> {
    return this.put<SalesInvoice>(`/salesinvoices/${id}`, invoice);
  }

  deleteSalesInvoice(id: number): Observable<void> {
    return this.delete<void>(`/salesinvoices/${id}`);
  }

  postSalesInvoice(id: number): Observable<SalesInvoice> {
    return this.post<SalesInvoice>(`/salesinvoices/${id}/post`);
  }

  getSalesInvoiceDetails(invoiceId: number): Observable<SalesInvoiceDetail[]> {
    return this.get<SalesInvoiceDetail[]>(`/salesinvoices/${invoiceId}/details`);
  }

  // ============================================================
  // SALES ORDERS
  // ============================================================

  getAllSalesOrders(): Observable<SalesOrder[]> {
    return this.get<SalesOrder[]>('/salesorders');
  }

  getSalesOrderById(id: number): Observable<SalesOrder> {
    return this.get<SalesOrder>(`/salesorders/${id}`);
  }

  getSalesOrderByNumber(number: string): Observable<SalesOrder> {
    return this.get<SalesOrder>(`/salesorders/number/${number}`);
  }

  getSalesOrdersByCustomer(customerId: number): Observable<SalesOrder[]> {
    return this.get<SalesOrder[]>(`/salesorders/customer/${customerId}`);
  }

  createSalesOrder(order: Partial<SalesOrder>): Observable<SalesOrder> {
    return this.post<SalesOrder>('/salesorders', order);
  }

  updateSalesOrder(id: number, order: Partial<SalesOrder>): Observable<SalesOrder> {
    return this.put<SalesOrder>(`/salesorders/${id}`, order);
  }

  deleteSalesOrder(id: number): Observable<void> {
    return this.delete<void>(`/salesorders/${id}`);
  }

  getSalesOrderDetails(orderId: number): Observable<SalesOrderDetail[]> {
    return this.get<SalesOrderDetail[]>(`/salesorders/${orderId}/details`);
  }

  // ============================================================
  // PROFORMA INVOICES
  // ============================================================

  getAllProformaInvoices(): Observable<ProformaInvoice[]> {
    return this.get<ProformaInvoice[]>('/proformainvoices');
  }

  getProformaInvoiceById(id: number): Observable<ProformaInvoice> {
    return this.get<ProformaInvoice>(`/proformainvoices/${id}`);
  }

  getProformaInvoiceByNumber(number: string): Observable<ProformaInvoice> {
    return this.get<ProformaInvoice>(`/proformainvoices/number/${number}`);
  }

  createProformaInvoice(invoice: Partial<ProformaInvoice>): Observable<ProformaInvoice> {
    return this.post<ProformaInvoice>('/proformainvoices', invoice);
  }

  updateProformaInvoice(id: number, invoice: Partial<ProformaInvoice>): Observable<ProformaInvoice> {
    return this.put<ProformaInvoice>(`/proformainvoices/${id}`, invoice);
  }

  deleteProformaInvoice(id: number): Observable<void> {
    return this.delete<void>(`/proformainvoices/${id}`);
  }

  getProformaInvoiceDetails(invoiceId: number): Observable<ProformaInvoiceDetail[]> {
    return this.get<ProformaInvoiceDetail[]>(`/proformainvoices/${invoiceId}/details`);
  }

  // ============================================================
  // PURCHASE INVOICES
  // ============================================================

  getAllPurchaseInvoices(): Observable<PurchaseInvoice[]> {
    return this.get<PurchaseInvoice[]>('/purchaseinvoices');
  }

  getPurchaseInvoiceById(id: number): Observable<PurchaseInvoice> {
    return this.get<PurchaseInvoice>(`/purchaseinvoices/${id}`);
  }

  getPurchaseInvoiceByNumber(number: string): Observable<PurchaseInvoice> {
    return this.get<PurchaseInvoice>(`/purchaseinvoices/number/${number}`);
  }

  getPurchaseInvoicesBySupplier(supplierId: number): Observable<PurchaseInvoice[]> {
    return this.get<PurchaseInvoice[]>(`/purchaseinvoices/supplier/${supplierId}`);
  }

  createPurchaseInvoice(invoice: Partial<PurchaseInvoice>): Observable<PurchaseInvoice> {
    return this.post<PurchaseInvoice>('/purchaseinvoices', invoice);
  }

  updatePurchaseInvoice(id: number, invoice: Partial<PurchaseInvoice>): Observable<PurchaseInvoice> {
    return this.put<PurchaseInvoice>(`/purchaseinvoices/${id}`, invoice);
  }

  deletePurchaseInvoice(id: number): Observable<void> {
    return this.delete<void>(`/purchaseinvoices/${id}`);
  }

  postPurchaseInvoice(id: number): Observable<PurchaseInvoice> {
    return this.post<PurchaseInvoice>(`/purchaseinvoices/${id}/post`);
  }

  getPurchaseInvoiceDetails(invoiceId: number): Observable<PurchaseInvoiceDetail[]> {
    return this.get<PurchaseInvoiceDetail[]>(`/purchaseinvoices/${invoiceId}/details`);
  }

  // ============================================================
  // PURCHASE ORDERS
  // ============================================================

  getAllPurchaseOrders(): Observable<PurchaseOrder[]> {
    return this.get<PurchaseOrder[]>('/purchaseorders');
  }

  getPurchaseOrderById(id: number): Observable<PurchaseOrder> {
    return this.get<PurchaseOrder>(`/purchaseorders/${id}`);
  }

  getPurchaseOrderByNumber(number: string): Observable<PurchaseOrder> {
    return this.get<PurchaseOrder>(`/purchaseorders/number/${number}`);
  }

  getPurchaseOrdersBySupplier(supplierId: number): Observable<PurchaseOrder[]> {
    return this.get<PurchaseOrder[]>(`/purchaseorders/supplier/${supplierId}`);
  }

  createPurchaseOrder(order: Partial<PurchaseOrder>): Observable<PurchaseOrder> {
    return this.post<PurchaseOrder>('/purchaseorders', order);
  }

  updatePurchaseOrder(id: number, order: Partial<PurchaseOrder>): Observable<PurchaseOrder> {
    return this.put<PurchaseOrder>(`/purchaseorders/${id}`, order);
  }

  deletePurchaseOrder(id: number): Observable<void> {
    return this.delete<void>(`/purchaseorders/${id}`);
  }

  getPurchaseOrderDetails(orderId: number): Observable<PurchaseOrderDetail[]> {
    return this.get<PurchaseOrderDetail[]>(`/purchaseorders/${orderId}/details`);
  }

  // ============================================================
  // GST INVOICES
  // ============================================================

  getAllGSTInvoices(): Observable<GSTInvoice[]> {
    return this.get<GSTInvoice[]>('/gstinvoices');
  }

  getGSTInvoiceById(id: number): Observable<GSTInvoice> {
    return this.get<GSTInvoice>(`/gstinvoices/${id}`);
  }

  getGSTInvoiceByNumber(number: string): Observable<GSTInvoice> {
    return this.get<GSTInvoice>(`/gstinvoices/number/${number}`);
  }

  createGSTInvoice(invoice: Partial<GSTInvoice>): Observable<GSTInvoice> {
    return this.post<GSTInvoice>('/gstinvoices', invoice);
  }

  updateGSTInvoice(id: number, invoice: Partial<GSTInvoice>): Observable<GSTInvoice> {
    return this.put<GSTInvoice>(`/gstinvoices/${id}`, invoice);
  }

  deleteGSTInvoice(id: number): Observable<void> {
    return this.delete<void>(`/gstinvoices/${id}`);
  }

  getGSTInvoiceDetails(invoiceId: number): Observable<GSTInvoiceDetail[]> {
    return this.get<GSTInvoiceDetail[]>(`/gstinvoices/${invoiceId}/details`);
  }

  // ============================================================
  // TDS / TCS
  // ============================================================

  getAllTDSEntries(): Observable<TDSEntry[]> {
    return this.get<TDSEntry[]>('/tds');
  }

  getTDSEntryById(id: number): Observable<TDSEntry> {
    return this.get<TDSEntry>(`/tds/${id}`);
  }

  getTDSEntriesByParty(partyId: number): Observable<TDSEntry[]> {
    return this.get<TDSEntry[]>(`/tds/party/${partyId}`);
  }

  createTDSEntry(entry: Partial<TDSEntry>): Observable<TDSEntry> {
    return this.post<TDSEntry>('/tds', entry);
  }

  updateTDSEntry(id: number, entry: Partial<TDSEntry>): Observable<TDSEntry> {
    return this.put<TDSEntry>(`/tds/${id}`, entry);
  }

  deleteTDSEntry(id: number): Observable<void> {
    return this.delete<void>(`/tds/${id}`);
  }

  getAllTCSEntries(): Observable<TCSEntry[]> {
    return this.get<TCSEntry[]>('/tcs');
  }

  getTCSEntryById(id: number): Observable<TCSEntry> {
    return this.get<TCSEntry>(`/tcs/${id}`);
  }

  getTCSEntriesByParty(partyId: number): Observable<TCSEntry[]> {
    return this.get<TCSEntry[]>(`/tcs/party/${partyId}`);
  }

  createTCSEntry(entry: Partial<TCSEntry>): Observable<TCSEntry> {
    return this.post<TCSEntry>('/tcs', entry);
  }

  updateTCSEntry(id: number, entry: Partial<TCSEntry>): Observable<TCSEntry> {
    return this.put<TCSEntry>(`/tcs/${id}`, entry);
  }

  deleteTCSEntry(id: number): Observable<void> {
    return this.delete<void>(`/tcs/${id}`);
  }

  // ============================================================
  // E-WAY BILL
  // ============================================================

  getAllEWayBills(): Observable<EWayBill[]> {
    return this.get<EWayBill[]>('/ewaybills');
  }

  getEWayBillById(id: number): Observable<EWayBill> {
    return this.get<EWayBill>(`/ewaybills/${id}`);
  }

  getEWayBillByNumber(number: string): Observable<EWayBill> {
    return this.get<EWayBill>(`/ewaybills/number/${number}`);
  }

  createEWayBill(ewayBill: Partial<EWayBill>): Observable<EWayBill> {
    return this.post<EWayBill>('/ewaybills', ewayBill);
  }

  updateEWayBill(id: number, ewayBill: Partial<EWayBill>): Observable<EWayBill> {
    return this.put<EWayBill>(`/ewaybills/${id}`, ewayBill);
  }

  deleteEWayBill(id: number): Observable<void> {
    return this.delete<void>(`/ewaybills/${id}`);
  }

  cancelEWayBill(id: number, reason: string): Observable<EWayBill> {
    return this.post<EWayBill>(`/ewaybills/${id}/cancel`, { reason });
  }

  getEWayBillVehicles(ewayBillId: number): Observable<EWayBillVehicle[]> {
    return this.get<EWayBillVehicle[]>(`/ewaybills/${ewayBillId}/vehicles`);
  }

  addEWayBillVehicle(ewayBillId: number, vehicle: Partial<EWayBillVehicle>): Observable<EWayBillVehicle> {
    return this.post<EWayBillVehicle>(`/ewaybills/${ewayBillId}/vehicles`, vehicle);
  }

  // ============================================================
  // E-INVOICE
  // ============================================================

  getAllEInvoices(): Observable<EInvoice[]> {
    return this.get<EInvoice[]>('/einvoices');
  }

  getEInvoiceById(id: number): Observable<EInvoice> {
    return this.get<EInvoice>(`/einvoices/${id}`);
  }

  getEInvoiceByIRN(irn: string): Observable<EInvoice> {
    return this.get<EInvoice>(`/einvoices/irn/${irn}`);
  }

  createEInvoice(invoice: Partial<EInvoice>): Observable<EInvoice> {
    return this.post<EInvoice>('/einvoices', invoice);
  }

  cancelEInvoice(id: number, reason: string): Observable<EInvoice> {
    return this.post<EInvoice>(`/einvoices/${id}/cancel`, { reason });
  }

  getEInvoiceDetails(invoiceId: number): Observable<EInvoiceDetail[]> {
    return this.get<EInvoiceDetail[]>(`/einvoices/${invoiceId}/details`);
  }

  // ============================================================
  // DOCUMENT SEQUENCES
  // ============================================================

  getAllDocumentSequences(): Observable<DocumentSequence[]> {
    return this.get<DocumentSequence[]>('/documentsequences');
  }

  getDocumentSequenceById(id: number): Observable<DocumentSequence> {
    return this.get<DocumentSequence>(`/documentsequences/${id}`);
  }

  getDocumentSequenceByType(type: string): Observable<DocumentSequence> {
    return this.get<DocumentSequence>(`/documentsequences/type/${type}`);
  }

  createDocumentSequence(seq: Partial<DocumentSequence>): Observable<DocumentSequence> {
    return this.post<DocumentSequence>('/documentsequences', seq);
  }

  updateDocumentSequence(id: number, seq: Partial<DocumentSequence>): Observable<DocumentSequence> {
    return this.put<DocumentSequence>(`/documentsequences/${id}`, seq);
  }

  deleteDocumentSequence(id: number): Observable<void> {
    return this.delete<void>(`/documentsequences/${id}`);
  }

  // ============================================================
  // STOCK
  // ============================================================

  getAllStock(): Observable<StockSummary[]> {
    return this.get<StockSummary[]>('/stock');
  }

  getStockById(id: number): Observable<StockSummary> {
    return this.get<StockSummary>(`/stock/${id}`);
  }

  getStockByItem(itemId: number): Observable<StockSummary[]> {
    return this.get<StockSummary[]>(`/stock/item/${itemId}`);
  }

  getLowStockSummary(): Observable<StockSummary[]> {
    return this.get<StockSummary[]>('/stock/lowstock');
  }

  updateStock(id: number, stock: Partial<StockSummary>): Observable<StockSummary> {
    return this.put<StockSummary>(`/stock/${id}`, stock);
  }

  // ============================================================
  // STOCK JOURNALS
  // ============================================================

  getAllStockJournals(): Observable<StockJournal[]> {
    return this.get<StockJournal[]>('/stockjournals');
  }

  getStockJournalById(id: number): Observable<StockJournal> {
    return this.get<StockJournal>(`/stockjournals/${id}`);
  }

  createStockJournal(journal: Partial<StockJournal>): Observable<StockJournal> {
    return this.post<StockJournal>('/stockjournals', journal);
  }

  updateStockJournal(id: number, journal: Partial<StockJournal>): Observable<StockJournal> {
    return this.put<StockJournal>(`/stockjournals/${id}`, journal);
  }

  deleteStockJournal(id: number): Observable<void> {
    return this.delete<void>(`/stockjournals/${id}`);
  }

  getStockJournalDetails(journalId: number): Observable<StockJournalDetail[]> {
    return this.get<StockJournalDetail[]>(`/stockjournals/${journalId}/details`);
  }

  // ============================================================
  // VOUCHERS
  // ============================================================

  getAllVouchers(): Observable<Voucher[]> {
    return this.get<Voucher[]>('/vouchers');
  }

  getVoucherById(id: number): Observable<Voucher> {
    return this.get<Voucher>(`/vouchers/${id}`);
  }

  getVouchersByType(type: string): Observable<Voucher[]> {
    return this.get<Voucher[]>(`/vouchers/type/${type}`);
  }

  createVoucher(voucher: Partial<Voucher>): Observable<Voucher> {
    return this.post<Voucher>('/vouchers', voucher);
  }

  updateVoucher(id: number, voucher: Partial<Voucher>): Observable<Voucher> {
    return this.put<Voucher>(`/vouchers/${id}`, voucher);
  }

  deleteVoucher(id: number): Observable<void> {
    return this.delete<void>(`/vouchers/${id}`);
  }

  getVoucherDetails(voucherId: number): Observable<VoucherDetail[]> {
    return this.get<VoucherDetail[]>(`/vouchers/${voucherId}/details`);
  }

  // ============================================================
  // BANK ACCOUNTS & TRANSACTIONS
  // ============================================================

  getAllBankAccounts(): Observable<BankAccount[]> {
    return this.get<BankAccount[]>('/bankaccounts');
  }

  getBankAccountById(id: number): Observable<BankAccount> {
    return this.get<BankAccount>(`/bankaccounts/${id}`);
  }

  createBankAccount(account: Partial<BankAccount>): Observable<BankAccount> {
    return this.post<BankAccount>('/bankaccounts', account);
  }

  updateBankAccount(id: number, account: Partial<BankAccount>): Observable<BankAccount> {
    return this.put<BankAccount>(`/bankaccounts/${id}`, account);
  }

  deleteBankAccount(id: number): Observable<void> {
    return this.delete<void>(`/bankaccounts/${id}`);
  }

  getBankTransactions(bankAccountId: number): Observable<BankTransaction[]> {
    return this.get<BankTransaction[]>(`/bankaccounts/${bankAccountId}/transactions`);
  }

  createBankTransaction(bankAccountId: number, transaction: Partial<BankTransaction>): Observable<BankTransaction> {
    return this.post<BankTransaction>(`/bankaccounts/${bankAccountId}/transactions`, transaction);
  }

  // ============================================================
  // OUTSTANDING
  // ============================================================

  getOutstandingReceivables(): Observable<OutstandingReceivable[]> {
    return this.get<OutstandingReceivable[]>('/outstanding/receivables');
  }

  getOutstandingReceivablesByParty(partyId: number): Observable<OutstandingReceivable[]> {
    return this.get<OutstandingReceivable[]>(`/outstanding/receivables/party/${partyId}`);
  }

  getOutstandingPayables(): Observable<OutstandingPayable[]> {
    return this.get<OutstandingPayable[]>('/outstanding/payables');
  }

  getOutstandingPayablesByParty(partyId: number): Observable<OutstandingPayable[]> {
    return this.get<OutstandingPayable[]>(`/outstanding/payables/party/${partyId}`);
  }

  // ============================================================
  // DEPARTMENTS
  // ============================================================

  getAllDepartments(): Observable<Department[]> {
    return this.get<Department[]>('/departments');
  }

  getDepartmentById(id: number): Observable<Department> {
    return this.get<Department>(`/departments/${id}`);
  }

  createDepartment(dept: Partial<Department>): Observable<Department> {
    return this.post<Department>('/departments', dept);
  }

  updateDepartment(id: number, dept: Partial<Department>): Observable<Department> {
    return this.put<Department>(`/departments/${id}`, dept);
  }

  deleteDepartment(id: number): Observable<void> {
    return this.delete<void>(`/departments/${id}`);
  }

  // ============================================================
  // DESIGNATIONS
  // ============================================================

  getAllDesignations(): Observable<Designation[]> {
    return this.get<Designation[]>('/designations');
  }

  getDesignationById(id: number): Observable<Designation> {
    return this.get<Designation>(`/designations/${id}`);
  }

  createDesignation(desig: Partial<Designation>): Observable<Designation> {
    return this.post<Designation>('/designations', desig);
  }

  updateDesignation(id: number, desig: Partial<Designation>): Observable<Designation> {
    return this.put<Designation>(`/designations/${id}`, desig);
  }

  deleteDesignation(id: number): Observable<void> {
    return this.delete<void>(`/designations/${id}`);
  }

  // ============================================================
  // EMPLOYEES
  // ============================================================

  getAllEmployees(): Observable<Employee[]> {
    return this.get<Employee[]>('/employees');
  }

  getEmployeeById(id: number): Observable<Employee> {
    return this.get<Employee>(`/employees/${id}`);
  }

  getActiveEmployees(): Observable<Employee[]> {
    return this.get<Employee[]>('/employees/active');
  }

  getEmployeesByDepartment(departmentId: number): Observable<Employee[]> {
    return this.get<Employee[]>(`/employees/department/${departmentId}`);
  }

  createEmployee(employee: Partial<Employee>): Observable<Employee> {
    return this.post<Employee>('/employees', employee);
  }

  updateEmployee(id: number, employee: Partial<Employee>): Observable<Employee> {
    return this.put<Employee>(`/employees/${id}`, employee);
  }

  deleteEmployee(id: number): Observable<void> {
    return this.delete<void>(`/employees/${id}`);
  }

  // ============================================================
  // ATTENDANCE
  // ============================================================

  getAttendanceByEmployee(employeeId: number, startDate?: string, endDate?: string): Observable<Attendance[]> {
    let params = new HttpParams();
    if (startDate) params = params.set('startDate', startDate);
    if (endDate) params = params.set('endDate', endDate);
    return this.get<Attendance[]>(`/attendance/employee/${employeeId}`, params);
  }

  getAttendanceByDate(date: string): Observable<Attendance[]> {
    return this.get<Attendance[]>(`/attendance/date/${date}`);
  }

  createAttendance(attendance: Partial<Attendance>): Observable<Attendance> {
    return this.post<Attendance>('/attendance', attendance);
  }

  updateAttendance(id: number, attendance: Partial<Attendance>): Observable<Attendance> {
    return this.put<Attendance>(`/attendance/${id}`, attendance);
  }

  deleteAttendance(id: number): Observable<void> {
    return this.delete<void>(`/attendance/${id}`);
  }

  getAttendanceSummary(employeeId: number, startDate: string, endDate: string): Observable<Record<string, unknown>> {
    const params = new HttpParams()
      .set('startDate', startDate)
      .set('endDate', endDate);
    return this.get<Record<string, unknown>>(`/attendance/summary/${employeeId}`, params);
  }

  // ============================================================
  // PAYROLL
  // ============================================================

  getAllPayrolls(): Observable<PayrollHeader[]> {
    return this.get<PayrollHeader[]>('/payroll');
  }

  getPayrollById(id: number): Observable<PayrollHeader> {
    return this.get<PayrollHeader>(`/payroll/${id}`);
  }

  processPayroll(periodId: number): Observable<PayrollHeader[]> {
    return this.post<PayrollHeader[]>(`/payroll/process/${periodId}`);
  }

  approvePayroll(id: number): Observable<PayrollHeader> {
    return this.post<PayrollHeader>(`/payroll/${id}/approve`);
  }

  cancelPayroll(id: number): Observable<PayrollHeader> {
    return this.post<PayrollHeader>(`/payroll/${id}/cancel`);
  }

  // ============================================================
  // PAYROLL PERIODS
  // ============================================================

  getAllPayrollPeriods(): Observable<PayrollPeriod[]> {
    return this.get<PayrollPeriod[]>('/payrollperiods');
  }

  getPayrollPeriodById(id: number): Observable<PayrollPeriod> {
    return this.get<PayrollPeriod>(`/payrollperiods/${id}`);
  }

  createPayrollPeriod(period: Partial<PayrollPeriod>): Observable<PayrollPeriod> {
    return this.post<PayrollPeriod>('/payrollperiods', period);
  }

  updatePayrollPeriod(id: number, period: Partial<PayrollPeriod>): Observable<PayrollPeriod> {
    return this.put<PayrollPeriod>(`/payrollperiods/${id}`, period);
  }

  // ============================================================
  // SALARY HEADS
  // ============================================================

  getAllSalaryHeads(): Observable<SalaryHead[]> {
    return this.get<SalaryHead[]>('/salaryheads');
  }

  getSalaryHeadById(id: number): Observable<SalaryHead> {
    return this.get<SalaryHead>(`/salaryheads/${id}`);
  }

  createSalaryHead(head: Partial<SalaryHead>): Observable<SalaryHead> {
    return this.post<SalaryHead>('/salaryheads', head);
  }

  updateSalaryHead(id: number, head: Partial<SalaryHead>): Observable<SalaryHead> {
    return this.put<SalaryHead>(`/salaryheads/${id}`, head);
  }

  deleteSalaryHead(id: number): Observable<void> {
    return this.delete<void>(`/salaryheads/${id}`);
  }

  // ============================================================
  // LEAVE
  // ============================================================

  getAllLeaveTypes(): Observable<LeaveType[]> {
    return this.get<LeaveType[]>('/leavetypes');
  }

  getLeaveTypeById(id: number): Observable<LeaveType> {
    return this.get<LeaveType>(`/leavetypes/${id}`);
  }

  createLeaveType(leaveType: Partial<LeaveType>): Observable<LeaveType> {
    return this.post<LeaveType>('/leavetypes', leaveType);
  }

  updateLeaveType(id: number, leaveType: Partial<LeaveType>): Observable<LeaveType> {
    return this.put<LeaveType>(`/leavetypes/${id}`, leaveType);
  }

  deleteLeaveType(id: number): Observable<void> {
    return this.delete<void>(`/leavetypes/${id}`);
  }

  getLeaveBalance(employeeId: number): Observable<LeaveBalance[]> {
    return this.get<LeaveBalance[]>(`/leavebalance/employee/${employeeId}`);
  }

  applyLeave(leave: Partial<Attendance>): Observable<Attendance> {
    return this.post<Attendance>('/leave/apply', leave);
  }

  adjustLeave(adjustment: Partial<LeaveBalance>): Observable<LeaveBalance> {
    return this.post<LeaveBalance>('/leave/adjust', adjustment);
  }

  // ============================================================
  // MACHINES
  // ============================================================

  getAllMachines(): Observable<Machine[]> {
    return this.get<Machine[]>('/machines');
  }

  getMachineById(id: number): Observable<Machine> {
    return this.get<Machine>(`/machines/${id}`);
  }

  getMachinesByType(type: string): Observable<Machine[]> {
    return this.get<Machine[]>(`/machines/type/${type}`);
  }

  getMachinesByStatus(status: string): Observable<Machine[]> {
    return this.get<Machine[]>(`/machines/status/${status}`);
  }

  createMachine(machine: Partial<Machine>): Observable<Machine> {
    return this.post<Machine>('/machines', machine);
  }

  updateMachine(id: number, machine: Partial<Machine>): Observable<Machine> {
    return this.put<Machine>(`/machines/${id}`, machine);
  }

  deleteMachine(id: number): Observable<void> {
    return this.delete<void>(`/machines/${id}`);
  }

  // ============================================================
  // SPARE PARTS
  // ============================================================

  getAllSpareParts(): Observable<SparePart[]> {
    return this.get<SparePart[]>('/spareparts');
  }

  getSparePartById(id: number): Observable<SparePart> {
    return this.get<SparePart>(`/spareparts/${id}`);
  }

  getSparePartsByCategory(categoryId: number): Observable<SparePart[]> {
    return this.get<SparePart[]>(`/spareparts/category/${categoryId}`);
  }

  getLowStockSpareParts(): Observable<SparePart[]> {
    return this.get<SparePart[]>('/spareparts/lowstock');
  }

  createSparePart(sparePart: Partial<SparePart>): Observable<SparePart> {
    return this.post<SparePart>('/spareparts', sparePart);
  }

  updateSparePart(id: number, sparePart: Partial<SparePart>): Observable<SparePart> {
    return this.put<SparePart>(`/spareparts/${id}`, sparePart);
  }

  deleteSparePart(id: number): Observable<void> {
    return this.delete<void>(`/spareparts/${id}`);
  }

  consumeSparePart(id: number, quantity: number): Observable<SparePart> {
    return this.post<SparePart>(`/spareparts/${id}/consume`, { quantity });
  }

  restockSparePart(id: number, quantity: number): Observable<SparePart> {
    return this.post<SparePart>(`/spareparts/${id}/restock`, { quantity });
  }

  // ============================================================
  // MAINTENANCE
  // ============================================================

  getAllMaintenanceRequests(): Observable<MaintenanceRequest[]> {
    return this.get<MaintenanceRequest[]>('/maintenance');
  }

  getMaintenanceRequestById(id: number): Observable<MaintenanceRequest> {
    return this.get<MaintenanceRequest>(`/maintenance/${id}`);
  }

  getMaintenanceRequestsByMachine(machineId: number): Observable<MaintenanceRequest[]> {
    return this.get<MaintenanceRequest[]>(`/maintenance/machine/${machineId}`);
  }

  createMaintenanceRequest(request: Partial<MaintenanceRequest>): Observable<MaintenanceRequest> {
    return this.post<MaintenanceRequest>('/maintenance', request);
  }

  updateMaintenanceRequest(id: number, request: Partial<MaintenanceRequest>): Observable<MaintenanceRequest> {
    return this.put<MaintenanceRequest>(`/maintenance/${id}`, request);
  }

  deleteMaintenanceRequest(id: number): Observable<void> {
    return this.delete<void>(`/maintenance/${id}`);
  }

  assignMaintenanceRequest(id: number, employeeId: number): Observable<MaintenanceRequest> {
    return this.post<MaintenanceRequest>(`/maintenance/${id}/assign`, { employeeId });
  }

  completeMaintenanceRequest(id: number, notes: string, cost?: number): Observable<MaintenanceRequest> {
    return this.post<MaintenanceRequest>(`/maintenance/${id}/complete`, { notes, cost });
  }

  // ============================================================
  // WORK ORDERS
  // ============================================================

  getAllWorkOrders(): Observable<WorkOrder[]> {
    return this.get<WorkOrder[]>('/workorders');
  }

  getWorkOrderById(id: number): Observable<WorkOrder> {
    return this.get<WorkOrder>(`/workorders/${id}`);
  }

  createWorkOrder(order: Partial<WorkOrder>): Observable<WorkOrder> {
    return this.post<WorkOrder>('/workorders', order);
  }

  updateWorkOrder(id: number, order: Partial<WorkOrder>): Observable<WorkOrder> {
    return this.put<WorkOrder>(`/workorders/${id}`, order);
  }

  deleteWorkOrder(id: number): Observable<void> {
    return this.delete<void>(`/workorders/${id}`);
  }

  completeWorkOrder(id: number, notes?: string): Observable<WorkOrder> {
    return this.post<WorkOrder>(`/workorders/${id}/complete`, { notes });
  }

  cancelWorkOrder(id: number, reason?: string): Observable<WorkOrder> {
    return this.post<WorkOrder>(`/workorders/${id}/cancel`, { reason });
  }

  getWorkOrderSpareParts(workOrderId: number): Observable<WorkOrderSparePart[]> {
    return this.get<WorkOrderSparePart[]>(`/workorders/${workOrderId}/spareparts`);
  }

  addWorkOrderSparePart(workOrderId: number, sparePart: Partial<WorkOrderSparePart>): Observable<WorkOrderSparePart> {
    return this.post<WorkOrderSparePart>(`/workorders/${workOrderId}/spareparts`, sparePart);
  }

  // ============================================================
  // DOWNTIME
  // ============================================================

  getDowntimeById(id: number): Observable<DowntimeLog> {
    return this.get<DowntimeLog>(`/downtime/${id}`);
  }

  getDowntimeByMachine(machineId: number): Observable<DowntimeLog[]> {
    return this.get<DowntimeLog[]>(`/downtime/machine/${machineId}`);
  }

  getActiveDowntime(): Observable<DowntimeLog[]> {
    return this.get<DowntimeLog[]>('/downtime/active');
  }

  getDowntimeSummary(startDate: string, endDate: string): Observable<Record<string, unknown>> {
    const params = new HttpParams()
      .set('startDate', startDate)
      .set('endDate', endDate);
    return this.get<Record<string, unknown>>('/downtime/summary', params);
  }

  startDowntime(log: Partial<DowntimeLog>): Observable<DowntimeLog> {
    return this.post<DowntimeLog>('/downtime/start', log);
  }

  endDowntime(id: number, notes?: string): Observable<DowntimeLog> {
    return this.post<DowntimeLog>(`/downtime/${id}/end`, { notes });
  }

  // ============================================================
  // COST SUMMARY
  // ============================================================

  getAllCostSummaries(): Observable<CostSummary[]> {
    return this.get<CostSummary[]>('/costsummary');
  }

  getCostSummaryById(id: number): Observable<CostSummary> {
    return this.get<CostSummary>(`/costsummary/${id}`);
  }

  getCostSummariesByMachine(machineId: number): Observable<CostSummary[]> {
    return this.get<CostSummary[]>(`/costsummary/machine/${machineId}`);
  }

  getCostSummariesByDepartment(departmentId: number): Observable<CostSummary[]> {
    return this.get<CostSummary[]>(`/costsummary/department/${departmentId}`);
  }

  createCostSummary(summary: Partial<CostSummary>): Observable<CostSummary> {
    return this.post<CostSummary>('/costsummary', summary);
  }

  updateCostSummary(id: number, summary: Partial<CostSummary>): Observable<CostSummary> {
    return this.put<CostSummary>(`/costsummary/${id}`, summary);
  }

  deleteCostSummary(id: number): Observable<void> {
    return this.delete<void>(`/costsummary/${id}`);
  }

  // ============================================================
  // TRANSPORTERS & VEHICLES
  // ============================================================

  getAllTransporters(): Observable<Transporter[]> {
    return this.get<Transporter[]>('/transporters');
  }

  getTransporterById(id: number): Observable<Transporter> {
    return this.get<Transporter>(`/transporters/${id}`);
  }

  createTransporter(transporter: Partial<Transporter>): Observable<Transporter> {
    return this.post<Transporter>('/transporters', transporter);
  }

  updateTransporter(id: number, transporter: Partial<Transporter>): Observable<Transporter> {
    return this.put<Transporter>(`/transporters/${id}`, transporter);
  }

  deleteTransporter(id: number): Observable<void> {
    return this.delete<void>(`/transporters/${id}`);
  }

  getVehiclesByTransporter(transporterId: number): Observable<Vehicle[]> {
    return this.get<Vehicle[]>(`/transporters/${transporterId}/vehicles`);
  }

  createVehicle(transporterId: number, vehicle: Partial<Vehicle>): Observable<Vehicle> {
    return this.post<Vehicle>(`/transporters/${transporterId}/vehicles`, vehicle);
  }

  updateVehicle(transporterId: number, vehicleId: number, vehicle: Partial<Vehicle>): Observable<Vehicle> {
    return this.put<Vehicle>(`/transporters/${transporterId}/vehicles/${vehicleId}`, vehicle);
  }

  deleteVehicle(transporterId: number, vehicleId: number): Observable<void> {
    return this.delete<void>(`/transporters/${transporterId}/vehicles/${vehicleId}`);
  }

  // ============================================================
  // LEDGER GROUPS & LEDGERS
  // ============================================================

  getAllLedgerGroups(): Observable<LedgerGroup[]> {
    return this.get<LedgerGroup[]>('/ledgergroups');
  }

  getLedgerGroupById(id: number): Observable<LedgerGroup> {
    return this.get<LedgerGroup>(`/ledgergroups/${id}`);
  }

  createLedgerGroup(group: Partial<LedgerGroup>): Observable<LedgerGroup> {
    return this.post<LedgerGroup>('/ledgergroups', group);
  }

  updateLedgerGroup(id: number, group: Partial<LedgerGroup>): Observable<LedgerGroup> {
    return this.put<LedgerGroup>(`/ledgergroups/${id}`, group);
  }

  deleteLedgerGroup(id: number): Observable<void> {
    return this.delete<void>(`/ledgergroups/${id}`);
  }

  getAllLedgers(): Observable<Ledger[]> {
    return this.get<Ledger[]>('/ledgers');
  }

  getLedgerById(id: number): Observable<Ledger> {
    return this.get<Ledger>(`/ledgers/${id}`);
  }

  getLedgersByGroup(groupId: number): Observable<Ledger[]> {
    return this.get<Ledger[]>(`/ledgers/group/${groupId}`);
  }

  createLedger(ledger: Partial<Ledger>): Observable<Ledger> {
    return this.post<Ledger>('/ledgers', ledger);
  }

  updateLedger(id: number, ledger: Partial<Ledger>): Observable<Ledger> {
    return this.put<Ledger>(`/ledgers/${id}`, ledger);
  }

  deleteLedger(id: number): Observable<void> {
    return this.delete<void>(`/ledgers/${id}`);
  }
}
