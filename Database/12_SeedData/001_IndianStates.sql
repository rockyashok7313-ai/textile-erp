-- ============================================================================
-- TEXTILE ERP - SEED DATA - INDIAN STATES AND UTs
-- ============================================================================

USE TextileERP;
GO

-- Insert Countries
INSERT INTO master.Countries (CountryCode, CountryName, CountryShortName, ISDCode, CurrencyCode, CurrencyName)
VALUES 
('IN', 'India', 'IND', '91', 'INR', 'Indian Rupee'),
('US', 'United States', 'USA', '1', 'USD', 'US Dollar'),
('GB', 'United Kingdom', 'GBR', '44', 'GBP', 'Pound Sterling'),
('AE', 'United Arab Emirates', 'ARE', '971', 'AED', 'UAE Dirham'),
('SA', 'Saudi Arabia', 'SAU', '966', 'SAR', 'Saudi Riyal'),
('SG', 'Singapore', 'SGP', '65', 'SGD', 'Singapore Dollar'),
('JP', 'Japan', 'JPN', '81', 'JPY', 'Japanese Yen'),
('DE', 'Germany', 'DEU', '49', 'EUR', 'Euro'),
('CN', 'China', 'CHN', '86', 'CNY', 'Chinese Yuan'),
('BD', 'Bangladesh', 'BGD', '880', 'BDT', 'Bangladeshi Taka');
GO

-- Insert Indian States and Union Territories with GST State Codes
INSERT INTO master.StateMasters (StateCode, StateName, StateShortName, StateType, CountryId, IsUTWithLegislature)
VALUES 
('01', 'Jammu & Kashmir', 'JK', 'Union Territory', 1, 1),
('02', 'Himachal Pradesh', 'HP', 'State', 1, 0),
('03', 'Punjab', 'PB', 'State', 1, 0),
('04', 'Chandigarh', 'CH', 'Union Territory', 1, 0),
('05', 'Uttarakhand', 'UK', 'State', 1, 0),
('06', 'Haryana', 'HR', 'State', 1, 0),
('07', 'Delhi', 'DL', 'Union Territory', 1, 1),
('08', 'Rajasthan', 'RJ', 'State', 1, 0),
('09', 'Uttar Pradesh', 'UP', 'State', 1, 0),
('10', 'Bihar', 'BR', 'State', 1, 0),
('11', 'Sikkim', 'SK', 'State', 1, 0),
('12', 'Arunachal Pradesh', 'AR', 'State', 1, 0),
('13', 'Nagaland', 'NL', 'State', 1, 0),
('14', 'Manipur', 'MN', 'State', 1, 0),
('15', 'Mizoram', 'MZ', 'State', 1, 0),
('16', 'Tripura', 'TR', 'State', 1, 0),
('17', 'Meghalaya', 'ML', 'State', 1, 0),
('18', 'Assam', 'AS', 'State', 1, 0),
('19', 'West Bengal', 'WB', 'State', 1, 0),
('20', 'Jharkhand', 'JH', 'State', 1, 0),
('21', 'Odisha', 'OD', 'State', 1, 0),
('22', 'Chhattisgarh', 'CG', 'State', 1, 0),
('23', 'Madhya Pradesh', 'MP', 'State', 1, 0),
('24', 'Gujarat', 'GJ', 'State', 1, 0),
('25', 'Daman & Diu', 'DD', 'Union Territory', 1, 0),
('26', 'Dadra & Nagar Haveli', 'DN', 'Union Territory', 1, 0),
('27', 'Maharashtra', 'MH', 'State', 1, 0),
('28', 'Andhra Pradesh (Old)', 'AP', 'State', 1, 0),
('29', 'Karnataka', 'KA', 'State', 1, 0),
('30', 'Goa', 'GA', 'State', 1, 0),
('31', 'Lakshadweep', 'LD', 'Union Territory', 1, 0),
('32', 'Kerala', 'KL', 'State', 1, 0),
('33', 'Tamil Nadu', 'TN', 'State', 1, 0),
('34', 'Puducherry', 'PY', 'Union Territory', 1, 1),
('35', 'Andaman & Nicobar Islands', 'AN', 'Union Territory', 1, 0),
('36', 'Telangana', 'TG', 'State', 1, 0),
('37', 'Andhra Pradesh', 'AP', 'State', 1, 0),
('97', 'Foreign Country', 'FC', 'State', 2, 0);
GO

PRINT 'Indian States and Countries seed data inserted successfully.';
GO
