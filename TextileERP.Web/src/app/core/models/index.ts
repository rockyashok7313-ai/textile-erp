export interface User {
  id: number;
  username: string;
  email: string;
  fullName: string;
  department?: string;
  designation?: string;
  isActive: boolean;
  lastLogin?: Date;
  createdAt: Date;
  updatedAt?: Date;
}

export interface LoginRequest {
  username: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  refreshToken: string;
  expiresAt: Date;
  user: User;
}

export interface ChangePasswordRequest {
  currentPassword: string;
  newPassword: string;
}

export interface Company {
  id: number;
  name: string;
  legalName?: string;
  gstin?: string;
  pan?: string;
  address?: string;
  city?: string;
  stateId?: number;
  state?: StateMaster;
  countryId?: number;
  country?: Country;
  phone?: string;
  email?: string;
  website?: string;
  logo?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface StateMaster {
  id: number;
  code: string;
  name: string;
  countryId: number;
  gstStateCode?: string;
  isActive: boolean;
}

export interface Country {
  id: number;
  code: string;
  name: string;
  isActive: boolean;
}

export interface Item {
  id: number;
  code: string;
  name: string;
  description?: string;
  barcode?: string;
  hsnCode?: string;
  hsnMasterId?: number;
  hsnMaster?: HSNMaster;
  categoryId: number;
  category?: ItemCategory;
  unitId: number;
  unit?: Unit;
  gstRateId: number;
  gstRate?: GSTRate;
  purchaseRate?: number;
  sellingRate?: number;
  mrp?: number;
  reorderLevel?: number;
  minimumStock?: number;
  maximumStock?: number;
  currentStock?: number;
  godownId?: number;
  godown?: Godown;
  locationId?: number;
  location?: GodownLocation;
  isBatchTracked: boolean;
  isSerialTracked: boolean;
  isActive: boolean;
  imageUrl?: string;
  createdAt: Date;
  updatedAt?: Date;
}

export interface ItemCategory {
  id: number;
  code: string;
  name: string;
  description?: string;
  parentCategoryId?: number;
  parentCategory?: ItemCategory;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface Unit {
  id: number;
  code: string;
  name: string;
  symbol?: string;
  unitType?: string;
  conversionFactor?: number;
  baseUnitId?: number;
  baseUnit?: Unit;
  isActive: boolean;
}

export interface HSNMaster {
  id: number;
  code: string;
  description?: string;
  gstRateId?: number;
  gstRate?: GSTRate;
  isActive: boolean;
}

export interface GSTRate {
  id: number;
  code: string;
  rate: number;
  cgstRate?: number;
  sgstRate?: number;
  igstRate?: number;
  cessRate?: number;
  description?: string;
  isActive: boolean;
}

export interface Godown {
  id: number;
  code: string;
  name: string;
  address?: string;
  city?: string;
  stateId?: number;
  managerName?: string;
  phone?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface GodownLocation {
  id: number;
  godownId: number;
  godown?: Godown;
  code: string;
  name: string;
  rack?: string;
  shelf?: string;
  bin?: string;
  description?: string;
  isActive: boolean;
}

export interface Party {
  id: number;
  code: string;
  name: string;
  legalName?: string;
  partyType: string;
  gstin?: string;
  pan?: string;
  phone?: string;
  mobile?: string;
  email?: string;
  website?: string;
  contactPerson?: string;
  creditLimit?: number;
  creditDays?: number;
  isTDSApplicable: boolean;
  tdsRate?: number;
  isTCSApplicable: boolean;
  tcsRate?: number;
  isActive: boolean;
  addresses?: PartyAddress[];
  createdAt: Date;
  updatedAt?: Date;
}

export interface PartyAddress {
  id: number;
  partyId: number;
  party?: Party;
  addressType: string;
  addressLine1: string;
  addressLine2?: string;
  city?: string;
  stateId?: number;
  state?: StateMaster;
  pincode?: string;
  countryId?: number;
  country?: Country;
  isDefault: boolean;
  isActive: boolean;
}

export interface SalesInvoice {
  id: number;
  invoiceNumber: string;
  invoiceDate: Date;
  dueDate?: Date;
  referenceNumber?: string;
  customerId: number;
  customer?: Party;
  billingAddressId?: number;
  billingAddress?: PartyAddress;
  shippingAddressId?: number;
  shippingAddress?: PartyAddress;
  stateId?: number;
  state?: StateMaster;
  isInterState: boolean;
  totalQuantity?: number;
  totalGrossAmount?: number;
  totalDiscount?: number;
  totalTaxableAmount?: number;
  totalCGST?: number;
  totalSGST?: number;
  totalIGST?: number;
  totalCess?: number;
  totalTCS?: number;
  totalTDS?: number;
  roundOff?: number;
  grandTotal?: number;
  amountInWords?: string;
  notes?: string;
  termsAndConditions?: string;
  status: string;
  isPosted: boolean;
  postedDate?: Date;
  cancelledDate?: Date;
  cancelledReason?: string;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  details?: SalesInvoiceDetail[];
}

export interface SalesInvoiceDetail {
  id: number;
  salesInvoiceId: number;
  salesInvoice?: SalesInvoice;
  lineNumber: number;
  itemId: number;
  item?: Item;
  itemCode?: string;
  itemName?: string;
  hsnCode?: string;
  description?: string;
  quantity: number;
  unitId?: number;
  unit?: Unit;
  unitName?: string;
  rate: number;
  discountPercent?: number;
  discountAmount?: number;
  grossAmount?: number;
  taxableAmount?: number;
  gstRateId?: number;
  gstRate?: GSTRate;
  cgstRate?: number;
  cgstAmount?: number;
  sgstRate?: number;
  sgstAmount?: number;
  igstRate?: number;
  igstAmount?: number;
  cessRate?: number;
  cessAmount?: number;
  totalAmount?: number;
  godownId?: number;
  godown?: Godown;
  locationId?: number;
  location?: GodownLocation;
  batchNumber?: string;
  serialNumber?: string;
  expiryDate?: Date;
  isActive: boolean;
}

export interface SalesOrder {
  id: number;
  orderNumber: string;
  orderDate: Date;
  expectedDeliveryDate?: Date;
  referenceNumber?: string;
  customerId: number;
  customer?: Party;
  billingAddressId?: number;
  billingAddress?: PartyAddress;
  shippingAddressId?: number;
  shippingAddress?: PartyAddress;
  stateId?: number;
  state?: StateMaster;
  isInterState: boolean;
  totalQuantity?: number;
  totalGrossAmount?: number;
  totalDiscount?: number;
  totalTaxableAmount?: number;
  totalCGST?: number;
  totalSGST?: number;
  totalIGST?: number;
  totalCess?: number;
  grandTotal?: number;
  roundOff?: number;
  amountInWords?: string;
  notes?: string;
  termsAndConditions?: string;
  status: string;
  isFullyInvoiced: boolean;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  details?: SalesOrderDetail[];
}

export interface SalesOrderDetail {
  id: number;
  salesOrderId: number;
  salesOrder?: SalesOrder;
  lineNumber: number;
  itemId: number;
  item?: Item;
  itemCode?: string;
  itemName?: string;
  hsnCode?: string;
  description?: string;
  quantity: number;
  unitId?: number;
  unit?: Unit;
  unitName?: string;
  rate: number;
  discountPercent?: number;
  discountAmount?: number;
  grossAmount?: number;
  taxableAmount?: number;
  gstRateId?: number;
  gstRate?: GSTRate;
  cgstRate?: number;
  cgstAmount?: number;
  sgstRate?: number;
  sgstAmount?: number;
  igstRate?: number;
  igstAmount?: number;
  cessRate?: number;
  cessAmount?: number;
  totalAmount?: number;
  invoicedQuantity?: number;
  isFullyInvoiced: boolean;
  isActive: boolean;
}

export interface ProformaInvoice {
  id: number;
  invoiceNumber: string;
  invoiceDate: Date;
  validUntil?: Date;
  referenceNumber?: string;
  customerId: number;
  customer?: Party;
  billingAddressId?: number;
  billingAddress?: PartyAddress;
  shippingAddressId?: number;
  shippingAddress?: PartyAddress;
  stateId?: number;
  state?: StateMaster;
  isInterState: boolean;
  totalQuantity?: number;
  totalGrossAmount?: number;
  totalDiscount?: number;
  totalTaxableAmount?: number;
  totalCGST?: number;
  totalSGST?: number;
  totalIGST?: number;
  totalCess?: number;
  grandTotal?: number;
  roundOff?: number;
  amountInWords?: string;
  notes?: string;
  termsAndConditions?: string;
  status: string;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  details?: ProformaInvoiceDetail[];
}

export interface ProformaInvoiceDetail {
  id: number;
  proformaInvoiceId: number;
  proformaInvoice?: ProformaInvoice;
  lineNumber: number;
  itemId: number;
  item?: Item;
  itemCode?: string;
  itemName?: string;
  hsnCode?: string;
  description?: string;
  quantity: number;
  unitId?: number;
  unit?: Unit;
  unitName?: string;
  rate: number;
  discountPercent?: number;
  discountAmount?: number;
  grossAmount?: number;
  taxableAmount?: number;
  gstRateId?: number;
  gstRate?: GSTRate;
  cgstRate?: number;
  cgstAmount?: number;
  sgstRate?: number;
  sgstAmount?: number;
  igstRate?: number;
  igstAmount?: number;
  cessRate?: number;
  cessAmount?: number;
  totalAmount?: number;
  isActive: boolean;
}

export interface PurchaseInvoice {
  id: number;
  invoiceNumber: string;
  supplierInvoiceNumber?: string;
  invoiceDate: Date;
  dueDate?: Date;
  referenceNumber?: string;
  supplierId: number;
  supplier?: Party;
  billingAddressId?: number;
  billingAddress?: PartyAddress;
  shippingAddressId?: number;
  shippingAddress?: PartyAddress;
  stateId?: number;
  state?: StateMaster;
  isInterState: boolean;
  totalQuantity?: number;
  totalGrossAmount?: number;
  totalDiscount?: number;
  totalTaxableAmount?: number;
  totalCGST?: number;
  totalSGST?: number;
  totalIGST?: number;
  totalCess?: number;
  totalTCS?: number;
  totalTDS?: number;
  roundOff?: number;
  grandTotal?: number;
  amountInWords?: string;
  notes?: string;
  termsAndConditions?: string;
  status: string;
  isPosted: boolean;
  postedDate?: Date;
  cancelledDate?: Date;
  cancelledReason?: string;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  details?: PurchaseInvoiceDetail[];
}

export interface PurchaseInvoiceDetail {
  id: number;
  purchaseInvoiceId: number;
  purchaseInvoice?: PurchaseInvoice;
  lineNumber: number;
  itemId: number;
  item?: Item;
  itemCode?: string;
  itemName?: string;
  hsnCode?: string;
  description?: string;
  quantity: number;
  unitId?: number;
  unit?: Unit;
  unitName?: string;
  rate: number;
  discountPercent?: number;
  discountAmount?: number;
  grossAmount?: number;
  taxableAmount?: number;
  gstRateId?: number;
  gstRate?: GSTRate;
  cgstRate?: number;
  cgstAmount?: number;
  sgstRate?: number;
  sgstAmount?: number;
  igstRate?: number;
  igstAmount?: number;
  cessRate?: number;
  cessAmount?: number;
  totalAmount?: number;
  godownId?: number;
  godown?: Godown;
  locationId?: number;
  location?: GodownLocation;
  batchNumber?: string;
  serialNumber?: string;
  expiryDate?: Date;
  isActive: boolean;
}

export interface PurchaseOrder {
  id: number;
  orderNumber: string;
  orderDate: Date;
  expectedDeliveryDate?: Date;
  referenceNumber?: string;
  supplierId: number;
  supplier?: Party;
  billingAddressId?: number;
  billingAddress?: PartyAddress;
  shippingAddressId?: number;
  shippingAddress?: PartyAddress;
  stateId?: number;
  state?: StateMaster;
  isInterState: boolean;
  totalQuantity?: number;
  totalGrossAmount?: number;
  totalDiscount?: number;
  totalTaxableAmount?: number;
  totalCGST?: number;
  totalSGST?: number;
  totalIGST?: number;
  totalCess?: number;
  grandTotal?: number;
  roundOff?: number;
  amountInWords?: string;
  notes?: string;
  termsAndConditions?: string;
  status: string;
  isFullyReceived: boolean;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  details?: PurchaseOrderDetail[];
}

export interface PurchaseOrderDetail {
  id: number;
  purchaseOrderId: number;
  purchaseOrder?: PurchaseOrder;
  lineNumber: number;
  itemId: number;
  item?: Item;
  itemCode?: string;
  itemName?: string;
  hsnCode?: string;
  description?: string;
  quantity: number;
  unitId?: number;
  unit?: Unit;
  unitName?: string;
  rate: number;
  discountPercent?: number;
  discountAmount?: number;
  grossAmount?: number;
  taxableAmount?: number;
  gstRateId?: number;
  gstRate?: GSTRate;
  cgstRate?: number;
  cgstAmount?: number;
  sgstRate?: number;
  sgstAmount?: number;
  igstRate?: number;
  igstAmount?: number;
  cessRate?: number;
  cessAmount?: number;
  totalAmount?: number;
  receivedQuantity?: number;
  isFullyReceived: boolean;
  isActive: boolean;
}

export interface GSTInvoice {
  id: number;
  invoiceNumber: string;
  invoiceDate: Date;
  invoiceType: string;
  supplyType: string;
  reverseCharge: boolean;
  customerId?: number;
  customer?: Party;
  supplierId?: number;
  supplier?: Party;
  placeOfSupply?: string;
  placeOfSupplyStateId?: number;
  billingAddress?: string;
  shippingAddress?: string;
  documentNumber?: string;
  documentDate?: Date;
  totalTaxableAmount?: number;
  totalCGST?: number;
  totalSGST?: number;
  totalIGST?: number;
  totalCess?: number;
  totalValue?: number;
  roundOff?: number;
  grandTotal?: number;
  status: string;
  irn?: string;
  irnDate?: Date;
  acknowledgementNumber?: string;
  acknowledgementDate?: Date;
  qrCode?: string;
  eInvoiceNumber?: string;
  eInvoiceDate?: Date;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  details?: GSTInvoiceDetail[];
}

export interface GSTInvoiceDetail {
  id: number;
  gstInvoiceId: number;
  gstInvoice?: GSTInvoice;
  lineNumber: number;
  itemId: number;
  item?: Item;
  itemCode?: string;
  itemName?: string;
  hsnCode?: string;
  description?: string;
  quantity: number;
  unitId?: number;
  unit?: Unit;
  unitName?: string;
  unitPrice?: number;
  grossAmount?: number;
  discountAmount?: number;
  taxableAmount?: number;
  gstRateId?: number;
  gstRate?: GSTRate;
  cgstRate?: number;
  cgstAmount?: number;
  sgstRate?: number;
  sgstAmount?: number;
  igstRate?: number;
  igstAmount?: number;
  cessRate?: number;
  cessAmount?: number;
  totalAmount?: number;
  isActive: boolean;
}

export interface TDSEntry {
  id: number;
  partyId: number;
  party?: Party;
  sectionCode?: string;
  tdsRate: number;
  grossAmount: number;
  tdsAmount: number;
  surchargeAmount?: number;
  cessAmount?: number;
  totalTDSAmount: number;
  entryDate: Date;
  voucherType?: string;
  voucherNumber?: string;
  referenceNumber?: string;
  status: string;
  depositedDate?: Date;
  ChallanNumber?: string;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
}

export interface TCSEntry {
  id: number;
  partyId: number;
  party?: Party;
  tcsRate: number;
  grossAmount: number;
  tcsAmount: number;
  totalAmount: number;
  entryDate: Date;
  voucherType?: string;
  voucherNumber?: string;
  referenceNumber?: string;
  status: string;
  depositedDate?: Date;
  ChallanNumber?: string;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
}

export interface EWayBill {
  id: number;
  eWayBillNumber?: string;
  eWayBillDate?: Date;
  supplyType: string;
  subSupplyType?: string;
  documentNumber?: string;
  documentDate?: Date;
  fromGstin?: string;
  fromTradeName?: string;
  fromAddress?: string;
  fromStateId?: number;
  fromState?: StateMaster;
  toGstin?: string;
  toTradeName?: string;
  toAddress?: string;
  toStateId?: number;
  toState?: StateMaster;
  totalTaxableAmount?: number;
  totalCGST?: number;
  totalSGST?: number;
  totalIGST?: number;
  totalCess?: number;
  totalValue?: number;
  transporterId?: string;
  transporterName?: string;
  transporterDocNumber?: string;
  transporterDocDate?: Date;
  estimatedDistance?: number;
  actualDistance?: number;
  status: string;
  cancelledDate?: Date;
  cancelReason?: string;
  irn?: string;
  salesInvoiceId?: number;
  salesInvoice?: SalesInvoice;
  purchaseInvoiceId?: number;
  purchaseInvoice?: PurchaseInvoice;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  vehicles?: EWayBillVehicle[];
  details?: EWayBillDetail[];
}

export interface EWayBillVehicle {
  id: number;
  eWayBillId: number;
  eWayBill?: EWayBill;
  vehicleNumber: string;
  mode: string;
  from?: string;
  to?: string;
  enteredDate?: Date;
  transportationId?: string;
  transportationDate?: Date;
  isActive: boolean;
}

export interface EWayBillDetail {
  id: number;
  eWayBillId: number;
  eWayBill?: EWayBill;
  lineNumber: number;
  itemId?: number;
  item?: Item;
  itemDescription?: string;
  hsnCode?: string;
  quantity?: number;
  unitId?: number;
  unit?: Unit;
  unitName?: string;
  value?: number;
  taxRate?: number;
  cgstAmount?: number;
  sgstAmount?: number;
  igstAmount?: number;
  cessAmount?: number;
}

export interface EInvoice {
  id: number;
  irn?: string;
  irnDate?: Date;
  acknowledgementNumber?: string;
  acknowledgementDate?: Date;
  documentNumber?: string;
  documentDate?: Date;
  documentType?: string;
  supplyType?: string;
  reverseCharge?: boolean;
  fromGstin?: string;
  fromTradeName?: string;
  toGstin?: string;
  toTradeName?: string;
  totalTaxableAmount?: number;
  totalCGST?: number;
  totalSGST?: number;
  totalIGST?: number;
  totalCess?: number;
  totalValue?: number;
  roundOff?: number;
  grandTotal?: number;
  qrCode?: string;
  status: string;
  errorMessage?: string;
  salesInvoiceId?: number;
  salesInvoice?: SalesInvoice;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  details?: EInvoiceDetail[];
}

export interface EInvoiceDetail {
  id: number;
  eInvoiceId: number;
  eInvoice?: EInvoice;
  lineNumber: number;
  itemId?: number;
  item?: Item;
  itemDescription?: string;
  hsnCode?: string;
  isService?: boolean;
  quantity?: number;
  unitId?: number;
  unit?: Unit;
  unitName?: string;
  unitPrice?: number;
  grossAmount?: number;
  discountAmount?: number;
  taxableAmount?: number;
  gstRateId?: number;
  gstRate?: GSTRate;
  cgstRate?: number;
  cgstAmount?: number;
  sgstRate?: number;
  sgstAmount?: number;
  igstRate?: number;
  igstAmount?: number;
  cessRate?: number;
  cessAmount?: number;
  totalAmount?: number;
}

export interface DocumentSequence {
  id: number;
  documentType: string;
  prefix?: string;
  suffix?: string;
  nextNumber: number;
  incrementBy: number;
  padLength: number;
  resetFrequency?: string;
  lastResetDate?: Date;
  financialYear?: string;
  companyId?: number;
  isActive: boolean;
}

export interface StockSummary {
  id: number;
  itemId: number;
  item?: Item;
  godownId: number;
  godown?: Godown;
  locationId?: number;
  location?: GodownLocation;
  batchNumber?: string;
  serialNumber?: string;
  openingQuantity?: number;
  openingValue?: number;
  receivedQuantity?: number;
  receivedValue?: number;
  issuedQuantity?: number;
  issuedValue?: number;
  closingQuantity?: number;
  closingValue?: number;
  closingRate?: number;
  unitId?: number;
  unit?: Unit;
  asOnDate?: Date;
  createdAt: Date;
  updatedAt?: Date;
}

export interface StockJournal {
  id: number;
  journalNumber: string;
  journalDate: Date;
  voucherType: string;
  referenceNumber?: string;
  narration?: string;
  fromGodownId?: number;
  fromGodown?: Godown;
  toGodownId?: number;
  toGodown?: Godown;
  status: string;
  isCancelled: boolean;
  cancelledDate?: Date;
  cancelledReason?: string;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  details?: StockJournalDetail[];
}

export interface StockJournalDetail {
  id: number;
  stockJournalId: number;
  stockJournal?: StockJournal;
  lineNumber: number;
  itemId: number;
  item?: Item;
  itemCode?: string;
  itemName?: string;
  quantity: number;
  unitId?: number;
  unit?: Unit;
  unitName?: string;
  rate?: number;
  amount?: number;
  fromGodownId?: number;
  fromGodown?: Godown;
  fromLocationId?: number;
  fromLocation?: GodownLocation;
  toGodownId?: number;
  toGodown?: Godown;
  toLocationId?: number;
  toLocation?: GodownLocation;
  batchNumber?: string;
  serialNumber?: string;
  isActive: boolean;
}

export interface Voucher {
  id: number;
  voucherNumber: string;
  voucherDate: Date;
  voucherType: string;
  referenceNumber?: string;
  narration?: string;
  totalDebit?: number;
  totalCredit?: number;
  isAutoGenerated: boolean;
  status: string;
  isCancelled: boolean;
  cancelledDate?: Date;
  cancelledReason?: string;
  financialYear?: string;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  details?: VoucherDetail[];
}

export interface VoucherDetail {
  id: number;
  voucherId: number;
  voucher?: Voucher;
  lineNumber: number;
  ledgerId: number;
  ledger?: Ledger;
  debitAmount?: number;
  creditAmount?: number;
  amount?: number;
  narration?: string;
  partyId?: number;
  party?: Party;
  chequeNumber?: string;
  chequeDate?: Date;
  bankAccountId?: number;
  bankAccount?: BankAccount;
  isActive: boolean;
}

export interface BankAccount {
  id: number;
  accountName: string;
  accountNumber: string;
  bankName?: string;
  branchName?: string;
  ifscCode?: string;
  micrCode?: string;
  swiftCode?: string;
  accountType?: string;
  openingBalance?: number;
  currentBalance?: number;
  ledgerId?: number;
  ledger?: Ledger;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface BankTransaction {
  id: number;
  bankAccountId: number;
  bankAccount?: BankAccount;
  transactionDate: Date;
  transactionType: string;
  chequeNumber?: string;
  chequeDate?: Date;
  payeeOrPayer?: string;
  description?: string;
  debitAmount?: number;
  creditAmount?: number;
  balance?: number;
  referenceNumber?: string;
  voucherId?: number;
  voucher?: Voucher;
  status: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface OutstandingReceivable {
  id: number;
  partyId: number;
  party?: Party;
  referenceType?: string;
  referenceId?: number;
  referenceNumber?: string;
  documentDate?: Date;
  dueDate?: Date;
  originalAmount: number;
  paidAmount?: number;
  balanceAmount?: number;
  daysOverdue?: number;
  status: string;
  financialYear?: string;
  companyId?: number;
  createdAt: Date;
  updatedAt?: Date;
}

export interface OutstandingPayable {
  id: number;
  partyId: number;
  party?: Party;
  referenceType?: string;
  referenceId?: number;
  referenceNumber?: string;
  documentDate?: Date;
  dueDate?: Date;
  originalAmount: number;
  paidAmount?: number;
  balanceAmount?: number;
  daysOverdue?: number;
  status: string;
  financialYear?: string;
  companyId?: number;
  createdAt: Date;
  updatedAt?: Date;
}

export interface Department {
  id: number;
  code: string;
  name: string;
  description?: string;
  headId?: number;
  head?: Employee;
  parentId?: number;
  parent?: Department;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface Designation {
  id: number;
  code: string;
  name: string;
  description?: string;
  level?: number;
  minSalary?: number;
  maxSalary?: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface Employee {
  id: number;
  employeeCode: string;
  firstName: string;
  lastName: string;
  fullName?: string;
  dateOfBirth?: Date;
  dateOfJoining: Date;
  dateOfLeaving?: Date;
  gender?: string;
  maritalStatus?: string;
  bloodGroup?: string;
  personalEmail?: string;
  companyEmail?: string;
  phone?: string;
  mobile?: string;
  address?: string;
  city?: string;
  stateId?: number;
  state?: StateMaster;
  pincode?: string;
  emergencyContactName?: string;
  emergencyContactPhone?: string;
  departmentId: number;
  department?: Department;
  designationId: number;
  designation?: Designation;
  reportingToId?: number;
  reportingTo?: Employee;
  bankAccountNumber?: string;
  bankName?: string;
  ifscCode?: string;
  panNumber?: string;
  aadhaarNumber?: string;
  pfNumber?: string;
  esiNumber?: string;
  uanNumber?: string;
  basicSalary?: number;
  grossSalary?: number;
  probationEndDate?: Date;
  isProbationary: boolean;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface LeaveType {
  id: number;
  code: string;
  name: string;
  description?: string;
  defaultDays?: number;
  isCarryForward: boolean;
  maxCarryForwardDays?: number;
  isEncashable: boolean;
  isPaid: boolean;
  isActive: boolean;
}

export interface LeaveBalance {
  id: number;
  employeeId: number;
  employee?: Employee;
  leaveTypeId: number;
  leaveType?: LeaveType;
  financialYear?: string;
  totalEntitled?: number;
  used?: number;
  balance?: number;
  carriedForward?: number;
  encashed?: number;
  createdAt: Date;
  updatedAt?: Date;
}

export interface Attendance {
  id: number;
  employeeId: number;
  employee?: Employee;
  attendanceDate: Date;
  checkInTime?: Date;
  checkOutTime?: Date;
  totalHours?: number;
  overtimeHours?: number;
  status: string;
  shift?: string;
  isHalfDay: boolean;
  isOnLeave: boolean;
  leaveTypeId?: number;
  leaveType?: LeaveType;
  remarks?: string;
  approvedBy?: number;
  approver?: Employee;
  isApproved: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface PayrollPeriod {
  id: number;
  name: string;
  startDate: Date;
  endDate: Date;
  paymentDate?: Date;
  status: string;
  isLocked: boolean;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
}

export interface PayrollHeader {
  id: number;
  payrollPeriodId: number;
  payrollPeriod?: PayrollPeriod;
  employeeId: number;
  employee?: Employee;
  basicSalary?: number;
  hra?: number;
  conveyanceAllowance?: number;
  medicalAllowance?: number;
  specialAllowance?: number;
  otherAllowances?: number;
  grossEarnings?: number;
  pfEmployee?: number;
  esiEmployee?: number;
  professionalTax?: number;
  incomeTax?: number;
  tds?: number;
  loanDeduction?: number;
  advanceDeduction?: number;
  otherDeductions?: number;
  totalDeductions?: number;
  netSalary?: number;
  lopDays?: number;
  workingDays?: number;
  paidDays?: number;
  status: string;
  isApproved: boolean;
  approvedDate?: Date;
  approvedBy?: number;
  paymentDate?: Date;
  paymentReference?: string;
  createdAt: Date;
  updatedAt?: Date;
  details?: PayrollDetail[];
}

export interface PayrollDetail {
  id: number;
  payrollHeaderId: number;
  payrollHeader?: PayrollHeader;
  salaryHeadId: number;
  salaryHead?: SalaryHead;
  amount: number;
  type: string;
  calculationType?: string;
  formula?: string;
  isActive: boolean;
}

export interface SalaryHead {
  id: number;
  code: string;
  name: string;
  description?: string;
  type: string;
  calculationType?: string;
  formula?: string;
  defaultValue?: number;
  minLimit?: number;
  maxLimit?: number;
  isStatutory: boolean;
  componentGroup?: string;
  sortOrder?: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface Machine {
  id: number;
  code: string;
  name: string;
  description?: string;
  machineType: string;
  manufacturer?: string;
  model?: string;
  serialNumber?: string;
  purchaseDate?: Date;
  purchasePrice?: number;
  warrantyExpiryDate?: Date;
  locationId?: number;
  location?: Godown;
  departmentId?: number;
  department?: Department;
  status: string;
  isOperational: boolean;
  totalRunningHours?: number;
  lastMaintenanceDate?: Date;
  nextMaintenanceDate?: Date;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface SparePart {
  id: number;
  code: string;
  name: string;
  description?: string;
  categoryId?: number;
  category?: ItemCategory;
  unitId?: number;
  unit?: Unit;
  currentStock?: number;
  reorderLevel?: number;
  minimumStock?: number;
  costPrice?: number;
  compatibleMachines?: string;
  partNumber?: string;
  manufacturer?: string;
  leadTimeDays?: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface MaintenanceRequest {
  id: number;
  requestNumber: string;
  requestDate: Date;
  machineId: number;
  machine?: Machine;
  requestedById: number;
  requestedBy?: Employee;
  priority: string;
  issueDescription: string;
  assignedToId?: number;
  assignedTo?: Employee;
  assignedDate?: Date;
  scheduledDate?: Date;
  startedDate?: Date;
  completedDate?: Date;
  resolutionNotes?: string;
  estimatedCost?: number;
  actualCost?: number;
  sparePartIds?: number[];
  spareParts?: SparePart[];
  status: string;
  isEmergency: boolean;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface WorkOrder {
  id: number;
  orderNumber: string;
  orderDate: Date;
  machineId?: number;
  machine?: Machine;
  description?: string;
  priority?: string;
  startDate?: Date;
  endDate?: Date;
  estimatedHours?: number;
  actualHours?: number;
  estimatedCost?: number;
  actualCost?: number;
  assignedToId?: number;
  assignedTo?: Employee;
  status: string;
  completionNotes?: string;
  isActive: boolean;
  companyId?: number;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
  spareParts?: WorkOrderSparePart[];
}

export interface WorkOrderSparePart {
  id: number;
  workOrderId: number;
  workOrder?: WorkOrder;
  sparePartId: number;
  sparePart?: SparePart;
  quantity: number;
  unitCost?: number;
  totalCost?: number;
  consumedDate?: Date;
  isActive: boolean;
}

export interface DowntimeLog {
  id: number;
  machineId: number;
  machine?: Machine;
  startDate: Date;
  endDate?: Date;
  durationMinutes?: number;
  reason: string;
  downtimeType: string;
  maintenanceRequestId?: number;
  maintenanceRequest?: MaintenanceRequest;
  workOrderId?: number;
  workOrder?: WorkOrder;
  remarks?: string;
  isResolved: boolean;
  createdBy?: number;
  createdAt: Date;
  updatedAt?: Date;
}

export interface CostSummary {
  id: number;
  referenceType: string;
  referenceId?: number;
  referenceNumber?: string;
  category?: string;
  description?: string;
  amount: number;
  taxAmount?: number;
  totalAmount?: number;
  periodStartDate?: Date;
  periodEndDate?: Date;
  machineId?: number;
  machine?: Machine;
  departmentId?: number;
  department?: Department;
  financialYear?: string;
  companyId?: number;
  createdAt: Date;
  updatedAt?: Date;
}

export interface Transporter {
  id: number;
  code: string;
  name: string;
  gstin?: string;
  pan?: string;
  phone?: string;
  mobile?: string;
  email?: string;
  contactPerson?: string;
  address?: string;
  city?: string;
  stateId?: number;
  state?: StateMaster;
  transporterId?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
  vehicles?: Vehicle[];
}

export interface Vehicle {
  id: number;
  transporterId: number;
  transporter?: Transporter;
  vehicleNumber: string;
  vehicleType?: string;
  capacity?: number;
  capacityUnit?: string;
  driverName?: string;
  driverPhone?: string;
  licenseNumber?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface LedgerGroup {
  id: number;
  code: string;
  name: string;
  description?: string;
  parentId?: number;
  parent?: LedgerGroup;
  groupType?: string;
  affectsted: boolean;
  sortOrder?: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}

export interface Ledger {
  id: number;
  code: string;
  name: string;
  description?: string;
  ledgerGroupId: number;
  ledgerGroup?: LedgerGroup;
  openingBalance?: number;
  openingBalanceType?: string;
  currentBalance?: number;
  currentBalanceType?: string;
  partyId?: number;
  party?: Party;
  bankAccountId?: number;
  bankAccount?: BankAccount;
  isBillwise: boolean;
  isCostCentre: boolean;
  isActive: boolean;
  createdAt: Date;
  updatedAt?: Date;
}
