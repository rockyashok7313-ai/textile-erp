-- ============================================================================
-- TEXTILE ERP - MASTER MODULE - ITEM CATEGORIES TABLE
-- ============================================================================

USE TextileERP;
GO

-- Item Categories Table
CREATE TABLE master.ItemCategories
(
    CategoryId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    CategoryCode        NVARCHAR(20) NOT NULL,
    CategoryName        NVARCHAR(100) NOT NULL,
    CategoryDescription NVARCHAR(500) NULL,
    ParentCategoryId    BIGINT NULL,
    CategoryLevel       INT NOT NULL DEFAULT 1,
    CategoryPath        NVARCHAR(500) NULL,  -- Full path like /Root/Parent/Child
    DefaultGSTRate      DECIMAL(5,2) NULL,
    DefaultHSNCode      NVARCHAR(10) NULL,
    DefaultUOM          NVARCHAR(20) NULL,
    IsRawMaterial       BIT NOT NULL DEFAULT 0,
    IsFinishedGood      BIT NOT NULL DEFAULT 0,
    IsSemiFinished      BIT NOT NULL DEFAULT 0,
    IsConsumable        BIT NOT NULL DEFAULT 0,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_ItemCategories PRIMARY KEY CLUSTERED (CategoryId),
    CONSTRAINT UQ_ItemCategories_CompanyCategoryCode UNIQUE (CompanyId, CategoryCode),
    CONSTRAINT UQ_ItemCategories_CompanyCategoryName UNIQUE (CompanyId, CategoryName),
    CONSTRAINT FK_ItemCategories_ParentCategory FOREIGN KEY (ParentCategoryId) 
        REFERENCES master.ItemCategories(CategoryId),
    CONSTRAINT FK_ItemCategories_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId)
);
GO

PRINT 'Table master.ItemCategories created successfully.';
GO
