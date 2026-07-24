-- ============================================================================
-- TEXTILE ERP - SEED DATA - UNITS OF MEASUREMENT
-- ============================================================================

USE TextileERP;
GO

-- Note: CompanyId = 1 should be created first. For now, using a placeholder.
-- These will need to be updated after company creation.

-- Insert Units of Measurement (Generic - will be linked to companies)
-- We'll use a temporary approach - these can be imported per company

-- Quantity Units
INSERT INTO master.Units (CompanyId, UnitCode, UnitName, UnitFullName, UnitType, DecimalPlaces, IsActive)
VALUES 
(1, 'NOS', 'Numbers', 'Numbers', 'Quantity', 0, 1),
(1, 'PCS', 'Pieces', 'Pieces', 'Quantity', 0, 1),
(1, 'BOX', 'Box', 'Box', 'Quantity', 0, 1),
(1, 'SET', 'Set', 'Set', 'Quantity', 0, 1),
(1, 'PAC', 'Pack', 'Package', 'Quantity', 0, 1),
(1, 'DOZ', 'Dozen', 'Dozen', 'Quantity', 0, 1),
(1, 'GRO', 'Gross', 'Gross', 'Quantity', 0, 1),
(1, 'PR', 'Pair', 'Pair', 'Quantity', 0, 1);

-- Weight Units
INSERT INTO master.Units (CompanyId, UnitCode, UnitName, UnitFullName, UnitType, DecimalPlaces, IsActive)
VALUES 
(1, 'KG', 'Kilogram', 'Kilogram', 'Weight', 3, 1),
(1, 'G', 'Gram', 'Gram', 'Weight', 3, 1),
(1, 'MT', 'Metric Ton', 'Metric Ton', 'Weight', 3, 1),
(1, 'QTL', 'Quintal', 'Quintal', 'Weight', 3, 1),
(1, 'LB', 'Pound', 'Pound', 'Weight', 3, 1),
(1, 'OZ', 'Ounce', 'Ounce', 'Weight', 3, 1);

-- Length Units (Textile Specific)
INSERT INTO master.Units (CompanyId, UnitCode, UnitName, UnitFullName, UnitType, DecimalPlaces, IsActive)
VALUES 
(1, 'MTR', 'Meter', 'Metre', 'Length', 2, 1),
(1, 'CM', 'Centimetre', 'Centimetre', 'Length', 2, 1),
(1, 'MM', 'Millimetre', 'Millimetre', 'Length', 2, 1),
(1, 'YDS', 'Yard', 'Yard', 'Length', 2, 1),
(1, 'FT', 'Feet', 'Feet', 'Length', 2, 1),
(1, 'INCH', 'Inch', 'Inch', 'Length', 2, 1),
(1, 'ROL', 'Roll', 'Roll', 'Length', 0, 1),
(1, 'BDL', 'Bundle', 'Bundle', 'Length', 0, 1),
(1, 'BLL', 'Bale', 'Bale', 'Length', 0, 1),
(1, 'CUT', 'Cut', 'Cut', 'Length', 0, 1);

-- Area Units
INSERT INTO master.Units (CompanyId, UnitCode, UnitName, UnitFullName, UnitType, DecimalPlaces, IsActive)
VALUES 
(1, 'SQM', 'Square Metre', 'Square Metre', 'Area', 2, 1),
(1, 'SQF', 'Square Feet', 'Square Feet', 'Area', 2, 1),
(1, 'SQY', 'Square Yard', 'Square Yard', 'Area', 2, 1),
(1, 'ACR', 'Acre', 'Acre', 'Area', 2, 1),
(1, 'HEC', 'Hectare', 'Hectare', 'Area', 2, 1);

-- Volume Units
INSERT INTO master.Units (CompanyId, UnitCode, UnitName, UnitFullName, UnitType, DecimalPlaces, IsActive)
VALUES 
(1, 'LTR', 'Litre', 'Litre', 'Volume', 3, 1),
(1, 'ML', 'Millilitre', 'Millilitre', 'Volume', 3, 1),
(1, 'M3', 'Cubic Metre', 'Cubic Metre', 'Volume', 3, 1);

PRINT 'Units of Measurement inserted successfully.';
GO
