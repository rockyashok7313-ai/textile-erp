const express = require('express');
const Database = require('better-sqlite3');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

const JWT_KEY = 'YourSuperSecretKeyHereMustBeAtLeast32CharactersLong!!';
const JWT_ISSUER = 'TextileERP';
const JWT_AUDIENCE = 'TextileERPUsers';
const JWT_EXPIRY = '60m';

function hashPassword(pw) {
  return crypto.createHash('sha256').update(pw, 'utf8').digest('hex');
}

function getDb() {
  const dbPath = path.join('/tmp', 'textileerp.db');
  const db = new Database(dbPath);
  db.pragma('journal_mode = WAL');
  db.pragma('foreign_keys = ON');
  return db;
}

const db = getDb();

function now() { return new Date().toISOString(); }

function paginate(query, params, req) {
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.pageSize) || 50;
  const offset = (page - 1) * pageSize;
  const countSql = query.replace(/SELECT .+? FROM/, 'SELECT COUNT(*) as total FROM').replace(/ORDER BY .+$/, '');
  const total = db.prepare(countSql).get(params || {})?.total || 0;
  const data = db.prepare(query + ' LIMIT @pageSize OFFSET @offset').all({ ...(params || {}), pageSize, offset });
  return { data, total, page, pageSize, totalPages: Math.ceil(total / pageSize) };
}

function getCompanyId(req) {
  const user = db.prepare('SELECT CompanyId FROM Users WHERE Id = ?').get(req.userId);
  return user ? user.CompanyId : 1;
}

function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'No token provided' });
  }
  try {
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, JWT_KEY, { issuer: JWT_ISSUER, audience: JWT_AUDIENCE });
    req.userId = decoded.userId;
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
}

function generateToken(user) {
  return jwt.sign(
    { userId: user.Id, loginId: user.LoginId, isAdmin: user.IsAdmin },
    JWT_KEY,
    { expiresIn: JWT_EXPIRY, issuer: JWT_ISSUER, audience: JWT_AUDIENCE }
  );
}

function initDatabase() {
  const tableCheck = db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='Users'").get();
  if (tableCheck) return;

  db.exec(`
    CREATE TABLE Users (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, UserCode TEXT, UserName TEXT, LoginId TEXT, PasswordHash TEXT,
      Email TEXT, Mobile TEXT, CompanyId INTEGER, IsAdmin INTEGER DEFAULT 0, IsSuperAdmin INTEGER DEFAULT 0,
      IsApprover INTEGER DEFAULT 0, CanApprovePurchase INTEGER DEFAULT 0, CanApproveSales INTEGER DEFAULT 0,
      CanApprovePayment INTEGER DEFAULT 0, IsLocked INTEGER DEFAULT 0, LoginAttempts INTEGER DEFAULT 0,
      LastLoginDate TEXT, IsActive INTEGER DEFAULT 1, CreatedDate TEXT
    );
    CREATE TABLE Companies (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, CompanyCode TEXT, CompanyName TEXT, AddressLine1 TEXT, City TEXT,
      StateId INTEGER, StateCode TEXT, PinCode TEXT, Phone TEXT, Email TEXT, GSTIN TEXT, PAN TEXT, TAN TEXT,
      CountryId INTEGER, FiscalYearStartMonth INTEGER DEFAULT 4, IsActive INTEGER DEFAULT 1, CreatedDate TEXT
    );
    CREATE TABLE Countries (
      CountryId INTEGER PRIMARY KEY AUTOINCREMENT, CountryCode TEXT, CountryName TEXT, CurrencyCode TEXT,
      ISDCode TEXT, IsActive INTEGER DEFAULT 1
    );
    CREATE TABLE StateMasters (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, StateCode TEXT, StateName TEXT, StateShortName TEXT, StateType TEXT,
      IsActive INTEGER DEFAULT 1, CreatedDate TEXT
    );
    CREATE TABLE Items (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, ItemCode TEXT, ItemName TEXT, ItemCategoryId INTEGER, HSNCode TEXT,
      UnitId INTEGER, Description TEXT, Barcode TEXT, ReorderLevel REAL DEFAULT 0, ReorderQuantity REAL DEFAULT 0,
      SellingRate REAL DEFAULT 0, PurchaseRate REAL DEFAULT 0, GSTRateId INTEGER, IsActive INTEGER DEFAULT 1,
      CompanyId INTEGER, CreatedDate TEXT
    );
    CREATE TABLE ItemCategories (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, CategoryCode TEXT, CategoryName TEXT, IsActive INTEGER DEFAULT 1,
      CompanyId INTEGER, CreatedDate TEXT
    );
    CREATE TABLE Parties (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, PartyCode TEXT, PartyName TEXT, PartyType TEXT, GSTIN TEXT, PAN TEXT,
      ContactPerson TEXT, Phone TEXT, Email TEXT, AddressLine1 TEXT, AddressLine2 TEXT, City TEXT, StateId INTEGER,
      StateCode TEXT, PinCode TEXT, CreditLimit REAL DEFAULT 0, OutstandingBalance REAL DEFAULT 0,
      IsActive INTEGER DEFAULT 1, CompanyId INTEGER, CreatedDate TEXT
    );
    CREATE TABLE Units (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, UnitCode TEXT, UnitName TEXT, UnitType TEXT, IsActive INTEGER DEFAULT 1,
      CompanyId INTEGER
    );
    CREATE TABLE HSNMaster (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, HSNCode TEXT, Description TEXT, IsActive INTEGER DEFAULT 1
    );
    CREATE TABLE GSTRates (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, RateName TEXT, CGSTRate REAL, SGSTRate REAL, IGSTRate REAL,
      CessRate REAL, IsActive INTEGER DEFAULT 1
    );
    CREATE TABLE Godowns (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, GodownCode TEXT, GodownName TEXT, GodownAddress TEXT,
      IsMainGodown INTEGER DEFAULT 0, IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
    CREATE TABLE StockSummary (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, ItemId INTEGER, GodownId INTEGER, BatchNumber TEXT,
      Quantity REAL DEFAULT 0, ReservedQuantity REAL DEFAULT 0, UnitCost REAL DEFAULT 0, TotalValue REAL DEFAULT 0,
      LastUpdated TEXT, IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
    CREATE TABLE Employees (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, EmployeeCode TEXT, FirstName TEXT, LastName TEXT, DepartmentId INTEGER,
      DesignationId INTEGER, DateOfJoining TEXT, DateOfBirth TEXT, Gender TEXT, Phone TEXT, Email TEXT, Address TEXT,
      BasicSalary REAL DEFAULT 0, PFNumber TEXT, ESINumber TEXT, PAN TEXT, AadhaarNumber TEXT, BankName TEXT,
      BankAccountNumber TEXT, IFSCCode TEXT, IsActive INTEGER DEFAULT 1, CompanyId INTEGER, CreatedDate TEXT
    );
    CREATE TABLE Departments (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, DepartmentCode TEXT, DepartmentName TEXT, IsActive INTEGER DEFAULT 1,
      CompanyId INTEGER
    );
    CREATE TABLE Designations (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, DesignationCode TEXT, DesignationName TEXT, IsActive INTEGER DEFAULT 1,
      CompanyId INTEGER
    );
    CREATE TABLE Attendance (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, EmployeeId INTEGER, AttendanceDate TEXT, Status TEXT, CheckInTime TEXT,
      CheckOutTime TEXT, HoursWorked REAL DEFAULT 0, OvertimeHours REAL DEFAULT 0, Remarks TEXT,
      IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
    CREATE TABLE PayrollHeaders (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, PeriodId INTEGER, EmployeeId INTEGER, BasicSalary REAL DEFAULT 0,
      GrossEarnings REAL DEFAULT 0, TotalDeductions REAL DEFAULT 0, NetPayable REAL DEFAULT 0,
      Status TEXT DEFAULT 'Draft', ProcessedDate TEXT, ApprovedDate TEXT, IsActive INTEGER DEFAULT 1,
      CompanyId INTEGER
    );
    CREATE TABLE LeaveTypes (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, LeaveTypeCode TEXT, LeaveTypeName TEXT, DaysPerYear INTEGER DEFAULT 0,
      IsCarryForward INTEGER DEFAULT 0, IsPaid INTEGER DEFAULT 1, IsActive INTEGER DEFAULT 1, CompanyId INTEGER,
      SortOrder INTEGER DEFAULT 0
    );
    CREATE TABLE LeaveBalance (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, EmployeeId INTEGER, LeaveTypeId INTEGER, Year INTEGER,
      TotalDays INTEGER DEFAULT 0, UsedDays INTEGER DEFAULT 0, AdjustedDays INTEGER DEFAULT 0,
      IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
    CREATE TABLE SalaryHeads (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, HeadCode TEXT, HeadName TEXT, CalculationType TEXT, HeadType TEXT,
      BasedOn TEXT, DefaultPercent REAL DEFAULT 0, IsActive INTEGER DEFAULT 1, CompanyId INTEGER,
      SortOrder INTEGER DEFAULT 0
    );
    CREATE TABLE Machines (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, MachineCode TEXT, MachineName TEXT, MachineType TEXT, Make TEXT,
      Model TEXT, LoomCount INTEGER DEFAULT 1, Status TEXT DEFAULT 'Running', Location TEXT,
      IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
    CREATE TABLE SpareParts (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, SparePartCode TEXT, SparePartName TEXT, Description TEXT, Category TEXT,
      CompatibleMachineTypes TEXT, CurrentStock REAL DEFAULT 0, MinStock REAL DEFAULT 0, MaxStock REAL DEFAULT 0,
      ReorderLevel REAL DEFAULT 0, UnitCost REAL DEFAULT 0, IsCriticalSpare INTEGER DEFAULT 0,
      IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
    CREATE TABLE MaintenanceRequests (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, RequestNumber TEXT, MachineId INTEGER, ReportedBy INTEGER,
      Priority TEXT, Status TEXT, Description TEXT, AssignedTo INTEGER, CompletedDate TEXT, Cost REAL DEFAULT 0,
      Notes TEXT, IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
    CREATE TABLE WorkOrders (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, WorkOrderNumber TEXT, MachineId INTEGER, Description TEXT,
      Priority TEXT, Status TEXT, AssignedTo INTEGER, ScheduledDate TEXT, CompletedDate TEXT, Notes TEXT,
      IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
    CREATE TABLE WorkOrderSpareParts (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, WorkOrderId INTEGER, SparePartId INTEGER, Quantity REAL DEFAULT 0,
      UnitCost REAL DEFAULT 0, IsActive INTEGER DEFAULT 1
    );
    CREATE TABLE DowntimeLogs (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, MachineId INTEGER, StartTime TEXT, EndTime TEXT, Reason TEXT,
      Category TEXT, Notes TEXT, IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
    CREATE TABLE PurchaseInvoices (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, InvoiceNumber TEXT, SupplierId INTEGER, InvoiceDate TEXT,
      DueDate TEXT, SubTotal REAL DEFAULT 0, CGSTAmount REAL DEFAULT 0, SGSTAmount REAL DEFAULT 0,
      IGSTAmount REAL DEFAULT 0, TotalAmount REAL DEFAULT 0, Status TEXT DEFAULT 'Draft',
      IsActive INTEGER DEFAULT 1, CompanyId INTEGER, CreatedDate TEXT
    );
    CREATE TABLE PurchaseInvoiceDetails (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, InvoiceId INTEGER, ItemId INTEGER, Description TEXT,
      Quantity REAL DEFAULT 0, UnitRate REAL DEFAULT 0, Amount REAL DEFAULT 0, CGSTRate REAL DEFAULT 0,
      SGSTRate REAL DEFAULT 0, IGSTRate REAL DEFAULT 0, CGSTAmount REAL DEFAULT 0, SGSTAmount REAL DEFAULT 0,
      IGSTAmount REAL DEFAULT 0, TotalAmount REAL DEFAULT 0, IsActive INTEGER DEFAULT 1
    );
    CREATE TABLE SalesInvoices (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, InvoiceNumber TEXT, CustomerId INTEGER, InvoiceDate TEXT,
      DueDate TEXT, SubTotal REAL DEFAULT 0, CGSTAmount REAL DEFAULT 0, SGSTAmount REAL DEFAULT 0,
      IGSTAmount REAL DEFAULT 0, TotalAmount REAL DEFAULT 0, Status TEXT DEFAULT 'Draft',
      IsActive INTEGER DEFAULT 1, CompanyId INTEGER, CreatedDate TEXT
    );
    CREATE TABLE SalesInvoiceDetails (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, InvoiceId INTEGER, ItemId INTEGER, Description TEXT,
      Quantity REAL DEFAULT 0, UnitRate REAL DEFAULT 0, Amount REAL DEFAULT 0, CGSTRate REAL DEFAULT 0,
      SGSTRate REAL DEFAULT 0, IGSTRate REAL DEFAULT 0, CGSTAmount REAL DEFAULT 0, SGSTAmount REAL DEFAULT 0,
      IGSTAmount REAL DEFAULT 0, TotalAmount REAL DEFAULT 0, IsActive INTEGER DEFAULT 1
    );
    CREATE TABLE CostSummaries (
      Id INTEGER PRIMARY KEY AUTOINCREMENT, MachineId INTEGER, Period TEXT, MaintenanceCost REAL DEFAULT 0,
      SparePartCost REAL DEFAULT 0, DowntimeCost REAL DEFAULT 0, TotalCost REAL DEFAULT 0,
      IsActive INTEGER DEFAULT 1, CompanyId INTEGER
    );
  `);

  seedData();
}

