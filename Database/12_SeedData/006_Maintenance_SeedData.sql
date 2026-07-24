USE TextileERP;
GO

-- Sample AirJet Looms
INSERT INTO maintenance.Machines (CompanyId, MachineCode, MachineName, MachineType, Make, Model, LoomCount, Location, Status, IsActive)
VALUES 
(1, 'AJ-001', 'AirJet Loom Bay 1 - Position 1', 'AirJet', 'Toyota', 'JAT810', 1, 'Shop Floor - Bay 1', 'Running', 1),
(1, 'AJ-002', 'AirJet Loom Bay 1 - Position 2', 'AirJet', 'Toyota', 'JAT810', 1, 'Shop Floor - Bay 1', 'Running', 1),
(1, 'AJ-003', 'AirJet Loom Bay 1 - Position 3', 'AirJet', 'Toyota', 'JAT810', 1, 'Shop Floor - Bay 1', 'Running', 1),
(1, 'AJ-004', 'AirJet Loom Bay 1 - Position 4', 'AirJet', 'Picanol', 'OptiMax-i', 1, 'Shop Floor - Bay 1', 'Running', 1),
(1, 'AJ-005', 'AirJet Loom Bay 1 - Position 5', 'AirJet', 'Picanol', 'OptiMax-i', 1, 'Shop Floor - Bay 1', 'Running', 1),
(1, 'AJ-006', 'AirJet Loom Bay 2 - Position 1', 'AirJet', 'Toyota', 'JAT810', 1, 'Shop Floor - Bay 2', 'Running', 1),
(1, 'AJ-007', 'AirJet Loom Bay 2 - Position 2', 'AirJet', 'Toyota', 'JAT810', 1, 'Shop Floor - Bay 2', 'Running', 1),
(1, 'AJ-008', 'AirJet Loom Bay 2 - Position 3', 'AirJet', 'Picanol', 'OptiMax-i', 1, 'Shop Floor - Bay 2', 'Running', 1);
GO

-- Sample Sulzer Looms
INSERT INTO maintenance.Machines (CompanyId, MachineCode, MachineName, MachineType, Make, Model, LoomCount, Location, Status, IsActive)
VALUES 
(1, 'SZ-001', 'Sulzer Loom Bay 3 - Position 1', 'Sulzer', 'Sulzer', 'G6300', 1, 'Shop Floor - Bay 3', 'Running', 1),
(1, 'SZ-002', 'Sulzer Loom Bay 3 - Position 2', 'Sulzer', 'Sulzer', 'G6300', 1, 'Shop Floor - Bay 3', 'Running', 1),
(1, 'SZ-003', 'Sulzer Loom Bay 3 - Position 3', 'Sulzer', 'Sulzer', 'G6300', 1, 'Shop Floor - Bay 3', 'Running', 1),
(1, 'SZ-004', 'Sulzer Loom Bay 4 - Position 1', 'Sulzer', 'Sulzer', 'L6300', 1, 'Shop Floor - Bay 4', 'Running', 1),
(1, 'SZ-005', 'Sulzer Loom Bay 4 - Position 2', 'Sulzer', 'Sulzer', 'L6300', 1, 'Shop Floor - Bay 4', 'Running', 1),
(1, 'SZ-006', 'Sulzer Loom Bay 4 - Position 3', 'Sulzer', 'Sulzer', 'L6300', 1, 'Shop Floor - Bay 4', 'Running', 1);
GO

-- Common Spare Parts for Looms
INSERT INTO maintenance.SpareParts (CompanyId, SparePartCode, SparePartName, Description, Category, MinStock, MaxStock, ReorderLevel, CurrentStock, UnitCost, LeadTimeDays, CompatibleMachineTypes, IsCriticalSpare, IsActive)
VALUES
-- Mechanical Parts
(1, 'SP-001', 'Reed', 'Weaving Reed 180 cm', 'Mechanical', 2, 10, 4, 6, 15000, 15, 'All', 1, 1),
(1, 'SP-002', 'Heddle Frame', 'Heddle Frame Assembly', 'Mechanical', 4, 20, 8, 12, 8000, 10, 'All', 1, 1),
(1, 'SP-003', 'Shuttle', 'AirJet Shuttle', 'Mechanical', 4, 15, 6, 8, 25000, 20, 'AirJet', 1, 1),
(1, 'SP-004', 'Heald Wire', 'Stainless Steel Heald Wire', 'Mechanical', 100, 500, 200, 350, 50, 7, 'All', 0, 1),
(1, 'SP-005', 'Drop Wire', 'Drop Wire Assembly', 'Mechanical', 50, 200, 100, 150, 30, 5, 'All', 0, 1),
(1, 'SP-006', 'Temple Roller', 'Rubber Temple Roller', 'Mechanical', 20, 100, 40, 60, 200, 7, 'All', 0, 1),
-- Electrical Parts
(1, 'SP-010', 'Main Motor', 'Loom Main Drive Motor 5HP', 'Electrical', 1, 4, 2, 3, 45000, 20, 'All', 1, 1),
(1, 'SP-011', 'Inverter Card', 'Frequency Inverter Card', 'Electronic', 2, 8, 3, 5, 12000, 15, 'AirJet', 1, 1),
(1, 'SP-012', 'Control Board', 'Main Control PCB', 'Electronic', 1, 4, 2, 2, 35000, 25, 'All', 1, 1),
(1, 'SP-013', 'Proximity Sensor', 'Proximity Sensor Unit', 'Electronic', 10, 40, 15, 25, 1500, 7, 'All', 0, 1),
(1, 'SP-014', 'Solenoid Valve', 'Pneumatic Solenoid Valve', 'Electrical', 5, 20, 8, 12, 3500, 10, 'AirJet', 1, 1),
(1, 'SP-015', 'Relay Module', 'Control Relay Module', 'Electrical', 10, 40, 15, 20, 800, 5, 'All', 0, 1),
-- Consumables
(1, 'SP-020', 'Air Filter', 'Loom Air Filter Element', 'Consumable', 20, 80, 30, 50, 250, 3, 'AirJet', 0, 1),
(1, 'SP-021', 'Oil Filter', 'Lubrication Oil Filter', 'Consumable', 10, 40, 15, 25, 350, 3, 'All', 0, 1),
(1, 'SP-022', 'Loom Oil', 'Synthetic Loom Oil 5L', 'Consumable', 10, 50, 20, 30, 800, 3, 'All', 0, 1),
(1, 'SP-023', 'Grease', 'Multi-Purpose Grease 1kg', 'Consumable', 10, 50, 20, 35, 300, 3, 'All', 0, 1),
(1, 'SP-024', 'Teflon Tape', 'PTFE Thread Seal Tape', 'Consumable', 20, 100, 40, 60, 50, 2, 'All', 0, 1),
-- Sulzer Specific Parts
(1, 'SP-030', 'Rapier Head', 'Sulzer Rapier Head Assembly', 'Mechanical', 2, 8, 3, 4, 55000, 30, 'Sulzer', 1, 1),
(1, 'SP-031', 'Rapier Band', 'Sulzer Rapier Band', 'Mechanical', 6, 24, 10, 15, 8000, 15, 'Sulzer', 1, 1),
(1, 'SP-032', 'Gripper', 'Sulzer Gripper Mechanism', 'Mechanical', 4, 16, 6, 8, 40000, 25, 'Sulzer', 1, 1);

PRINT 'Maintenance seed data inserted successfully.';
GO
