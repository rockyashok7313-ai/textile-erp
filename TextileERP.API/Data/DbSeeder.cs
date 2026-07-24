using Microsoft.EntityFrameworkCore;
using TextileERP.API.Models.Master;
using TextileERP.API.Models.Payroll;
using TextileERP.API.Models.Maintenance;
using System.Security.Cryptography;
using System.Text;

namespace TextileERP.API.Data;

public static class DbSeeder
{
    public static async Task SeedAsync(ApplicationDbContext db)
    {
        if (await db.Companies.AnyAsync()) return;

        // Seed Country first (referenced by Company)
        var country = new Country { CountryId = 1, CountryCode = "IN", CountryName = "India", CurrencyCode = "INR", ISDCode = "91", IsActive = true };
        db.Countries.Add(country);
        await db.SaveChangesAsync();

        // Seed States before Company (Company has FK to StateMaster)
        var states = new[]
        {
            new StateMaster { StateCode = "01", StateName = "Jammu & Kashmir", StateShortName = "J&K", StateType = "UT", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "02", StateName = "Himachal Pradesh", StateShortName = "HP", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "03", StateName = "Punjab", StateShortName = "PB", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "04", StateName = "Chandigarh", StateShortName = "CH", StateType = "UT", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "05", StateName = "Uttarakhand", StateShortName = "UK", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "06", StateName = "Haryana", StateShortName = "HR", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "07", StateName = "Delhi", StateShortName = "DL", StateType = "UT", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "08", StateName = "Rajasthan", StateShortName = "RJ", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "09", StateName = "Uttar Pradesh", StateShortName = "UP", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "10", StateName = "Bihar", StateShortName = "BR", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "11", StateName = "Sikkim", StateShortName = "SK", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "12", StateName = "Arunachal Pradesh", StateShortName = "AR", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "13", StateName = "Nagaland", StateShortName = "NL", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "14", StateName = "Manipur", StateShortName = "MN", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "15", StateName = "Mizoram", StateShortName = "MZ", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "16", StateName = "Tripura", StateShortName = "TR", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "17", StateName = "Meghalaya", StateShortName = "ML", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "18", StateName = "Assam", StateShortName = "AS", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "19", StateName = "West Bengal", StateShortName = "WB", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "20", StateName = "Jharkhand", StateShortName = "JH", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "21", StateName = "Odisha", StateShortName = "OD", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "22", StateName = "Chhattisgarh", StateShortName = "CG", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "23", StateName = "Madhya Pradesh", StateShortName = "MP", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "24", StateName = "Gujarat", StateShortName = "GJ", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "25", StateName = "Daman & Diu", StateShortName = "DD", StateType = "UT", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "26", StateName = "Dadra & Nagar Haveli", StateShortName = "DN", StateType = "UT", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "27", StateName = "Maharashtra", StateShortName = "MH", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "28", StateName = "Andhra Pradesh", StateShortName = "AP", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "29", StateName = "Karnataka", StateShortName = "KA", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "30", StateName = "Goa", StateShortName = "GA", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "31", StateName = "Lakshadweep", StateShortName = "LD", StateType = "UT", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "32", StateName = "Kerala", StateShortName = "KL", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "33", StateName = "Tamil Nadu", StateShortName = "TN", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "34", StateName = "Puducherry", StateShortName = "PY", StateType = "UT", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "35", StateName = "Andaman & Nicobar", StateShortName = "AN", StateType = "UT", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "36", StateName = "Telangana", StateShortName = "TS", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
            new StateMaster { StateCode = "37", StateName = "Andhra Pradesh (New)", StateShortName = "AP2", StateType = "State", IsActive = true, CreatedDate = DateTime.Now },
        };
        db.StateMasters.AddRange(states);
        await db.SaveChangesAsync();

        // Default Company (States must be seeded first)
        var company = new Company
        {
            CompanyCode = "TEX001",
            CompanyName = "Textile ERP Demo Pvt Ltd",
            AddressLine1 = "123 Textile Market, Ring Road",
            City = "Surat",
            StateId = 24,
            StateCode = "24",
            PinCode = "395002",
            Phone = "0261-2345678",
            Email = "info@textileerp.com",
            GSTIN = "24AABCT1234F1Z5",
            PAN = "AABCT1234F",
            TAN = "RTTE00123F",
            CountryId = 1,
            FiscalYearStartMonth = 4,
            IsActive = true,
            CreatedDate = DateTime.Now
        };
        db.Companies.Add(company);
        await db.SaveChangesAsync();

        // Admin User
        var user = new User
        {
            UserCode = "USR001",
            UserName = "admin",
            LoginId = "admin",
            PasswordHash = HashPassword("admin123"),
            Email = "admin@textileerp.com",
            Mobile = "9876543210",
            CompanyId = company.Id,
            IsAdmin = true,
            IsSuperAdmin = true,
            IsApprover = true,
            CanApprovePurchase = true,
            CanApproveSales = true,
            CanApprovePayment = true,
            IsActive = true,
            CreatedDate = DateTime.Now
        };
        db.Users.Add(user);
        await db.SaveChangesAsync();

        // Units (Unit doesn't have SortOrder)
        var units = new[]
        {
            new Unit { UnitCode = "MTR", UnitName = "Metre", UnitType = "Length", IsActive = true, CompanyId = company.Id },
            new Unit { UnitCode = "YDS", UnitName = "Yard", UnitType = "Length", IsActive = true, CompanyId = company.Id },
            new Unit { UnitCode = "KGS", UnitName = "Kilogram", UnitType = "Weight", IsActive = true, CompanyId = company.Id },
            new Unit { UnitCode = "PCS", UnitName = "Pieces", UnitType = "Quantity", IsActive = true, CompanyId = company.Id },
            new Unit { UnitCode = "BAG", UnitName = "Bags", UnitType = "Quantity", IsActive = true, CompanyId = company.Id },
            new Unit { UnitCode = "RLL", UnitName = "Rolls", UnitType = "Quantity", IsActive = true, CompanyId = company.Id },
            new Unit { UnitCode = "BOX", UnitName = "Box", UnitType = "Quantity", IsActive = true, CompanyId = company.Id },
            new Unit { UnitCode = "SET", UnitName = "Set", UnitType = "Quantity", IsActive = true, CompanyId = company.Id },
            new Unit { UnitCode = "NOS", UnitName = "Numbers", UnitType = "Quantity", IsActive = true, CompanyId = company.Id },
            new Unit { UnitCode = "DOZ", UnitName = "Dozen", UnitType = "Quantity", IsActive = true, CompanyId = company.Id },
        };
        db.Units.AddRange(units);
        await db.SaveChangesAsync();

        // Item Categories (ItemCategory doesn't have SortOrder)
        var categories = new[]
        {
            new ItemCategory { CategoryCode = "FAB", CategoryName = "Fabrics", IsActive = true, CompanyId = company.Id },
            new ItemCategory { CategoryCode = "YRN", CategoryName = "Yarn", IsActive = true, CompanyId = company.Id },
            new ItemCategory { CategoryCode = "DYE", CategoryName = "Dyes & Chemicals", IsActive = true, CompanyId = company.Id },
            new ItemCategory { CategoryCode = "ACC", CategoryName = "Accessories", IsActive = true, CompanyId = company.Id },
            new ItemCategory { CategoryCode = "RMF", CategoryName = "Raw Material - Fiber", IsActive = true, CompanyId = company.Id },
            new ItemCategory { CategoryCode = "FGO", CategoryName = "Finished Goods", IsActive = true, CompanyId = company.Id },
            new ItemCategory { CategoryCode = "SPR", CategoryName = "Saree / Dress Material", IsActive = true, CompanyId = company.Id },
            new ItemCategory { CategoryCode = "HUF", CategoryName = "Home Furnishing", IsActive = true, CompanyId = company.Id },
        };
        db.ItemCategories.AddRange(categories);
        await db.SaveChangesAsync();

        // Payroll: Departments (Department doesn't have SortOrder)
        var departments = new[]
        {
            new Department { DepartmentCode = "PROD", DepartmentName = "Production", IsActive = true, CompanyId = company.Id },
            new Department { DepartmentCode = "QCA", DepartmentName = "Quality Control", IsActive = true, CompanyId = company.Id },
            new Department { DepartmentCode = "MINT", DepartmentName = "Maintenance", IsActive = true, CompanyId = company.Id },
            new Department { DepartmentCode = "WHSE", DepartmentName = "Warehouse", IsActive = true, CompanyId = company.Id },
            new Department { DepartmentCode = "ACCT", DepartmentName = "Accounts", IsActive = true, CompanyId = company.Id },
            new Department { DepartmentCode = "SALE", DepartmentName = "Sales", IsActive = true, CompanyId = company.Id },
            new Department { DepartmentCode = "PUR", DepartmentName = "Purchase", IsActive = true, CompanyId = company.Id },
            new Department { DepartmentCode = "HR", DepartmentName = "Human Resources", IsActive = true, CompanyId = company.Id },
            new Department { DepartmentCode = "ADMN", DepartmentName = "Administration", IsActive = true, CompanyId = company.Id },
            new Department { DepartmentCode = "IT", DepartmentName = "IT", IsActive = true, CompanyId = company.Id },
        };
        db.Departments.AddRange(departments);
        await db.SaveChangesAsync();

        // Payroll: Designations (Designation doesn't have SortOrder)
        var designations = new[]
        {
            new Designation { DesignationCode = "MGR", DesignationName = "Manager", IsActive = true, CompanyId = company.Id },
            new Designation { DesignationCode = "SUP", DesignationName = "Supervisor", IsActive = true, CompanyId = company.Id },
            new Designation { DesignationCode = "OPR", DesignationName = "Operator", IsActive = true, CompanyId = company.Id },
            new Designation { DesignationCode = "HEL", DesignationName = "Helper", IsActive = true, CompanyId = company.Id },
            new Designation { DesignationCode = "TEC", DesignationName = "Technician", IsActive = true, CompanyId = company.Id },
            new Designation { DesignationCode = "ACCT", DesignationName = "Accountant", IsActive = true, CompanyId = company.Id },
            new Designation { DesignationCode = "CLERK", DesignationName = "Clerk", IsActive = true, CompanyId = company.Id },
            new Designation { DesignationCode = "HRM", DesignationName = "HR Manager", IsActive = true, CompanyId = company.Id },
        };
        db.Designations.AddRange(designations);
        await db.SaveChangesAsync();

        // Leave Types
        var leaveTypes = new[]
        {
            new LeaveType { LeaveTypeCode = "CL", LeaveTypeName = "Casual Leave", DaysPerYear = 12, IsCarryForward = false, IsPaid = true, IsActive = true, CompanyId = company.Id, SortOrder = 1 },
            new LeaveType { LeaveTypeCode = "SL", LeaveTypeName = "Sick Leave", DaysPerYear = 6, IsCarryForward = true, IsPaid = true, IsActive = true, CompanyId = company.Id, SortOrder = 2 },
            new LeaveType { LeaveTypeCode = "EL", LeaveTypeName = "Earned Leave", DaysPerYear = 15, IsCarryForward = true, IsPaid = true, IsActive = true, CompanyId = company.Id, SortOrder = 3 },
            new LeaveType { LeaveTypeCode = "ML", LeaveTypeName = "Maternity Leave", DaysPerYear = 182, IsCarryForward = false, IsPaid = true, IsActive = true, CompanyId = company.Id, SortOrder = 4 },
            new LeaveType { LeaveTypeCode = "PL", LeaveTypeName = "Privilege Leave", DaysPerYear = 0, IsCarryForward = false, IsPaid = true, IsActive = true, CompanyId = company.Id, SortOrder = 5 },
        };
        db.LeaveTypes.AddRange(leaveTypes);
        await db.SaveChangesAsync();

        // Salary Heads (correct property names: HeadCode, HeadName, HeadType, BasedOn, DefaultPercent)
        var salaryHeads = new[]
        {
            new SalaryHead { HeadCode = "BS", HeadName = "Basic Salary", CalculationType = "Fixed", HeadType = "Earning", IsActive = true, CompanyId = company.Id, SortOrder = 1 },
            new SalaryHead { HeadCode = "HRA", HeadName = "House Rent Allowance", CalculationType = "Percentage", HeadType = "Earning", BasedOn = "Basic", DefaultPercent = 40, IsActive = true, CompanyId = company.Id, SortOrder = 2 },
            new SalaryHead { HeadCode = "DA", HeadName = "Dearness Allowance", CalculationType = "Percentage", HeadType = "Earning", BasedOn = "Basic", DefaultPercent = 30, IsActive = true, CompanyId = company.Id, SortOrder = 3 },
            new SalaryHead { HeadCode = "CONV", HeadName = "Conveyance Allowance", CalculationType = "Fixed", HeadType = "Earning", IsActive = true, CompanyId = company.Id, SortOrder = 4 },
            new SalaryHead { HeadCode = "MED", HeadName = "Medical Allowance", CalculationType = "Fixed", HeadType = "Earning", IsActive = true, CompanyId = company.Id, SortOrder = 5 },
            new SalaryHead { HeadCode = "PF_EE", HeadName = "PF - Employee", CalculationType = "Formula", HeadType = "Deduction", IsActive = true, CompanyId = company.Id, SortOrder = 6 },
            new SalaryHead { HeadCode = "PF_ER", HeadName = "PF - Employer", CalculationType = "Formula", HeadType = "Deduction", IsActive = true, CompanyId = company.Id, SortOrder = 7 },
            new SalaryHead { HeadCode = "ESI_EE", HeadName = "ESI - Employee", CalculationType = "Formula", HeadType = "Deduction", IsActive = true, CompanyId = company.Id, SortOrder = 8 },
            new SalaryHead { HeadCode = "ESI_ER", HeadName = "ESI - Employer", CalculationType = "Formula", HeadType = "Deduction", IsActive = true, CompanyId = company.Id, SortOrder = 9 },
            new SalaryHead { HeadCode = "PT", HeadName = "Professional Tax", CalculationType = "Slab", HeadType = "Deduction", IsActive = true, CompanyId = company.Id, SortOrder = 10 },
        };
        db.SalaryHeads.AddRange(salaryHeads);
        await db.SaveChangesAsync();

        // Maintenance: Machines (AirJet + Sulzer)
        var machines = new[]
        {
            new Machine { MachineCode = "AJ-001", MachineName = "Toyota JAT810 - 01", MachineType = "AirJet", Make = "Toyota", Model = "JAT810", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay A" },
            new Machine { MachineCode = "AJ-002", MachineName = "Toyota JAT810 - 02", MachineType = "AirJet", Make = "Toyota", Model = "JAT810", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay A" },
            new Machine { MachineCode = "AJ-003", MachineName = "Picanol OptiMax-i - 01", MachineType = "AirJet", Make = "Picanol", Model = "OptiMax-i", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay B" },
            new Machine { MachineCode = "AJ-004", MachineName = "Picanol OptiMax-i - 02", MachineType = "AirJet", Make = "Picanol", Model = "OptiMax-i", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay B" },
            new Machine { MachineCode = "AJ-005", MachineName = "Tsudakoma ZAX-N - 01", MachineType = "AirJet", Make = "Tsudakoma", Model = "ZAX-N", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay C" },
            new Machine { MachineCode = "AJ-006", MachineName = "Tsudakoma ZAX-N - 02", MachineType = "AirJet", Make = "Tsudakoma", Model = "ZAX-N", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay C" },
            new Machine { MachineCode = "AJ-007", MachineName = "Toyota JAT810 - 03", MachineType = "AirJet", Make = "Toyota", Model = "JAT810", LoomCount = 1, Status = "Maintenance", IsActive = true, CompanyId = company.Id, Location = "Bay D" },
            new Machine { MachineCode = "AJ-008", MachineName = "Picanol OptiMax-i - 03", MachineType = "AirJet", Make = "Picanol", Model = "OptiMax-i", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay D" },
            new Machine { MachineCode = "SZ-001", MachineName = "Sulzer G6300 - 01", MachineType = "Sulzer", Make = "Sulzer", Model = "G6300", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay E" },
            new Machine { MachineCode = "SZ-002", MachineName = "Sulzer G6300 - 02", MachineType = "Sulzer", Make = "Sulzer", Model = "G6300", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay E" },
            new Machine { MachineCode = "SZ-003", MachineName = "Sulzer L6300 - 01", MachineType = "Sulzer", Make = "Sulzer", Model = "L6300", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay F" },
            new Machine { MachineCode = "SZ-004", MachineName = "Sulzer L6300 - 02", MachineType = "Sulzer", Make = "Sulzer", Model = "L6300", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay F" },
            new Machine { MachineCode = "SZ-005", MachineName = "Sulzer G6300 - 03", MachineType = "Sulzer", Make = "Sulzer", Model = "G6300", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay G" },
            new Machine { MachineCode = "SZ-006", MachineName = "Sulzer L6300 - 03", MachineType = "Sulzer", Make = "Sulzer", Model = "L6300", LoomCount = 1, Status = "Running", IsActive = true, CompanyId = company.Id, Location = "Bay G" },
        };
        db.Machines.AddRange(machines);
        await db.SaveChangesAsync();

        // Maintenance: Spare Parts
        var spareParts = new[]
        {
            new SparePart { SparePartCode = "SP-001", SparePartName = "Nozzle Assembly", Description = "Main nozzle for AirJet loom", Category = "Mechanical", CompatibleMachineTypes = "AirJet", CurrentStock = 20, MinStock = 5, MaxStock = 50, ReorderLevel = 10, UnitCost = 2500m, IsCriticalSpare = true, IsActive = true, CompanyId = company.Id },
            new SparePart { SparePartCode = "SP-002", SparePartName = "Relay Valve", Description = "Electronic relay valve for weft insertion", Category = "Electrical", CompatibleMachineTypes = "AirJet", CurrentStock = 15, MinStock = 5, MaxStock = 30, ReorderLevel = 8, UnitCost = 1800m, IsCriticalSpare = true, IsActive = true, CompanyId = company.Id },
            new SparePart { SparePartCode = "SP-003", SparePartName = "Reed", Description = "Reed for fabric formation", Category = "Mechanical", CompatibleMachineTypes = "All", CurrentStock = 10, MinStock = 3, MaxStock = 20, ReorderLevel = 5, UnitCost = 5000m, IsCriticalSpare = true, IsActive = true, CompanyId = company.Id },
            new SparePart { SparePartCode = "SP-004", SparePartName = "Heald Wire", Description = "Heald wire for shedding mechanism", Category = "Mechanical", CompatibleMachineTypes = "All", CurrentStock = 500, MinStock = 100, MaxStock = 1000, ReorderLevel = 200, UnitCost = 50m, IsCriticalSpare = false, IsActive = true, CompanyId = company.Id },
            new SparePart { SparePartCode = "SP-005", SparePartName = "Solenoid Valve", Description = "Control solenoid for air pressure", Category = "Electrical", CompatibleMachineTypes = "AirJet", CurrentStock = 12, MinStock = 4, MaxStock = 25, ReorderLevel = 6, UnitCost = 1200m, IsCriticalSpare = true, IsActive = true, CompanyId = company.Id },
            new SparePart { SparePartCode = "SP-006", SparePartName = "Drive Belt", Description = "Main drive belt", Category = "Mechanical", CompatibleMachineTypes = "All", CurrentStock = 8, MinStock = 3, MaxStock = 15, ReorderLevel = 5, UnitCost = 800m, IsCriticalSpare = false, IsActive = true, CompanyId = company.Id },
            new SparePart { SparePartCode = "SP-007", SparePartName = "PCB Board", Description = "Main control PCB", Category = "Electronic", CompatibleMachineTypes = "All", CurrentStock = 4, MinStock = 2, MaxStock = 8, ReorderLevel = 3, UnitCost = 15000m, IsCriticalSpare = true, IsActive = true, CompanyId = company.Id },
            new SparePart { SparePartCode = "SP-008", SparePartName = "Lubricant Oil", Description = "Machine lubricant 20W-50", Category = "Consumable", CompatibleMachineTypes = "All", CurrentStock = 50, MinStock = 10, MaxStock = 100, ReorderLevel = 20, UnitCost = 350m, IsCriticalSpare = false, IsActive = true, CompanyId = company.Id },
            new SparePart { SparePartCode = "SP-009", SparePartName = "Shuttle Buffer", Description = "Buffer pad for shuttle", Category = "Mechanical", CompatibleMachineTypes = "Sulzer", CurrentStock = 25, MinStock = 8, MaxStock = 40, ReorderLevel = 10, UnitCost = 400m, IsCriticalSpare = false, IsActive = true, CompanyId = company.Id },
            new SparePart { SparePartCode = "SP-010", SparePartName = "Temple Roller", Description = "Selvedge temple roller", Category = "Mechanical", CompatibleMachineTypes = "All", CurrentStock = 30, MinStock = 10, MaxStock = 60, ReorderLevel = 15, UnitCost = 200m, IsCriticalSpare = false, IsActive = true, CompanyId = company.Id },
        };
        db.SpareParts.AddRange(spareParts);
        await db.SaveChangesAsync();

        // Default Godown (use GodownAddress, not Address)
        var godown = new Godown
        {
            GodownCode = "WH-001",
            GodownName = "Main Warehouse",
            GodownAddress = "Ground Floor, Main Building",
            IsMainGodown = true,
            IsActive = true,
            CompanyId = company.Id
        };
        db.Godowns.Add(godown);
        await db.SaveChangesAsync();

        Console.WriteLine("[DbSeeder] Database seeded successfully with default data.");
    }

    private static string HashPassword(string password)
    {
        using var sha256 = SHA256.Create();
        var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
        var builder = new StringBuilder();
        foreach (var b in bytes)
            builder.Append(b.ToString("x2"));
        return builder.ToString();
    }
}