function seedData() {
  const nowTs = now();
  const ins = db.prepare.bind(db);

  ins('INSERT INTO Countries (CountryCode, CountryName, CurrencyCode, ISDCode, IsActive) VALUES (?,?,?,?,1)').run('IN','India','INR','+91');

  const states = [
    ['AP','Andhra Pradesh','AP','State'],['AR','Arunachal Pradesh','AR','State'],['AS','Assam','AS','State'],
    ['BR','Bihar','BR','State'],['CG','Chhattisgarh','CG','State'],['GA','Goa','GA','State'],
    ['GJ','Gujarat','GJ','State'],['HR','Haryana','HR','State'],['HP','Himachal Pradesh','HP','State'],
    ['JH','Jharkhand','JH','State'],['KA','Karnataka','KA','State'],['KL','Kerala','KL','State'],
    ['MP','Madhya Pradesh','MP','State'],['MH','Maharashtra','MH','State'],['MN','Manipur','MN','State'],
    ['ML','Meghalaya','ML','State'],['MZ','Mizoram','MZ','State'],['NL','Nagaland','NL','State'],
    ['OD','Odisha','OD','State'],['PB','Punjab','PB','State'],['RJ','Rajasthan','RJ','State'],
    ['SK','Sikkim','SK','State'],['TN','Tamil Nadu','TN','State'],['TG','Telangana','TG','State'],
    ['TR','Tripura','TR','State'],['UP','Uttar Pradesh','UP','State'],['UT','Uttarakhand','UT','State'],
    ['WB','West Bengal','WB','State'],['AN','Andaman and Nicobar Islands','AN','UT'],
    ['CH','Chandigarh','CH','UT'],['DN','Dadra and Nagar Haveli','DN','UT'],
    ['DD','Daman and Diu','DD','UT'],['DL','Delhi','DL','UT'],['JK','Jammu and Kashmir','JK','UT'],
    ['LA','Ladakh','LA','UT'],['LD','Lakshadweep','LD','UT'],['PY','Puducherry','PY','UT'],
  ];
  const sStmt = db.prepare('INSERT INTO StateMasters (StateCode, StateName, StateShortName, StateType, IsActive, CreatedDate) VALUES (?,?,?,?,1,?)');
  for (const s of states) sStmt.run(s[0], s[1], s[2], s[3], nowTs);

  db.prepare('INSERT INTO Companies (CompanyCode, CompanyName, AddressLine1, City, StateId, StateCode, PinCode, Phone, Email, GSTIN, PAN, TAN, CountryId, IsActive, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,1,1,?)').run(
    'CMP-001', 'Textile ERP Demo Pvt Ltd', '123 Ring Road, Textile Market', 'Surat', 12, 'GJ', '395002', '+912612345678', 'info@textileerp-demo.in', '24AABCT1234F1Z5', 'AABCT1234F', 'MUMT1234F', 1, nowTs
  );

  db.prepare('INSERT INTO Users (UserCode, UserName, LoginId, PasswordHash, Email, Mobile, CompanyId, IsAdmin, IsSuperAdmin, IsActive, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,?)').run(
    'USR-001', 'Administrator', 'admin', hashPassword('admin123'), 'admin@textileerp-demo.in', '+919876543210', 1, 1, 1, 1, nowTs
  );

  const units = [['MTR','Metre','Length'],['YDS','Yard','Length'],['KGS','Kilogram','Weight'],['PCS','Piece','Count'],
    ['BAG','Bag','Count'],['RLL','Roll','Count'],['BOX','Box','Count'],['SET','Set','Count'],['NOS','Numbers','Count'],['DOZ','Dozen','Count']];
  const uStmt = db.prepare('INSERT INTO Units (UnitCode, UnitName, UnitType, IsActive, CompanyId) VALUES (?,?,?,1,1)');
  for (const u of units) uStmt.run(u[0], u[1], u[2]);

  const cats = [['FAB','Fabric'],['YRN','Yarn'],['DYE','Dyes & Chemicals'],['ACC','Accessories'],
    ['RMF','Raw Material Fiber'],['FGO','Finished Goods Other'],['SPR','Spares'],['HUF','Hutments & Furnishing']];
  const cStmt = db.prepare('INSERT INTO ItemCategories (CategoryCode, CategoryName, IsActive, CompanyId, CreatedDate) VALUES (?,?,1,1,?)');
  for (const c of cats) cStmt.run(c[0], c[1], nowTs);

  const depts = [['PROD','Production'],['QCA','Quality Control'],['MINT','Maintenance'],['WHSE','Warehouse'],
    ['ACCT','Accounts'],['SALE','Sales'],['PUR','Purchase'],['HR','Human Resources'],['ADMN','Administration'],['IT','Information Technology']];
  const dStmt = db.prepare('INSERT INTO Departments (DepartmentCode, DepartmentName, IsActive, CompanyId) VALUES (?,?,1,1)');
  for (const d of depts) dStmt.run(d[0], d[1]);

  const desigs = [['MGR','Manager'],['SUP','Supervisor'],['OPR','Operator'],['HEL','Helper'],
    ['TEC','Technician'],['ACCT','Accountant'],['CLERK','Clerk'],['HRM','HR Manager']];
  const dgStmt = db.prepare('INSERT INTO Designations (DesignationCode, DesignationName, IsActive, CompanyId) VALUES (?,?,1,1)');
  for (const d of desigs) dgStmt.run(d[0], d[1]);

  const leaveTypes = [['CL','Casual Leave',12,0,1],['SL','Sick Leave',6,0,1],['EL','Earned Leave',15,1,1],
    ['ML','Maternity Leave',182,0,1],['PL','Privilege Leave',10,1,1]];
  const ltStmt = db.prepare('INSERT INTO LeaveTypes (LeaveTypeCode, LeaveTypeName, DaysPerYear, IsCarryForward, IsPaid, IsActive, CompanyId, SortOrder) VALUES (?,?,?,?,?,1,1,?)');
  for (let i = 0; i < leaveTypes.length; i++) { const l = leaveTypes[i]; ltStmt.run(l[0], l[1], l[2], l[3], l[4], i + 1); }

  const salaryHeads = [
    ['BS','Basic Salary','Fixed','Earning','',0],['HRA','House Rent Allowance','Percent','Earning','BS',40],
    ['DA','Dearness Allowance','Percent','Earning','BS',30],['CONV','Conveyance Allowance','Fixed','Earning','',1600],
    ['MED','Medical Allowance','Fixed','Earning','',1250],
    ['PF_EE','PF - Employee','Percent','Deduction','BS',12],['PF_ER','PF - Employer','Percent','Deduction','BS',13.36],
    ['ESI_EE','ESI - Employee','Percent','Deduction','BS',0.75],['ESI_ER','ESI - Employer','Percent','Deduction','BS',3.25],
    ['PT','Professional Tax','Slab','Deduction','',200]
  ];
  const shStmt = db.prepare('INSERT INTO SalaryHeads (HeadCode, HeadName, CalculationType, HeadType, BasedOn, DefaultPercent, IsActive, CompanyId, SortOrder) VALUES (?,?,?,?,?,?,1,1,?)');
  for (let i = 0; i < salaryHeads.length; i++) { const h = salaryHeads[i]; shStmt.run(h[0], h[1], h[2], h[3], h[4], h[5], i + 1); }

  const machines = [
    ['MJ-001','AirJet Loom 1','AirJet','Toyota','JAT810',4,'Running','Unit A'],
    ['MJ-002','AirJet Loom 2','AirJet','Toyota','JAT810',4,'Running','Unit A'],
    ['MJ-003','AirJet Loom 3','AirJet','Toyota','JAT810',4,'Running','Unit A'],
    ['MJ-004','AirJet Loom 4','AirJet','Toyota','JAT710',4,'Running','Unit A'],
    ['MJ-005','AirJet Loom 5','AirJet','Toyota','JAT710',4,'Maintenance','Unit B'],
    ['MJ-006','AirJet Loom 6','AirJet','Tsudakoma','ZAX9100',4,'Running','Unit B'],
    ['MJ-007','AirJet Loom 7','AirJet','Tsudakoma','ZAX9100',4,'Running','Unit B'],
    ['MJ-008','AirJet Loom 8','AirJet','Picanol','OptiMax-i',4,'Running','Unit B'],
    ['SZ-001','Sulzer Loom 1','Sulzer','Sulzer','G6300',2,'Running','Unit C'],
    ['SZ-002','Sulzer Loom 2','Sulzer','Sulzer','G6300',2,'Running','Unit C'],
    ['SZ-003','Sulzer Loom 3','Sulzer','Sulzer','G6200',2,'Idle','Unit C'],
    ['SZ-004','Sulzer Loom 4','Sulzer','Sulzer','G6200',2,'Running','Unit D'],
    ['SZ-005','Sulzer Loom 5','Sulzer','Sulzer','L5100',2,'Running','Unit D'],
    ['SZ-006','Sulzer Loom 6','Sulzer','Sulzer','L5100',2,'Running','Unit D'],
  ];
  const mStmt = db.prepare('INSERT INTO Machines (MachineCode, MachineName, MachineType, Make, Model, LoomCount, Status, Location, IsActive, CompanyId) VALUES (?,?,?,?,?,?,?,?,1,1)');
  for (const m of machines) mStmt.run(m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7]);

  const spareParts = [
    ['SP-001','Nozzle Assembly','Main nozzle for air injection','Air Supply','AirJet',12,2,20,3,8500,1],
    ['SP-002','Weft Cutter Blade','Ceramic weft cutter blade','Cutting','AirJet,Sulzer',45,10,60,15,1200,0],
    ['SP-003','Reed','280cm reed for weaving','Weaving','AirJet,Sulzer',8,2,15,3,15000,1],
    ['SP-004','Warp Stop Motion Sensor','Electronic warp stop sensor','Detection','AirJet',18,5,25,8,3200,0],
    ['SP-005','Heald Frame Belt','Dobby heald frame driving belt','Drive','Sulzer',22,8,30,10,2800,0],
    ['SP-006','Air Compressor Valve','Inlet valve for air compressor','Air Supply','AirJet',6,2,12,3,4500,1],
    ['SP-007','Tempo Drive Motor','Main drive motor 5.5kW','Drive','Sulzer',3,1,6,2,18500,1],
    ['SP-008','Selvedge Cutter','Hot knife selvedge cutter','Cutting','AirJet',15,5,25,8,950,0],
    ['SP-009','Let-off Gear Box','Warp let-off reduction gearbox','Drive','AirJet,Sulzer',4,1,8,2,22000,1],
    ['SP-010','Drop Wire','Stainless steel drop wire','Detection','AirJet,Sulzer',200,50,400,80,85,0],
  ];
  const spStmt = db.prepare('INSERT INTO SpareParts (SparePartCode, SparePartName, Description, Category, CompatibleMachineTypes, CurrentStock, MinStock, MaxStock, ReorderLevel, UnitCost, IsCriticalSpare, IsActive, CompanyId) VALUES (?,?,?,?,?,?,?,?,?,?,?,1,1)');
  for (const s of spareParts) spStmt.run(s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8], s[9], s[10]);

  db.prepare('INSERT INTO Godowns (GodownCode, GodownName, GodownAddress, IsMainGodown, IsActive, CompanyId) VALUES (?,?,?,?,1,1)').run(
    'WH-001', 'Main Warehouse', 'Plot 45, GIDC Industrial Estate, Surat', 1
  );

  db.prepare("INSERT INTO GSTRates (RateName, CGSTRate, SGSTRate, IGSTRate, CessRate, IsActive) VALUES ('0%',0,0,0,0,1)").run();
  db.prepare("INSERT INTO GSTRates (RateName, CGSTRate, SGSTRate, IGSTRate, CessRate, IsActive) VALUES ('5%',2.5,2.5,5,0,1)").run();
  db.prepare("INSERT INTO GSTRates (RateName, CGSTRate, SGSTRate, IGSTRate, CessRate, IsActive) VALUES ('12%',6,6,12,0,1)").run();
  db.prepare("INSERT INTO GSTRates (RateName, CGSTRate, SGSTRate, IGSTRate, CessRate, IsActive) VALUES ('18%',9,9,18,0,1)").run();

  db.prepare("INSERT INTO HSNMaster (HSNCode, Description, IsActive) VALUES ('5208','Woven Fabrics of Cotton',1)").run();
  db.prepare("INSERT INTO HSNMaster (HSNCode, Description, IsActive) VALUES ('5513','Woven Fabrics of Polyester Blend',1)").run();
  db.prepare("INSERT INTO HSNMaster (HSNCode, Description, IsActive) VALUES ('5204','Cotton Yarn',1)").run();
  db.prepare("INSERT INTO HSNMaster (HSNCode, Description, IsActive) VALUES ('5402','Synthetic Filament Yarn',1)").run();
  db.prepare("INSERT INTO HSNMaster (HSNCode, Description, IsActive) VALUES ('3204','Synthetic Organic Dyes',1)").run();
  db.prepare("INSERT INTO HSNMaster (HSNCode, Description, IsActive) VALUES ('9607','Zippers',1)").run();

  const items = [
    ['FAB-001','Cotton Cambric 60x60',1,'5208',3,'Fine cotton cambric fabric 60x60 thread count','FAB001',150,500,285,210,2],
    ['FAB-002','Polyester Blend 58x54',2,'5513',3,'Poly-cotton blend fabric 58x54','FAB002',200,400,245,180,2],
    ['YRN-001','Cotton Yarn 40s',3,'5204',3,'40s count cotton ring spun yarn','YRN001',500,1000,320,265,2],
    ['YRN-002','Polyester Yarn 75D',4,'5402',3,'75 Denier polyester POY yarn','YRN002',400,800,210,175,2],
    ['DYE-001','Reactive Dye Blue',5,'3204',3,'Reactive blue dye for cellulosic fibers','DYE001',100,300,480,390,3],
    ['ACC-001','Zipper 12 inch',6,'9607',3,'12 inch metal zipper for garment finishing','ACC001',300,500,45,32,1],
  ];
  const iStmt = db.prepare('INSERT INTO Items (ItemCode, ItemName, ItemCategoryId, HSNCode, UnitId, Description, Barcode, ReorderLevel, ReorderQuantity, SellingRate, PurchaseRate, GSTRateId, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,1,1,?)');
  for (const i of items) iStmt.run(i[0], i[1], i[2], i[3], i[4], i[5], i[6], i[7], i[8], i[9], i[10], i[11], nowTs);

  const parties = [
    ['P-001','Maple Textiles Pvt Ltd','Customer','27AABCM1234F1Z5','AABCM1234F','Rajesh Sharma','+912225551234','rajesh@mapletextiles.com','45 MIDC Industrial Area','','Mumbai',14,'MH','400093',500000,0],
    ['P-002','Silk Route Exports','Customer','06AABCS5678G1Z5','AABCS5678G','Priya Mehta','+911242678901','priya@silkroute.co.in','Phase 2 Udyog Vihar','','Gurgaon',8,'HR','122015',750000,0],
    ['P-003','Cotton Corp Industries','Supplier','24AABCC9012H1Z5','AABCC9012H','Amit Patel','+917926574321','amit@cottoncorp.in','SG Highway Bodakdev','','Ahmedabad',12,'GJ','380054',0,0],
    ['P-004','DyeChem Solutions','Supplier','27AABCD3456J1Z5','AABCD3456J','Sanjay Kulkarni','+912025678901','sanjay@dyechem.in','Pimpri Chinchwad MIDC','','Pune',14,'MH','411018',0,0],
  ];
  const pStmt = db.prepare('INSERT INTO Parties (PartyCode, PartyName, PartyType, GSTIN, PAN, ContactPerson, Phone, Email, AddressLine1, AddressLine2, City, StateId, StateCode, PinCode, CreditLimit, OutstandingBalance, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,1,?)');
  for (const p of parties) pStmt.run(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15], nowTs);

  const stocks = [
    [1,1,'BATCH-001',850,0,210,178500],
    [2,1,'BATCH-002',1200,0,180,216000],
    [3,1,'BATCH-003',2500,0,265,662500],
    [4,1,'BATCH-004',1800,0,175,315000],
    [5,1,'BATCH-005',60,0,390,23400],
    [6,1,'BATCH-006',2000,0,32,64000],
  ];
  const stStmt = db.prepare('INSERT INTO StockSummary (ItemId, GodownId, BatchNumber, Quantity, ReservedQuantity, UnitCost, TotalValue, LastUpdated, IsActive, CompanyId) VALUES (?,?,?,?,?,?,?,?,1,1)');
  for (const s of stocks) stStmt.run(s[0], s[1], s[2], s[3], s[4], s[5], s[6], nowTs);

  db.prepare('INSERT INTO SalesInvoices (InvoiceNumber, CustomerId, InvoiceDate, DueDate, SubTotal, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, Status, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,1,1,?)').run(
    'SINV-001', 1, '2026-01-15', '2026-02-15', 142500, 12825, 12825, 0, 168150, 'Posted', nowTs
  );
  db.prepare('INSERT INTO SalesInvoiceDetails (InvoiceId, ItemId, Description, Quantity, UnitRate, Amount, CGSTRate, SGSTRate, IGSTRate, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, IsActive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)').run(
    1, 1, 'Cotton Cambric 60x60', 500, 285, 142500, 9, 9, 0, 12825, 12825, 0, 168150
  );

  db.prepare('INSERT INTO SalesInvoices (InvoiceNumber, CustomerId, InvoiceDate, DueDate, SubTotal, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, Status, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,1,1,?)').run(
    'SINV-002', 2, '2026-02-10', '2026-03-12', 184000, 16560, 16560, 0, 217120, 'Draft', nowTs
  );
  db.prepare('INSERT INTO SalesInvoiceDetails (InvoiceId, ItemId, Description, Quantity, UnitRate, Amount, CGSTRate, SGSTRate, IGSTRate, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, IsActive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)').run(
    2, 3, 'Cotton Yarn 40s', 400, 320, 128000, 9, 9, 0, 11520, 11520, 0, 151040
  );
  db.prepare('INSERT INTO SalesInvoiceDetails (InvoiceId, ItemId, Description, Quantity, UnitRate, Amount, CGSTRate, SGSTRate, IGSTRate, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, IsActive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)').run(
    2, 4, 'Polyester Yarn 75D', 320, 175, 56000, 9, 9, 0, 5040, 5040, 0, 66080
  );

  db.prepare('INSERT INTO PurchaseInvoices (InvoiceNumber, SupplierId, InvoiceDate, DueDate, SubTotal, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, Status, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,1,1,?)').run(
    'PINV-001', 3, '2026-01-20', '2026-03-21', 265000, 23850, 23850, 0, 312700, 'Posted', nowTs
  );
  db.prepare('INSERT INTO PurchaseInvoiceDetails (InvoiceId, ItemId, Description, Quantity, UnitRate, Amount, CGSTRate, SGSTRate, IGSTRate, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, IsActive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)').run(
    1, 3, 'Cotton Yarn 40s', 1000, 265, 265000, 9, 9, 0, 23850, 23850, 0, 312700
  );

  db.prepare('INSERT INTO PurchaseInvoices (InvoiceNumber, SupplierId, InvoiceDate, DueDate, SubTotal, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, Status, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,1,1,?)').run(
    'PINV-002', 4, '2026-02-05', '2026-03-07', 39000, 3510, 3510, 0, 46020, 'Draft', nowTs
  );
  db.prepare('INSERT INTO PurchaseInvoiceDetails (InvoiceId, ItemId, Description, Quantity, UnitRate, Amount, CGSTRate, SGSTRate, IGSTRate, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, IsActive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)').run(
    2, 5, 'Reactive Dye Blue', 100, 390, 39000, 9, 9, 0, 3510, 3510, 0, 46020
  );
}

