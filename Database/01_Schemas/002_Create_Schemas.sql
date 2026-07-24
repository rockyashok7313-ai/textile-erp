-- ============================================================================
-- TEXTILE ERP DATABASE - CREATE SCHEMAS
-- ============================================================================
-- Description: Create schemas for organizing database objects
-- ============================================================================

USE TextileERP;
GO

-- Create schemas for module organization
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'master')
    EXEC('CREATE SCHEMA [master]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'inventory')
    EXEC('CREATE SCHEMA [inventory]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'purchase')
    EXEC('CREATE SCHEMA [purchase]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'sales')
    EXEC('CREATE SCHEMA [sales]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'production')
    EXEC('CREATE SCHEMA [production]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'finance')
    EXEC('CREATE SCHEMA [finance]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'tax')
    EXEC('CREATE SCHEMA [tax]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'compliance')
    EXEC('CREATE SCHEMA [compliance]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'audit')
    EXEC('CREATE SCHEMA [audit]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'payroll')
    EXEC('CREATE SCHEMA [payroll]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'maintenance')
    EXEC('CREATE SCHEMA [maintenance]');
GO

PRINT 'All schemas created successfully.';
GO
