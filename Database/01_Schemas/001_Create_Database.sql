-- ============================================================================
-- TEXTILE ERP DATABASE - CREATE DATABASE
-- ============================================================================
-- Description: Create TextileERP database for textile business operations
-- Tech Stack: SQL Server
-- Version: 1.0
-- ============================================================================

USE master;
GO

-- Drop database if exists (CAUTION: This will delete all data)
-- Uncomment the following lines only if you need to recreate
-- IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TextileERP')
-- BEGIN
--     ALTER DATABASE TextileERP SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--     DROP DATABASE TextileERP;
-- END
-- GO

-- Create Database
CREATE DATABASE TextileERP
ON PRIMARY
(
    NAME = N'TextileERP_Data',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TextileERP.mdf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 50MB
)
LOG ON
(
    NAME = N'TextileERP_Log',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TextileERP.ldf',
    SIZE = 50MB,
    MAXSIZE = 2GB,
    FILEGROWTH = 25MB
);
GO

-- Set database options
ALTER DATABASE TextileERP SET COMPATIBILITY_LEVEL = 160; -- SQL Server 2022
ALTER DATABASE TextileERP SET RECOVERY FULL;
ALTER DATABASE TextileERP SET AUTO_CLOSE OFF;
ALTER DATABASE TextileERP SET AUTO_SHRINK OFF;
ALTER DATABASE TextileERP SET ALLOW_SNAPSHOT_ISOLATION ON;
ALTER DATABASE TextileERP SET READ_COMMITTED_SNAPSHOT ON;
GO

PRINT 'Database TextileERP created successfully.';
GO