initDatabase();

// ============== AUTH ==============

app.post('/api/auth/login', (req, res) => {
  try {
    const { username, loginId, password } = req.body;
    const loginName = username || loginId;
    const user = db.prepare('SELECT * FROM Users WHERE (LoginId = ? OR UserName = ?) AND IsActive = 1').get(loginName, loginName);
    if (!user) return res.status(401).json({ message: 'Invalid credentials' });
    if (user.IsLocked) return res.status(423).json({ message: 'Account is locked' });
    if (user.PasswordHash !== hashPassword(password)) {
      db.prepare('UPDATE Users SET LoginAttempts = LoginAttempts + 1 WHERE Id = ?').run(user.Id);
      if (user.LoginAttempts + 1 >= 5) db.prepare('UPDATE Users SET IsLocked = 1 WHERE Id = ?').run(user.Id);
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    db.prepare('UPDATE Users SET LoginAttempts = 0, LastLoginDate = ? WHERE Id = ?').run(now(), user.Id);
    const token = generateToken(user);
    const refreshToken = jwt.sign({ userId: user.Id, type: 'refresh' }, JWT_KEY, { expiresIn: '7d', issuer: JWT_ISSUER, audience: JWT_AUDIENCE });
    const expiresAt = new Date(Date.now() + 60 * 60 * 1000).toISOString();
    const company = db.prepare('SELECT CompanyName FROM Companies WHERE Id = ?').get(user.CompanyId);
    res.json({
      token, refreshToken, expiresAt,
      user: { id: user.Id, username: user.UserName, fullName: user.UserName, email: user.Email, companyId: user.CompanyId, companyName: company?.CompanyName, isActive: true, department: '', designation: '', createdAt: now() }
    });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/auth/refresh', (req, res) => {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) return res.status(400).json({ message: 'Refresh token required' });
    const decoded = jwt.verify(refreshToken, JWT_KEY, { issuer: JWT_ISSUER, audience: JWT_AUDIENCE });
    if (decoded.type !== 'refresh') return res.status(401).json({ message: 'Invalid token type' });
    const user = db.prepare('SELECT * FROM Users WHERE Id = ? AND IsActive = 1').get(decoded.userId);
    if (!user) return res.status(401).json({ message: 'User not found' });
    const company = db.prepare('SELECT CompanyName FROM Companies WHERE Id = ?').get(user.CompanyId);
    const expiresAt = new Date(Date.now() + 60 * 60 * 1000).toISOString();
    const newRefreshToken = jwt.sign({ userId: user.Id, type: 'refresh' }, JWT_KEY, { expiresIn: '7d', issuer: JWT_ISSUER, audience: JWT_AUDIENCE });
    res.json({ token: generateToken(user), refreshToken: newRefreshToken, expiresAt, user: { id: user.Id, username: user.UserName, fullName: user.UserName, email: user.Email, companyId: user.CompanyId, companyName: company?.CompanyName, isActive: true, department: '', designation: '', createdAt: now() } });
  } catch (err) { res.status(401).json({ message: 'Invalid refresh token' }); }
});

app.get('/api/auth/me', authMiddleware, (req, res) => {
  try {
    const user = db.prepare('SELECT Id, UserCode, UserName, LoginId, Email, Mobile, CompanyId, IsAdmin, IsSuperAdmin, IsApprover, CanApprovePurchase, CanApproveSales, CanApprovePayment, IsActive FROM Users WHERE Id = ?').get(req.userId);
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/auth/changepassword', authMiddleware, (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    const user = db.prepare('SELECT * FROM Users WHERE Id = ?').get(req.userId);
    if (!user || user.PasswordHash !== hashPassword(currentPassword)) return res.status(400).json({ message: 'Current password is incorrect' });
    db.prepare('UPDATE Users SET PasswordHash = ? WHERE Id = ?').run(hashPassword(newPassword), req.userId);
    res.json({ message: 'Password changed successfully' });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== ITEMS ==============

app.get('/api/item', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT i.*, ic.CategoryName, u.UnitName FROM Items i LEFT JOIN ItemCategories ic ON i.ItemCategoryId = ic.Id LEFT JOIN Units u ON i.UnitId = u.Id WHERE i.IsActive = 1 AND i.CompanyId = @companyId ORDER BY i.Id', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/item/textile', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const data = db.prepare('SELECT i.*, ic.CategoryName, u.UnitName FROM Items i LEFT JOIN ItemCategories ic ON i.ItemCategoryId = ic.Id LEFT JOIN Units u ON i.UnitId = u.Id WHERE i.IsActive = 1 AND i.CompanyId = ? AND ic.CategoryCode IN ("FAB","YRN","RMF") ORDER BY i.Id').all(companyId);
    res.json(data);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/item/lowstock', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const data = db.prepare('SELECT i.*, ic.CategoryName, u.UnitName, COALESCE(SUM(s.Quantity),0) as CurrentStock FROM Items i LEFT JOIN ItemCategories ic ON i.ItemCategoryId = ic.Id LEFT JOIN Units u ON i.UnitId = u.Id LEFT JOIN StockSummary s ON s.ItemId = i.Id AND s.IsActive = 1 WHERE i.IsActive = 1 AND i.CompanyId = ? GROUP BY i.Id HAVING CurrentStock <= i.ReorderLevel ORDER BY i.Id').all(companyId);
    res.json(data);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/item/bycode/:code', authMiddleware, (req, res) => {
  try {
    const item = db.prepare('SELECT * FROM Items WHERE ItemCode = ? AND IsActive = 1').get(req.params.code);
    if (!item) return res.status(404).json({ message: 'Item not found' });
    res.json(item);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/item/bybarcode/:barcode', authMiddleware, (req, res) => {
  try {
    const item = db.prepare('SELECT * FROM Items WHERE Barcode = ? AND IsActive = 1').get(req.params.barcode);
    if (!item) return res.status(404).json({ message: 'Item not found' });
    res.json(item);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/item/bycategory/:categoryId', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const data = db.prepare('SELECT i.*, ic.CategoryName, u.UnitName FROM Items i LEFT JOIN ItemCategories ic ON i.ItemCategoryId = ic.Id LEFT JOIN Units u ON i.UnitId = u.Id WHERE i.ItemCategoryId = ? AND i.IsActive = 1 AND i.CompanyId = ? ORDER BY i.Id').all(req.params.categoryId, companyId);
    res.json(data);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/item/:id', authMiddleware, (req, res) => {
  try {
    const item = db.prepare('SELECT i.*, ic.CategoryName, u.UnitName FROM Items i LEFT JOIN ItemCategories ic ON i.ItemCategoryId = ic.Id LEFT JOIN Units u ON i.UnitId = u.Id WHERE i.Id = ? AND i.IsActive = 1').get(req.params.id);
    if (!item) return res.status(404).json({ message: 'Item not found' });
    res.json(item);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/item', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const result = db.prepare('INSERT INTO Items (ItemCode, ItemName, ItemCategoryId, HSNCode, UnitId, Description, Barcode, ReorderLevel, ReorderQuantity, SellingRate, PurchaseRate, GSTRateId, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,1,?,?)').run(b.ItemCode, b.ItemName, b.ItemCategoryId, b.HSNCode, b.UnitId, b.Description, b.Barcode, b.ReorderLevel || 0, b.ReorderQuantity || 0, b.SellingRate || 0, b.PurchaseRate || 0, b.GSTRateId, companyId, now());
    const item = db.prepare('SELECT * FROM Items WHERE Id = ?').get(result.lastInsertRowid);
    res.status(201).json(item);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.put('/api/item/:id', authMiddleware, (req, res) => {
  try {
    const b = req.body;
    const existing = db.prepare('SELECT * FROM Items WHERE Id = ?').get(req.params.id);
    if (!existing) return res.status(404).json({ message: 'Item not found' });
    db.prepare('UPDATE Items SET ItemCode=?, ItemName=?, ItemCategoryId=?, HSNCode=?, UnitId=?, Description=?, Barcode=?, ReorderLevel=?, ReorderQuantity=?, SellingRate=?, PurchaseRate=?, GSTRateId=? WHERE Id=?').run(
      b.ItemCode || existing.ItemCode, b.ItemName || existing.ItemName, b.ItemCategoryId || existing.ItemCategoryId, b.HSNCode || existing.HSNCode, b.UnitId || existing.UnitId, b.Description ?? existing.Description, b.Barcode ?? existing.Barcode, b.ReorderLevel ?? existing.ReorderLevel, b.ReorderQuantity ?? existing.ReorderQuantity, b.SellingRate ?? existing.SellingRate, b.PurchaseRate ?? existing.PurchaseRate, b.GSTRateId || existing.GSTRateId, req.params.id
    );
    res.json(db.prepare('SELECT * FROM Items WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/item/:id', authMiddleware, (req, res) => {
  try { db.prepare('UPDATE Items SET IsActive = 0 WHERE Id = ?').run(req.params.id); res.json({ message: 'Item deleted' }); } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== PARTIES ==============

app.get('/api/party', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT * FROM Parties WHERE IsActive = 1 AND CompanyId = @companyId ORDER BY Id', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/party/customers', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT * FROM Parties WHERE PartyType = ? AND IsActive = 1 AND CompanyId = ? ORDER BY Id').all('Customer', companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/party/suppliers', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT * FROM Parties WHERE PartyType = ? AND IsActive = 1 AND CompanyId = ? ORDER BY Id').all('Supplier', companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/party/bycode/:code', authMiddleware, (req, res) => {
  try {
    const party = db.prepare('SELECT * FROM Parties WHERE PartyCode = ? AND IsActive = 1').get(req.params.code);
    if (!party) return res.status(404).json({ message: 'Party not found' });
    res.json(party);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/party/bygstin/:gstin', authMiddleware, (req, res) => {
  try {
    const party = db.prepare('SELECT * FROM Parties WHERE GSTIN = ? AND IsActive = 1').get(req.params.gstin);
    if (!party) return res.status(404).json({ message: 'Party not found' });
    res.json(party);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/party/:id', authMiddleware, (req, res) => {
  try {
    const party = db.prepare('SELECT * FROM Parties WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!party) return res.status(404).json({ message: 'Party not found' });
    res.json(party);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/party', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const result = db.prepare('INSERT INTO Parties (PartyCode, PartyName, PartyType, GSTIN, PAN, ContactPerson, Phone, Email, AddressLine1, AddressLine2, City, StateId, StateCode, PinCode, CreditLimit, OutstandingBalance, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?)').run(b.PartyCode, b.PartyName, b.PartyType, b.GSTIN, b.PAN, b.ContactPerson, b.Phone, b.Email, b.AddressLine1, b.AddressLine2, b.City, b.StateId, b.StateCode, b.PinCode, b.CreditLimit || 0, b.OutstandingBalance || 0, companyId, now());
    res.status(201).json(db.prepare('SELECT * FROM Parties WHERE Id = ?').get(result.lastInsertRowid));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.put('/api/party/:id', authMiddleware, (req, res) => {
  try {
    const b = req.body;
    const existing = db.prepare('SELECT * FROM Parties WHERE Id = ?').get(req.params.id);
    if (!existing) return res.status(404).json({ message: 'Party not found' });
    db.prepare('UPDATE Parties SET PartyCode=?, PartyName=?, PartyType=?, GSTIN=?, PAN=?, ContactPerson=?, Phone=?, Email=?, AddressLine1=?, AddressLine2=?, City=?, StateId=?, StateCode=?, PinCode=?, CreditLimit=?, OutstandingBalance=? WHERE Id=?').run(
      b.PartyCode || existing.PartyCode, b.PartyName || existing.PartyName, b.PartyType || existing.PartyType, b.GSTIN ?? existing.GSTIN, b.PAN ?? existing.PAN, b.ContactPerson ?? existing.ContactPerson, b.Phone ?? existing.Phone, b.Email ?? existing.Email, b.AddressLine1 ?? existing.AddressLine1, b.AddressLine2 ?? existing.AddressLine2, b.City ?? existing.City, b.StateId || existing.StateId, b.StateCode || existing.StateCode, b.PinCode ?? existing.PinCode, b.CreditLimit ?? existing.CreditLimit, b.OutstandingBalance ?? existing.OutstandingBalance, req.params.id
    );
    res.json(db.prepare('SELECT * FROM Parties WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/party/:id', authMiddleware, (req, res) => {
  try { db.prepare('UPDATE Parties SET IsActive = 0 WHERE Id = ?').run(req.params.id); res.json({ message: 'Party deleted' }); } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== STOCK ==============

app.get('/api/stock', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT s.*, i.ItemCode, i.ItemName, g.GodownCode, g.GodownName FROM StockSummary s LEFT JOIN Items i ON s.ItemId = i.Id LEFT JOIN Godowns g ON s.GodownId = g.Id WHERE s.IsActive = 1 AND s.CompanyId = @companyId ORDER BY s.Id', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/stock/lowstock', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const data = db.prepare('SELECT s.*, i.ItemCode, i.ItemName, i.ReorderLevel, g.GodownCode FROM StockSummary s LEFT JOIN Items i ON s.ItemId = i.Id LEFT JOIN Godowns g ON s.GodownId = g.Id WHERE s.IsActive = 1 AND s.CompanyId = ? AND s.Quantity <= i.ReorderLevel ORDER BY s.Id').all(companyId);
    res.json(data);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/stock/byitem/:itemId', authMiddleware, (req, res) => {
  try {
    res.json(db.prepare('SELECT s.*, g.GodownCode, g.GodownName FROM StockSummary s LEFT JOIN Godowns g ON s.GodownId = g.Id WHERE s.ItemId = ? AND s.IsActive = 1 ORDER BY s.Id').all(req.params.itemId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/stock/:id', authMiddleware, (req, res) => {
  try {
    const stock = db.prepare('SELECT s.*, i.ItemCode, i.ItemName, g.GodownCode, g.GodownName FROM StockSummary s LEFT JOIN Items i ON s.ItemId = i.Id LEFT JOIN Godowns g ON s.GodownId = g.Id WHERE s.Id = ? AND s.IsActive = 1').get(req.params.id);
    if (!stock) return res.status(404).json({ message: 'Stock record not found' });
    res.json(stock);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/stock/update', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const { itemId, godownId, batchNumber, quantity, unitCost } = req.body;
    const existing = db.prepare('SELECT * FROM StockSummary WHERE ItemId = ? AND GodownId = ? AND BatchNumber = ? AND IsActive = 1').get(itemId, godownId, batchNumber);
    if (existing) {
      const newQty = existing.Quantity + quantity;
      const newVal = newQty * unitCost;
      db.prepare('UPDATE StockSummary SET Quantity = ?, TotalValue = ?, UnitCost = ?, LastUpdated = ? WHERE Id = ?').run(newQty, newVal, unitCost, now(), existing.Id);
      res.json(db.prepare('SELECT * FROM StockSummary WHERE Id = ?').get(existing.Id));
    } else {
      const result = db.prepare('INSERT INTO StockSummary (ItemId, GodownId, BatchNumber, Quantity, ReservedQuantity, UnitCost, TotalValue, LastUpdated, IsActive, CompanyId) VALUES (?,?,?, ?,0,?,?,?,1,?)').run(itemId, godownId, batchNumber, quantity, unitCost, quantity * unitCost, now(), companyId);
      res.status(201).json(db.prepare('SELECT * FROM StockSummary WHERE Id = ?').get(result.lastInsertRowid));
    }
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== SALES INVOICES ==============

app.get('/api/salesinvoice', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT si.*, p.PartyName as CustomerName FROM SalesInvoices si LEFT JOIN Parties p ON si.CustomerId = p.Id WHERE si.IsActive = 1 AND si.CompanyId = @companyId ORDER BY si.Id DESC', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/salesinvoice/bynumber/:number', authMiddleware, (req, res) => {
  try {
    const inv = db.prepare('SELECT si.*, p.PartyName as CustomerName FROM SalesInvoices si LEFT JOIN Parties p ON si.CustomerId = p.Id WHERE si.InvoiceNumber = ? AND si.IsActive = 1').get(req.params.number);
    if (!inv) return res.status(404).json({ message: 'Invoice not found' });
    const details = db.prepare('SELECT sid.*, i.ItemCode, i.ItemName FROM SalesInvoiceDetails sid LEFT JOIN Items i ON sid.ItemId = i.Id WHERE sid.InvoiceId = ? AND sid.IsActive = 1').all(inv.Id);
    res.json({ ...inv, details });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/salesinvoice/bycustomer/:customerId', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT si.*, p.PartyName as CustomerName FROM SalesInvoices si LEFT JOIN Parties p ON si.CustomerId = p.Id WHERE si.CustomerId = ? AND si.IsActive = 1 AND si.CompanyId = ? ORDER BY si.Id DESC').all(req.params.customerId, companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/salesinvoice/:id', authMiddleware, (req, res) => {
  try {
    const inv = db.prepare('SELECT si.*, p.PartyName as CustomerName FROM SalesInvoices si LEFT JOIN Parties p ON si.CustomerId = p.Id WHERE si.Id = ? AND si.IsActive = 1').get(req.params.id);
    if (!inv) return res.status(404).json({ message: 'Invoice not found' });
    const details = db.prepare('SELECT sid.*, i.ItemCode, i.ItemName FROM SalesInvoiceDetails sid LEFT JOIN Items i ON sid.ItemId = i.Id WHERE sid.InvoiceId = ? AND sid.IsActive = 1').all(inv.Id);
    res.json({ ...inv, details });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/salesinvoice', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const maxNum = db.prepare('SELECT MAX(CAST(SUBSTR(InvoiceNumber, 6) AS INTEGER)) as maxNum FROM SalesInvoices').get();
    const nextNum = (maxNum?.maxNum || 0) + 1;
    const invoiceNumber = b.InvoiceNumber || `SINV-${String(nextNum).padStart(3, '0')}`;
    const result = db.prepare('INSERT INTO SalesInvoices (InvoiceNumber, CustomerId, InvoiceDate, DueDate, SubTotal, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, Status, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,\'Draft\',1,?,?)').run(invoiceNumber, b.CustomerId, b.InvoiceDate, b.DueDate, b.SubTotal || 0, b.CGSTAmount || 0, b.SGSTAmount || 0, b.IGSTAmount || 0, b.TotalAmount || 0, companyId, now());
    if (b.details && Array.isArray(b.details)) {
      const stmt = db.prepare('INSERT INTO SalesInvoiceDetails (InvoiceId, ItemId, Description, Quantity, UnitRate, Amount, CGSTRate, SGSTRate, IGSTRate, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, IsActive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)');
      for (const d of b.details) stmt.run(result.lastInsertRowid, d.ItemId, d.Description, d.Quantity, d.UnitRate, d.Amount, d.CGSTRate || 0, d.SGSTRate || 0, d.IGSTRate || 0, d.CGSTAmount || 0, d.SGSTAmount || 0, d.IGSTAmount || 0, d.TotalAmount || 0);
    }
    const inv = db.prepare('SELECT * FROM SalesInvoices WHERE Id = ?').get(result.lastInsertRowid);
    const details = db.prepare('SELECT * FROM SalesInvoiceDetails WHERE InvoiceId = ? AND IsActive = 1').all(inv.Id);
    res.status(201).json({ ...inv, details });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.put('/api/salesinvoice/:id', authMiddleware, (req, res) => {
  try {
    const b = req.body;
    const existing = db.prepare('SELECT * FROM SalesInvoices WHERE Id = ?').get(req.params.id);
    if (!existing) return res.status(404).json({ message: 'Invoice not found' });
    if (existing.Status === 'Posted') return res.status(400).json({ message: 'Cannot edit posted invoice' });
    db.prepare('UPDATE SalesInvoices SET CustomerId=?, InvoiceDate=?, DueDate=?, SubTotal=?, CGSTAmount=?, SGSTAmount=?, IGSTAmount=?, TotalAmount=? WHERE Id=?').run(b.CustomerId || existing.CustomerId, b.InvoiceDate || existing.InvoiceDate, b.DueDate || existing.DueDate, b.SubTotal ?? existing.SubTotal, b.CGSTAmount ?? existing.CGSTAmount, b.SGSTAmount ?? existing.SGSTAmount, b.IGSTAmount ?? existing.IGSTAmount, b.TotalAmount ?? existing.TotalAmount, req.params.id);
    if (b.details && Array.isArray(b.details)) {
      db.prepare('UPDATE SalesInvoiceDetails SET IsActive = 0 WHERE InvoiceId = ?').run(req.params.id);
      const stmt = db.prepare('INSERT INTO SalesInvoiceDetails (InvoiceId, ItemId, Description, Quantity, UnitRate, Amount, CGSTRate, SGSTRate, IGSTRate, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, IsActive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)');
      for (const d of b.details) stmt.run(req.params.id, d.ItemId, d.Description, d.Quantity, d.UnitRate, d.Amount, d.CGSTRate || 0, d.SGSTRate || 0, d.IGSTRate || 0, d.CGSTAmount || 0, d.SGSTAmount || 0, d.IGSTAmount || 0, d.TotalAmount || 0);
    }
    const inv = db.prepare('SELECT * FROM SalesInvoices WHERE Id = ?').get(req.params.id);
    const details = db.prepare('SELECT * FROM SalesInvoiceDetails WHERE InvoiceId = ? AND IsActive = 1').all(inv.Id);
    res.json({ ...inv, details });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/salesinvoice/:id', authMiddleware, (req, res) => {
  try {
    const existing = db.prepare('SELECT * FROM SalesInvoices WHERE Id = ?').get(req.params.id);
    if (!existing) return res.status(404).json({ message: 'Invoice not found' });
    if (existing.Status === 'Posted') return res.status(400).json({ message: 'Cannot delete posted invoice' });
    db.prepare('UPDATE SalesInvoices SET IsActive = 0 WHERE Id = ?').run(req.params.id);
    db.prepare('UPDATE SalesInvoiceDetails SET IsActive = 0 WHERE InvoiceId = ?').run(req.params.id);
    res.json({ message: 'Invoice deleted' });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/salesinvoice/:id/post', authMiddleware, (req, res) => {
  try {
    const inv = db.prepare('SELECT * FROM SalesInvoices WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!inv) return res.status(404).json({ message: 'Invoice not found' });
    if (inv.Status === 'Posted') return res.status(400).json({ message: 'Invoice already posted' });
    db.prepare('UPDATE SalesInvoices SET Status = ? WHERE Id = ?').run('Posted', req.params.id);
    const details = db.prepare('SELECT * FROM SalesInvoiceDetails WHERE InvoiceId = ? AND IsActive = 1').all(req.params.id);
    for (const d of details) {
      const existing = db.prepare('SELECT * FROM StockSummary WHERE ItemId = ? AND GodownId = 1 AND IsActive = 1').get(d.ItemId);
      if (existing) {
        const newQty = existing.Quantity - d.Quantity;
        db.prepare('UPDATE StockSummary SET Quantity = ?, TotalValue = ?, LastUpdated = ? WHERE Id = ?').run(newQty, newQty * existing.UnitCost, now(), existing.Id);
      }
    }
    res.json(db.prepare('SELECT * FROM SalesInvoices WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== PURCHASE INVOICES ==============

app.get('/api/purchaseinvoice', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT pi.*, p.PartyName as SupplierName FROM PurchaseInvoices pi LEFT JOIN Parties p ON pi.SupplierId = p.Id WHERE pi.IsActive = 1 AND pi.CompanyId = @companyId ORDER BY pi.Id DESC', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/purchaseinvoice/bynumber/:number', authMiddleware, (req, res) => {
  try {
    const inv = db.prepare('SELECT pi.*, p.PartyName as SupplierName FROM PurchaseInvoices pi LEFT JOIN Parties p ON pi.SupplierId = p.Id WHERE pi.InvoiceNumber = ? AND pi.IsActive = 1').get(req.params.number);
    if (!inv) return res.status(404).json({ message: 'Invoice not found' });
    const details = db.prepare('SELECT pid.*, i.ItemCode, i.ItemName FROM PurchaseInvoiceDetails pid LEFT JOIN Items i ON pid.ItemId = i.Id WHERE pid.InvoiceId = ? AND pid.IsActive = 1').all(inv.Id);
    res.json({ ...inv, details });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/purchaseinvoice/bysupplier/:supplierId', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT pi.*, p.PartyName as SupplierName FROM PurchaseInvoices pi LEFT JOIN Parties p ON pi.SupplierId = p.Id WHERE pi.SupplierId = ? AND pi.IsActive = 1 AND pi.CompanyId = ? ORDER BY pi.Id DESC').all(req.params.supplierId, companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/purchaseinvoice/:id', authMiddleware, (req, res) => {
  try {
    const inv = db.prepare('SELECT pi.*, p.PartyName as SupplierName FROM PurchaseInvoices pi LEFT JOIN Parties p ON pi.SupplierId = p.Id WHERE pi.Id = ? AND pi.IsActive = 1').get(req.params.id);
    if (!inv) return res.status(404).json({ message: 'Invoice not found' });
    const details = db.prepare('SELECT pid.*, i.ItemCode, i.ItemName FROM PurchaseInvoiceDetails pid LEFT JOIN Items i ON pid.ItemId = i.Id WHERE pid.InvoiceId = ? AND pid.IsActive = 1').all(inv.Id);
    res.json({ ...inv, details });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/purchaseinvoice', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const maxNum = db.prepare('SELECT MAX(CAST(SUBSTR(InvoiceNumber, 6) AS INTEGER)) as maxNum FROM PurchaseInvoices').get();
    const nextNum = (maxNum?.maxNum || 0) + 1;
    const invoiceNumber = b.InvoiceNumber || `PINV-${String(nextNum).padStart(3, '0')}`;
    const result = db.prepare('INSERT INTO PurchaseInvoices (InvoiceNumber, SupplierId, InvoiceDate, DueDate, SubTotal, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, Status, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,\'Draft\',1,?,?)').run(invoiceNumber, b.SupplierId, b.InvoiceDate, b.DueDate, b.SubTotal || 0, b.CGSTAmount || 0, b.SGSTAmount || 0, b.IGSTAmount || 0, b.TotalAmount || 0, companyId, now());
    if (b.details && Array.isArray(b.details)) {
      const stmt = db.prepare('INSERT INTO PurchaseInvoiceDetails (InvoiceId, ItemId, Description, Quantity, UnitRate, Amount, CGSTRate, SGSTRate, IGSTRate, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, IsActive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)');
      for (const d of b.details) stmt.run(result.lastInsertRowid, d.ItemId, d.Description, d.Quantity, d.UnitRate, d.Amount, d.CGSTRate || 0, d.SGSTRate || 0, d.IGSTRate || 0, d.CGSTAmount || 0, d.SGSTAmount || 0, d.IGSTAmount || 0, d.TotalAmount || 0);
    }
    const inv = db.prepare('SELECT * FROM PurchaseInvoices WHERE Id = ?').get(result.lastInsertRowid);
    const details = db.prepare('SELECT * FROM PurchaseInvoiceDetails WHERE InvoiceId = ? AND IsActive = 1').all(inv.Id);
    res.status(201).json({ ...inv, details });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.put('/api/purchaseinvoice/:id', authMiddleware, (req, res) => {
  try {
    const b = req.body;
    const existing = db.prepare('SELECT * FROM PurchaseInvoices WHERE Id = ?').get(req.params.id);
    if (!existing) return res.status(404).json({ message: 'Invoice not found' });
    if (existing.Status === 'Posted') return res.status(400).json({ message: 'Cannot edit posted invoice' });
    db.prepare('UPDATE PurchaseInvoices SET SupplierId=?, InvoiceDate=?, DueDate=?, SubTotal=?, CGSTAmount=?, SGSTAmount=?, IGSTAmount=?, TotalAmount=? WHERE Id=?').run(b.SupplierId || existing.SupplierId, b.InvoiceDate || existing.InvoiceDate, b.DueDate || existing.DueDate, b.SubTotal ?? existing.SubTotal, b.CGSTAmount ?? existing.CGSTAmount, b.SGSTAmount ?? existing.SGSTAmount, b.IGSTAmount ?? existing.IGSTAmount, b.TotalAmount ?? existing.TotalAmount, req.params.id);
    if (b.details && Array.isArray(b.details)) {
      db.prepare('UPDATE PurchaseInvoiceDetails SET IsActive = 0 WHERE InvoiceId = ?').run(req.params.id);
      const stmt = db.prepare('INSERT INTO PurchaseInvoiceDetails (InvoiceId, ItemId, Description, Quantity, UnitRate, Amount, CGSTRate, SGSTRate, IGSTRate, CGSTAmount, SGSTAmount, IGSTAmount, TotalAmount, IsActive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)');
      for (const d of b.details) stmt.run(req.params.id, d.ItemId, d.Description, d.Quantity, d.UnitRate, d.Amount, d.CGSTRate || 0, d.SGSTRate || 0, d.IGSTRate || 0, d.CGSTAmount || 0, d.SGSTAmount || 0, d.IGSTAmount || 0, d.TotalAmount || 0);
    }
    const inv = db.prepare('SELECT * FROM PurchaseInvoices WHERE Id = ?').get(req.params.id);
    const details = db.prepare('SELECT * FROM PurchaseInvoiceDetails WHERE InvoiceId = ? AND IsActive = 1').all(inv.Id);
    res.json({ ...inv, details });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/purchaseinvoice/:id', authMiddleware, (req, res) => {
  try {
    const existing = db.prepare('SELECT * FROM PurchaseInvoices WHERE Id = ?').get(req.params.id);
    if (!existing) return res.status(404).json({ message: 'Invoice not found' });
    if (existing.Status === 'Posted') return res.status(400).json({ message: 'Cannot delete posted invoice' });
    db.prepare('UPDATE PurchaseInvoices SET IsActive = 0 WHERE Id = ?').run(req.params.id);
    db.prepare('UPDATE PurchaseInvoiceDetails SET IsActive = 0 WHERE InvoiceId = ?').run(req.params.id);
    res.json({ message: 'Invoice deleted' });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/purchaseinvoice/:id/post', authMiddleware, (req, res) => {
  try {
    const inv = db.prepare('SELECT * FROM PurchaseInvoices WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!inv) return res.status(404).json({ message: 'Invoice not found' });
    if (inv.Status === 'Posted') return res.status(400).json({ message: 'Invoice already posted' });
    db.prepare('UPDATE PurchaseInvoices SET Status = ? WHERE Id = ?').run('Posted', req.params.id);
    const details = db.prepare('SELECT * FROM PurchaseInvoiceDetails WHERE InvoiceId = ? AND IsActive = 1').all(req.params.id);
    for (const d of details) {
      const existing = db.prepare('SELECT * FROM StockSummary WHERE ItemId = ? AND GodownId = 1 AND IsActive = 1').get(d.ItemId);
      if (existing) {
        const newQty = existing.Quantity + d.Quantity;
        db.prepare('UPDATE StockSummary SET Quantity = ?, TotalValue = ?, LastUpdated = ? WHERE Id = ?').run(newQty, newQty * existing.UnitCost, now(), existing.Id);
      } else {
        db.prepare('INSERT INTO StockSummary (ItemId, GodownId, BatchNumber, Quantity, ReservedQuantity, UnitCost, TotalValue, LastUpdated, IsActive, CompanyId) VALUES (?,1,?,?,?,?,?,?,1,?)').run(d.ItemId, `BATCH-${Date.now()}`, d.Quantity, 0, d.UnitRate, d.Quantity * d.UnitRate, now(), getCompanyId(req));
      }
    }
    res.json(db.prepare('SELECT * FROM PurchaseInvoices WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== EMPLOYEES ==============

app.get('/api/employee', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT e.*, d.DepartmentName, dg.DesignationName FROM Employees e LEFT JOIN Departments d ON e.DepartmentId = d.Id LEFT JOIN Designations dg ON e.DesignationId = dg.Id WHERE e.IsActive = 1 AND e.CompanyId = @companyId ORDER BY e.Id', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/employee/active', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT e.*, d.DepartmentName, dg.DesignationName FROM Employees e LEFT JOIN Departments d ON e.DepartmentId = d.Id LEFT JOIN Designations dg ON e.DesignationId = dg.Id WHERE e.IsActive = 1 AND e.CompanyId = ? ORDER BY e.FirstName').all(companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/employee/bydepartment/:departmentId', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT e.*, d.DepartmentName, dg.DesignationName FROM Employees e LEFT JOIN Departments d ON e.DepartmentId = d.Id LEFT JOIN Designations dg ON e.DesignationId = dg.Id WHERE e.DepartmentId = ? AND e.IsActive = 1 AND e.CompanyId = ? ORDER BY e.FirstName').all(req.params.departmentId, companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/employee/:id', authMiddleware, (req, res) => {
  try {
    const emp = db.prepare('SELECT e.*, d.DepartmentName, dg.DesignationName FROM Employees e LEFT JOIN Departments d ON e.DepartmentId = d.Id LEFT JOIN Designations dg ON e.DesignationId = dg.Id WHERE e.Id = ? AND e.IsActive = 1').get(req.params.id);
    if (!emp) return res.status(404).json({ message: 'Employee not found' });
    res.json(emp);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/employee', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const result = db.prepare('INSERT INTO Employees (EmployeeCode, FirstName, LastName, DepartmentId, DesignationId, DateOfJoining, DateOfBirth, Gender, Phone, Email, Address, BasicSalary, PFNumber, ESINumber, PAN, AadhaarNumber, BankName, BankAccountNumber, IFSCCode, IsActive, CompanyId, CreatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?)').run(b.EmployeeCode, b.FirstName, b.LastName, b.DepartmentId, b.DesignationId, b.DateOfJoining, b.DateOfBirth, b.Gender, b.Phone, b.Email, b.Address, b.BasicSalary || 0, b.PFNumber, b.ESINumber, b.PAN, b.AadhaarNumber, b.BankName, b.BankAccountNumber, b.IFSCCode, companyId, now());
    res.status(201).json(db.prepare('SELECT * FROM Employees WHERE Id = ?').get(result.lastInsertRowid));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.put('/api/employee/:id', authMiddleware, (req, res) => {
  try {
    const b = req.body;
    const existing = db.prepare('SELECT * FROM Employees WHERE Id = ?').get(req.params.id);
    if (!existing) return res.status(404).json({ message: 'Employee not found' });
    db.prepare('UPDATE Employees SET EmployeeCode=?, FirstName=?, LastName=?, DepartmentId=?, DesignationId=?, DateOfJoining=?, DateOfBirth=?, Gender=?, Phone=?, Email=?, Address=?, BasicSalary=?, PFNumber=?, ESINumber=?, PAN=?, AadhaarNumber=?, BankName=?, BankAccountNumber=?, IFSCCode=? WHERE Id=?').run(
      b.EmployeeCode || existing.EmployeeCode, b.FirstName || existing.FirstName, b.LastName || existing.LastName, b.DepartmentId || existing.DepartmentId, b.DesignationId || existing.DesignationId, b.DateOfJoining || existing.DateOfJoining, b.DateOfBirth || existing.DateOfBirth, b.Gender || existing.Gender, b.Phone ?? existing.Phone, b.Email ?? existing.Email, b.Address ?? existing.Address, b.BasicSalary ?? existing.BasicSalary, b.PFNumber ?? existing.PFNumber, b.ESINumber ?? existing.ESINumber, b.PAN ?? existing.PAN, b.AadhaarNumber ?? existing.AadhaarNumber, b.BankName ?? existing.BankName, b.BankAccountNumber ?? existing.BankAccountNumber, b.IFSCCode ?? existing.IFSCCode, req.params.id
    );
    res.json(db.prepare('SELECT * FROM Employees WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/employee/:id', authMiddleware, (req, res) => {
  try { db.prepare('UPDATE Employees SET IsActive = 0 WHERE Id = ?').run(req.params.id); res.json({ message: 'Employee deleted' }); } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== ATTENDANCE ==============

app.get('/api/attendance/employee/:employeeId', authMiddleware, (req, res) => {
  try {
    res.json(db.prepare('SELECT a.*, e.FirstName, e.LastName FROM Attendance a LEFT JOIN Employees e ON a.EmployeeId = e.Id WHERE a.EmployeeId = ? AND a.IsActive = 1 ORDER BY a.AttendanceDate DESC').all(req.params.employeeId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/attendance/date/:date', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT a.*, e.FirstName, e.LastName, e.EmployeeCode FROM Attendance a LEFT JOIN Employees e ON a.EmployeeId = e.Id WHERE a.AttendanceDate = ? AND a.IsActive = 1 AND a.CompanyId = ? ORDER BY e.FirstName').all(req.params.date, companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/attendance', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const existing = db.prepare('SELECT * FROM Attendance WHERE EmployeeId = ? AND AttendanceDate = ? AND IsActive = 1').get(b.EmployeeId, b.AttendanceDate);
    if (existing) {
      db.prepare('UPDATE Attendance SET Status=?, CheckInTime=?, CheckOutTime=?, HoursWorked=?, OvertimeHours=?, Remarks=? WHERE Id=?').run(b.Status, b.CheckInTime, b.CheckOutTime, b.HoursWorked || 0, b.OvertimeHours || 0, b.Remarks, existing.Id);
      res.json(db.prepare('SELECT * FROM Attendance WHERE Id = ?').get(existing.Id));
    } else {
      const result = db.prepare('INSERT INTO Attendance (EmployeeId, AttendanceDate, Status, CheckInTime, CheckOutTime, HoursWorked, OvertimeHours, Remarks, IsActive, CompanyId) VALUES (?,?,?,?,?,?,?,?,1,?)').run(b.EmployeeId, b.AttendanceDate, b.Status, b.CheckInTime, b.CheckOutTime, b.HoursWorked || 0, b.OvertimeHours || 0, b.Remarks, companyId);
      res.status(201).json(db.prepare('SELECT * FROM Attendance WHERE Id = ?').get(result.lastInsertRowid));
    }
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/attendance/summary/:employeeId', authMiddleware, (req, res) => {
  try {
    const { year, month } = req.query;
    let query = 'SELECT Status, COUNT(*) as Count FROM Attendance WHERE EmployeeId = ? AND IsActive = 1';
    const params = [req.params.employeeId];
    if (year && month) {
      query += " AND strftime('%Y', AttendanceDate) = ? AND strftime('%m', AttendanceDate) = ?";
      params.push(year, String(month).padStart(2, '0'));
    }
    query += ' GROUP BY Status';
    const summary = db.prepare(query).all(...params);
    let hoursQuery = 'SELECT SUM(HoursWorked) as totalHours, SUM(OvertimeHours) as totalOvertime FROM Attendance WHERE EmployeeId = ? AND IsActive = 1';
    const hParams = [req.params.employeeId];
    if (year && month) {
      hoursQuery += " AND strftime('%Y', AttendanceDate) = ? AND strftime('%m', AttendanceDate) = ?";
      hParams.push(year, String(month).padStart(2, '0'));
    }
    const totalHours = db.prepare(hoursQuery).get(...hParams);
    res.json({ summary, totalHours: totalHours?.totalHours || 0, totalOvertime: totalHours?.totalOvertime || 0 });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== PAYROLL ==============

app.get('/api/payroll', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT ph.*, e.FirstName, e.LastName, e.EmployeeCode FROM PayrollHeaders ph LEFT JOIN Employees e ON ph.EmployeeId = e.Id WHERE ph.IsActive = 1 AND ph.CompanyId = @companyId ORDER BY ph.Id DESC', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/payroll/:id', authMiddleware, (req, res) => {
  try {
    const payroll = db.prepare('SELECT ph.*, e.FirstName, e.LastName, e.EmployeeCode, e.BasicSalary as EmpBasicSalary FROM PayrollHeaders ph LEFT JOIN Employees e ON ph.EmployeeId = e.Id WHERE ph.Id = ? AND ph.IsActive = 1').get(req.params.id);
    if (!payroll) return res.status(404).json({ message: 'Payroll record not found' });
    res.json(payroll);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/payroll/process', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const { periodId, employeeIds } = req.body;
    let emps;
    if (employeeIds && employeeIds.length) {
      const placeholders = employeeIds.map(() => '?').join(',');
      emps = db.prepare(`SELECT * FROM Employees WHERE Id IN (${placeholders}) AND IsActive = 1 AND CompanyId = ?`).all(...employeeIds, companyId);
    } else {
      emps = db.prepare('SELECT * FROM Employees WHERE IsActive = 1 AND CompanyId = ?').all(companyId);
    }
    const results = [];
    for (const emp of emps) {
      const existing = db.prepare('SELECT * FROM PayrollHeaders WHERE PeriodId = ? AND EmployeeId = ? AND IsActive = 1').get(periodId, emp.Id);
      if (existing) continue;
      const bs = emp.BasicSalary;
      const gross = bs + (bs * 0.4) + (bs * 0.3) + 1600 + 1250;
      const totalDeductions = (bs * 0.12) + (gross * 0.0075) + 200;
      const netPayable = gross - totalDeductions;
      const result = db.prepare('INSERT INTO PayrollHeaders (PeriodId, EmployeeId, BasicSalary, GrossEarnings, TotalDeductions, NetPayable, Status, ProcessedDate, IsActive, CompanyId) VALUES (?,?,?,?,?,?,?,?,1,?)').run(periodId, emp.Id, bs, gross, totalDeductions, netPayable, 'Processed', now(), companyId);
      results.push(db.prepare('SELECT * FROM PayrollHeaders WHERE Id = ?').get(result.lastInsertRowid));
    }
    res.status(201).json(results);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/payroll/:id/approve', authMiddleware, (req, res) => {
  try {
    const payroll = db.prepare('SELECT * FROM PayrollHeaders WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!payroll) return res.status(404).json({ message: 'Payroll record not found' });
    if (payroll.Status !== 'Processed') return res.status(400).json({ message: 'Can only approve processed payroll' });
    db.prepare('UPDATE PayrollHeaders SET Status = ?, ApprovedDate = ? WHERE Id = ?').run('Approved', now(), req.params.id);
    res.json(db.prepare('SELECT * FROM PayrollHeaders WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/payroll/:id/cancel', authMiddleware, (req, res) => {
  try {
    const payroll = db.prepare('SELECT * FROM PayrollHeaders WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!payroll) return res.status(404).json({ message: 'Payroll record not found' });
    if (payroll.Status === 'Approved') return res.status(400).json({ message: 'Cannot cancel approved payroll' });
    db.prepare('UPDATE PayrollHeaders SET Status = ? WHERE Id = ?').run('Cancelled', req.params.id);
    res.json(db.prepare('SELECT * FROM PayrollHeaders WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== LEAVE ==============

app.get('/api/leave/types/:companyId', authMiddleware, (req, res) => {
  try {
    res.json(db.prepare('SELECT * FROM LeaveTypes WHERE IsActive = 1 AND CompanyId = ? ORDER BY SortOrder').all(req.params.companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/leave/balance/:employeeId', authMiddleware, (req, res) => {
  try {
    const yr = req.query.year || new Date().getFullYear();
    res.json(db.prepare('SELECT lb.*, lt.LeaveTypeCode, lt.LeaveTypeName, lt.DaysPerYear FROM LeaveBalance lb LEFT JOIN LeaveTypes lt ON lb.LeaveTypeId = lt.Id WHERE lb.EmployeeId = ? AND lb.Year = ? AND lb.IsActive = 1').all(req.params.employeeId, yr));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/leave/apply', authMiddleware, (req, res) => {
  try {
    const { employeeId, leaveTypeId, year } = req.body;
    const companyId = getCompanyId(req);
    const existing = db.prepare('SELECT * FROM LeaveBalance WHERE EmployeeId = ? AND LeaveTypeId = ? AND Year = ? AND IsActive = 1').get(employeeId, leaveTypeId, year);
    if (!existing) {
      const lt = db.prepare('SELECT * FROM LeaveTypes WHERE Id = ?').get(leaveTypeId);
      db.prepare('INSERT INTO LeaveBalance (EmployeeId, LeaveTypeId, Year, TotalDays, UsedDays, AdjustedDays, IsActive, CompanyId) VALUES (?,?,?,?,?,?,1,?)').run(employeeId, leaveTypeId, year, lt ? lt.DaysPerYear : 0, 1, 0, companyId);
    } else {
      db.prepare('UPDATE LeaveBalance SET UsedDays = UsedDays + 1 WHERE Id = ?').run(existing.Id);
    }
    res.json({ message: 'Leave applied' });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/leave/adjust', authMiddleware, (req, res) => {
  try {
    const { employeeId, leaveTypeId, year, adjustedDays } = req.body;
    const existing = db.prepare('SELECT * FROM LeaveBalance WHERE EmployeeId = ? AND LeaveTypeId = ? AND Year = ? AND IsActive = 1').get(employeeId, leaveTypeId, year);
    if (existing) db.prepare('UPDATE LeaveBalance SET AdjustedDays = ? WHERE Id = ?').run(adjustedDays, existing.Id);
    res.json({ message: 'Leave adjusted' });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== MACHINES ==============

app.get('/api/machine', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT * FROM Machines WHERE IsActive = 1 AND CompanyId = @companyId ORDER BY Id', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/machine/bytype/:type', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT * FROM Machines WHERE MachineType = ? AND IsActive = 1 AND CompanyId = ? ORDER BY Id').all(req.params.type, companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/machine/bystatus/:status', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT * FROM Machines WHERE Status = ? AND IsActive = 1 AND CompanyId = ? ORDER BY Id').all(req.params.status, companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/machine/:id', authMiddleware, (req, res) => {
  try {
    const machine = db.prepare('SELECT * FROM Machines WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!machine) return res.status(404).json({ message: 'Machine not found' });
    res.json(machine);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/machine', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const result = db.prepare('INSERT INTO Machines (MachineCode, MachineName, MachineType, Make, Model, LoomCount, Status, Location, IsActive, CompanyId) VALUES (?,?,?,?,?,?,?,?,1,?)').run(b.MachineCode, b.MachineName, b.MachineType, b.Make, b.Model, b.LoomCount || 1, b.Status || 'Running', b.Location, companyId);
    res.status(201).json(db.prepare('SELECT * FROM Machines WHERE Id = ?').get(result.lastInsertRowid));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.put('/api/machine/:id', authMiddleware, (req, res) => {
  try {
    const b = req.body;
    const existing = db.prepare('SELECT * FROM Machines WHERE Id = ?').get(req.params.id);
    if (!existing) return res.status(404).json({ message: 'Machine not found' });
    db.prepare('UPDATE Machines SET MachineCode=?, MachineName=?, MachineType=?, Make=?, Model=?, LoomCount=?, Status=?, Location=? WHERE Id=?').run(
      b.MachineCode || existing.MachineCode, b.MachineName || existing.MachineName, b.MachineType || existing.MachineType,
      b.Make ?? existing.Make, b.Model ?? existing.Model, b.LoomCount ?? existing.LoomCount,
      b.Status || existing.Status, b.Location ?? existing.Location, req.params.id
    );
    res.json(db.prepare('SELECT * FROM Machines WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/machine/:id', authMiddleware, (req, res) => {
  try { db.prepare('UPDATE Machines SET IsActive = 0 WHERE Id = ?').run(req.params.id); res.json({ message: 'Machine deleted' }); } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== SPARE PARTS ==============

app.get('/api/sparepart', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT * FROM SpareParts WHERE IsActive = 1 AND CompanyId = @companyId ORDER BY Id', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/sparepart/bycategory/:category', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT * FROM SpareParts WHERE Category = ? AND IsActive = 1 AND CompanyId = ? ORDER BY Id').all(req.params.category, companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/sparepart/lowstock', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT * FROM SpareParts WHERE IsActive = 1 AND CompanyId = ? AND CurrentStock <= ReorderLevel ORDER BY Id').all(companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/sparepart/:id', authMiddleware, (req, res) => {
  try {
    const sp = db.prepare('SELECT * FROM SpareParts WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!sp) return res.status(404).json({ message: 'Spare part not found' });
    res.json(sp);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/sparepart', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const result = db.prepare('INSERT INTO SpareParts (SparePartCode, SparePartName, Description, Category, CompatibleMachineTypes, CurrentStock, MinStock, MaxStock, ReorderLevel, UnitCost, IsCriticalSpare, IsActive, CompanyId) VALUES (?,?,?,?,?,?,?,?,?,?,?,1,?)').run(b.SparePartCode, b.SparePartName, b.Description, b.Category, b.CompatibleMachineTypes, b.CurrentStock || 0, b.MinStock || 0, b.MaxStock || 0, b.ReorderLevel || 0, b.UnitCost || 0, b.IsCriticalSpare || 0, companyId);
    res.status(201).json(db.prepare('SELECT * FROM SpareParts WHERE Id = ?').get(result.lastInsertRowid));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.put('/api/sparepart/:id', authMiddleware, (req, res) => {
  try {
    const b = req.body;
    const existing = db.prepare('SELECT * FROM SpareParts WHERE Id = ?').get(req.params.id);
    if (!existing) return res.status(404).json({ message: 'Spare part not found' });
    db.prepare('UPDATE SpareParts SET SparePartCode=?, SparePartName=?, Description=?, Category=?, CompatibleMachineTypes=?, CurrentStock=?, MinStock=?, MaxStock=?, ReorderLevel=?, UnitCost=?, IsCriticalSpare=? WHERE Id=?').run(
      b.SparePartCode || existing.SparePartCode, b.SparePartName || existing.SparePartName, b.Description ?? existing.Description,
      b.Category || existing.Category, b.CompatibleMachineTypes ?? existing.CompatibleMachineTypes, b.CurrentStock ?? existing.CurrentStock,
      b.MinStock ?? existing.MinStock, b.MaxStock ?? existing.MaxStock, b.ReorderLevel ?? existing.ReorderLevel,
      b.UnitCost ?? existing.UnitCost, b.IsCriticalSpare ?? existing.IsCriticalSpare, req.params.id
    );
    res.json(db.prepare('SELECT * FROM SpareParts WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/sparepart/:id', authMiddleware, (req, res) => {
  try { db.prepare('UPDATE SpareParts SET IsActive = 0 WHERE Id = ?').run(req.params.id); res.json({ message: 'Spare part deleted' }); } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/sparepart/:id/consume', authMiddleware, (req, res) => {
  try {
    const sp = db.prepare('SELECT * FROM SpareParts WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!sp) return res.status(404).json({ message: 'Spare part not found' });
    const { quantity } = req.body;
    if (sp.CurrentStock < quantity) return res.status(400).json({ message: 'Insufficient stock' });
    db.prepare('UPDATE SpareParts SET CurrentStock = CurrentStock - ? WHERE Id = ?').run(quantity, req.params.id);
    res.json(db.prepare('SELECT * FROM SpareParts WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/sparepart/:id/restock', authMiddleware, (req, res) => {
  try {
    const sp = db.prepare('SELECT * FROM SpareParts WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!sp) return res.status(404).json({ message: 'Spare part not found' });
    const { quantity } = req.body;
    db.prepare('UPDATE SpareParts SET CurrentStock = CurrentStock + ? WHERE Id = ?').run(quantity, req.params.id);
    res.json(db.prepare('SELECT * FROM SpareParts WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== MAINTENANCE REQUESTS ==============

app.get('/api/maintenance/requests', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate(`SELECT mr.*, m.MachineName, m.MachineCode, emp.FirstName || ' ' || emp.LastName as ReportedByName, asg.FirstName || ' ' || asg.LastName as AssignedToName FROM MaintenanceRequests mr LEFT JOIN Machines m ON mr.MachineId = m.Id LEFT JOIN Employees emp ON mr.ReportedBy = emp.Id LEFT JOIN Employees asg ON mr.AssignedTo = asg.Id WHERE mr.IsActive = 1 AND mr.CompanyId = @companyId ORDER BY mr.Id DESC`, { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/maintenance/requests/bymachine/:machineId', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare(`SELECT mr.*, m.MachineName, m.MachineCode FROM MaintenanceRequests mr LEFT JOIN Machines m ON mr.MachineId = m.Id WHERE mr.MachineId = ? AND mr.IsActive = 1 AND mr.CompanyId = ? ORDER BY mr.Id DESC`).all(req.params.machineId, companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/maintenance/requests/:id', authMiddleware, (req, res) => {
  try {
    const mr = db.prepare(`SELECT mr.*, m.MachineName, m.MachineCode, emp.FirstName || ' ' || emp.LastName as ReportedByName, asg.FirstName || ' ' || asg.LastName as AssignedToName FROM MaintenanceRequests mr LEFT JOIN Machines m ON mr.MachineId = m.Id LEFT JOIN Employees emp ON mr.ReportedBy = emp.Id LEFT JOIN Employees asg ON mr.AssignedTo = asg.Id WHERE mr.Id = ? AND mr.IsActive = 1`).get(req.params.id);
    if (!mr) return res.status(404).json({ message: 'Maintenance request not found' });
    res.json(mr);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/maintenance/requests', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const maxNum = db.prepare('SELECT MAX(CAST(SUBSTR(RequestNumber, 4) AS INTEGER)) as maxNum FROM MaintenanceRequests').get();
    const nextNum = (maxNum?.maxNum || 0) + 1;
    const result = db.prepare('INSERT INTO MaintenanceRequests (RequestNumber, MachineId, ReportedBy, Priority, Status, Description, AssignedTo, Cost, Notes, IsActive, CompanyId) VALUES (?,?,?,?,?,?,?,?,?,1,?)').run(b.RequestNumber || `MR-${String(nextNum).padStart(3, '0')}`, b.MachineId, b.ReportedBy, b.Priority || 'Medium', b.Status || 'Open', b.Description, b.AssignedTo, b.Cost || 0, b.Notes, companyId);
    res.status(201).json(db.prepare('SELECT * FROM MaintenanceRequests WHERE Id = ?').get(result.lastInsertRowid));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/maintenance/requests/:id/assign', authMiddleware, (req, res) => {
  try {
    const { assignedTo } = req.body;
    const mr = db.prepare('SELECT * FROM MaintenanceRequests WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!mr) return res.status(404).json({ message: 'Maintenance request not found' });
    db.prepare('UPDATE MaintenanceRequests SET AssignedTo = ?, Status = ? WHERE Id = ?').run(assignedTo, 'Assigned', req.params.id);
    res.json(db.prepare('SELECT * FROM MaintenanceRequests WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/maintenance/requests/:id/complete', authMiddleware, (req, res) => {
  try {
    const { cost, notes } = req.body;
    const mr = db.prepare('SELECT * FROM MaintenanceRequests WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!mr) return res.status(404).json({ message: 'Maintenance request not found' });
    db.prepare('UPDATE MaintenanceRequests SET Status = ?, CompletedDate = ?, Cost = ?, Notes = ? WHERE Id = ?').run('Completed', now(), cost || mr.Cost, notes || mr.Notes, req.params.id);
    res.json(db.prepare('SELECT * FROM MaintenanceRequests WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== WORK ORDERS ==============

app.get('/api/maintenance/workorders', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate(`SELECT wo.*, m.MachineName, m.MachineCode, emp.FirstName || ' ' || emp.LastName as AssignedToName FROM WorkOrders wo LEFT JOIN Machines m ON wo.MachineId = m.Id LEFT JOIN Employees emp ON wo.AssignedTo = emp.Id WHERE wo.IsActive = 1 AND wo.CompanyId = @companyId ORDER BY wo.Id DESC`, { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/maintenance/workorders/:id', authMiddleware, (req, res) => {
  try {
    const wo = db.prepare(`SELECT wo.*, m.MachineName, m.MachineCode, emp.FirstName || ' ' || emp.LastName as AssignedToName FROM WorkOrders wo LEFT JOIN Machines m ON wo.MachineId = m.Id LEFT JOIN Employees emp ON wo.AssignedTo = emp.Id WHERE wo.Id = ? AND wo.IsActive = 1`).get(req.params.id);
    if (!wo) return res.status(404).json({ message: 'Work order not found' });
    const spareParts = db.prepare('SELECT wos.*, sp.SparePartCode, sp.SparePartName FROM WorkOrderSpareParts wos LEFT JOIN SpareParts sp ON wos.SparePartId = sp.Id WHERE wos.WorkOrderId = ? AND wos.IsActive = 1').all(req.params.id);
    res.json({ ...wo, spareParts });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/maintenance/workorders', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const b = req.body;
    const maxNum = db.prepare('SELECT MAX(CAST(SUBSTR(WorkOrderNumber, 4) AS INTEGER)) as maxNum FROM WorkOrders').get();
    const nextNum = (maxNum?.maxNum || 0) + 1;
    const result = db.prepare('INSERT INTO WorkOrders (WorkOrderNumber, MachineId, Description, Priority, Status, AssignedTo, ScheduledDate, Notes, IsActive, CompanyId) VALUES (?,?,?,?,?,?,?,?,1,?)').run(b.WorkOrderNumber || `WO-${String(nextNum).padStart(3, '0')}`, b.MachineId, b.Description, b.Priority || 'Medium', b.Status || 'Open', b.AssignedTo, b.ScheduledDate, b.Notes, companyId);
    if (b.spareParts && Array.isArray(b.spareParts)) {
      const stmt = db.prepare('INSERT INTO WorkOrderSpareParts (WorkOrderId, SparePartId, Quantity, UnitCost, IsActive) VALUES (?,?,?,?,1)');
      for (const sp of b.spareParts) stmt.run(result.lastInsertRowid, sp.SparePartId, sp.Quantity, sp.UnitCost);
    }
    const wo = db.prepare('SELECT * FROM WorkOrders WHERE Id = ?').get(result.lastInsertRowid);
    const spareParts = db.prepare('SELECT * FROM WorkOrderSpareParts WHERE WorkOrderId = ? AND IsActive = 1').all(wo.Id);
    res.status(201).json({ ...wo, spareParts });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/maintenance/workorders/:id/complete', authMiddleware, (req, res) => {
  try {
    const wo = db.prepare('SELECT * FROM WorkOrders WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!wo) return res.status(404).json({ message: 'Work order not found' });
    db.prepare('UPDATE WorkOrders SET Status = ?, CompletedDate = ? WHERE Id = ?').run('Completed', now(), req.params.id);
    const spareParts = db.prepare('SELECT * FROM WorkOrderSpareParts WHERE WorkOrderId = ? AND IsActive = 1').all(req.params.id);
    for (const sp of spareParts) {
      const spare = db.prepare('SELECT * FROM SpareParts WHERE Id = ?').get(sp.SparePartId);
      if (spare) db.prepare('UPDATE SpareParts SET CurrentStock = CurrentStock - ? WHERE Id = ?').run(sp.Quantity, sp.SparePartId);
    }
    res.json(db.prepare('SELECT * FROM WorkOrders WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/maintenance/workorders/:id/cancel', authMiddleware, (req, res) => {
  try {
    const wo = db.prepare('SELECT * FROM WorkOrders WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!wo) return res.status(404).json({ message: 'Work order not found' });
    db.prepare('UPDATE WorkOrders SET Status = ? WHERE Id = ?').run('Cancelled', req.params.id);
    res.json(db.prepare('SELECT * FROM WorkOrders WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== DOWNTIME ==============

app.get('/api/downtime/bymachine/:machineId', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    res.json(db.prepare('SELECT dl.*, m.MachineName, m.MachineCode FROM DowntimeLogs dl LEFT JOIN Machines m ON dl.MachineId = m.Id WHERE dl.MachineId = ? AND dl.IsActive = 1 AND dl.CompanyId = ? ORDER BY dl.StartTime DESC').all(req.params.machineId, companyId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/downtime/active/:machineId', authMiddleware, (req, res) => {
  try {
    res.json(db.prepare('SELECT dl.*, m.MachineName, m.MachineCode FROM DowntimeLogs dl LEFT JOIN Machines m ON dl.MachineId = m.Id WHERE dl.MachineId = ? AND dl.EndTime IS NULL AND dl.IsActive = 1 ORDER BY dl.StartTime DESC').all(req.params.machineId));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/downtime/summary/:machineId', authMiddleware, (req, res) => {
  try {
    const data = db.prepare(`SELECT dl.*, m.MachineName, m.MachineCode, CASE WHEN dl.EndTime IS NOT NULL THEN (julianday(dl.EndTime) - julianday(dl.StartTime)) * 24 ELSE (julianday('now') - julianday(dl.StartTime)) * 24 END as HoursDown FROM DowntimeLogs dl LEFT JOIN Machines m ON dl.MachineId = m.Id WHERE dl.MachineId = ? AND dl.IsActive = 1 ORDER BY dl.StartTime DESC`).all(req.params.machineId);
    const totalHours = data.reduce((sum, d) => sum + (d.HoursDown || 0), 0);
    const categories = {};
    for (const d of data) { const cat = d.Category || 'Other'; categories[cat] = (categories[cat] || 0) + (d.HoursDown || 0); }
    res.json({ logs: data, totalHours, categories });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/downtime/:id', authMiddleware, (req, res) => {
  try {
    const dl = db.prepare('SELECT dl.*, m.MachineName, m.MachineCode FROM DowntimeLogs dl LEFT JOIN Machines m ON dl.MachineId = m.Id WHERE dl.Id = ? AND dl.IsActive = 1').get(req.params.id);
    if (!dl) return res.status(404).json({ message: 'Downtime log not found' });
    res.json(dl);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/downtime/start', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const { machineId, reason, category, notes } = req.body;
    const result = db.prepare('INSERT INTO DowntimeLogs (MachineId, StartTime, Reason, Category, Notes, IsActive, CompanyId) VALUES (?,?,?,?,?,1,?)').run(machineId, now(), reason, category, notes, companyId);
    db.prepare("UPDATE Machines SET Status = 'Maintenance' WHERE Id = ?").run(machineId);
    res.status(201).json(db.prepare('SELECT * FROM DowntimeLogs WHERE Id = ?').get(result.lastInsertRowid));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/downtime/end/:id', authMiddleware, (req, res) => {
  try {
    const dl = db.prepare('SELECT * FROM DowntimeLogs WHERE Id = ? AND IsActive = 1').get(req.params.id);
    if (!dl) return res.status(404).json({ message: 'Downtime log not found' });
    db.prepare('UPDATE DowntimeLogs SET EndTime = ? WHERE Id = ?').run(now(), req.params.id);
    db.prepare("UPDATE Machines SET Status = 'Running' WHERE Id = ?").run(dl.MachineId);
    res.json(db.prepare('SELECT * FROM DowntimeLogs WHERE Id = ?').get(req.params.id));
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== COST SUMMARY ==============

app.get('/api/costsummary', authMiddleware, (req, res) => {
  try {
    const companyId = getCompanyId(req);
    const result = paginate('SELECT cs.*, m.MachineName, m.MachineCode FROM CostSummaries cs LEFT JOIN Machines m ON cs.MachineId = m.Id WHERE cs.IsActive = 1 AND cs.CompanyId = @companyId ORDER BY cs.Id DESC', { companyId }, req);
    res.json(result);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.get('/api/costsummary/:id', authMiddleware, (req, res) => {
  try {
    const cs = db.prepare('SELECT cs.*, m.MachineName, m.MachineCode FROM CostSummaries cs LEFT JOIN Machines m ON cs.MachineId = m.Id WHERE cs.Id = ? AND cs.IsActive = 1').get(req.params.id);
    if (!cs) return res.status(404).json({ message: 'Cost summary not found' });
    res.json(cs);
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// ============== MODULE EXPORT ==============

module.exports = app;
