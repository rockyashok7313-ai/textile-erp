-- ============================================================================
-- TEXTILE ERP - COMPLIANCE MODULE - E-WAY BILL TABLE
-- ============================================================================

USE TextileERP;
GO

-- E-Way Bill Records
CREATE TABLE compliance.EWayBills
(
    EWayBillId          BIGINT IDENTITY(1,1) NOT NULL,
    CompanyId           BIGINT NOT NULL,
    EWayBillNumber      NVARCHAR(50) NULL,
    EWayBillDate        DATE NOT NULL,
    EWayBillValidUpto   DATETIME2 NULL,
    EWayBillStatus      NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Generated, Cancelled, Expired, Rejected
    
    -- Reference
    InvoiceType         NVARCHAR(20) NOT NULL,  -- Sales, Purchase, DeliveryChallan, JobWork
    InvoiceId           BIGINT NOT NULL,
    InvoiceNumber       NVARCHAR(30) NOT NULL,
    InvoiceDate         DATE NOT NULL,
    InvoiceValue        DECIMAL(18,2) NOT NULL,
    
    -- Supplier
    SupplierGSTIN       NVARCHAR(15) NOT NULL,
    SupplierStateCode   NVARCHAR(2) NOT NULL,
    SupplierAddress     NVARCHAR(500) NULL,
    SupplierPinCode     NVARCHAR(10) NULL,
    
    -- Recipient
    RecipientGSTIN      NVARCHAR(15) NULL,
    RecipientStateCode  NVARCHAR(2) NOT NULL,
    RecipientAddress    NVARCHAR(500) NULL,
    RecipientPinCode    NVARCHAR(10) NULL,
    RecipientName       NVARCHAR(200) NULL,
    
    -- Place of Supply
    PlaceOfSupplyCode   NVARCHAR(2) NOT NULL,
    PlaceOfSupplyPinCode NVARCHAR(10) NULL,
    
    -- Distance
    DistanceKm          INT NOT NULL DEFAULT 0,
    FromPinCode         NVARCHAR(10) NULL,
    ToPinCode           NVARCHAR(10) NULL,
    
    -- HSN
    HSNCode             NVARCHAR(10) NOT NULL,
    HSNDescription      NVARCHAR(200) NULL,
    Quantity            DECIMAL(18,4) NOT NULL,
    UQC                 NVARCHAR(20) NOT NULL,
    
    -- Transport
    TransportMode       NVARCHAR(10) NOT NULL DEFAULT 'Road',  -- Road, Rail, Air, Ship
    TransporterID       NVARCHAR(50) NULL,
    TransporterName     NVARCHAR(200) NULL,
    TransporterGSTIN    NVARCHAR(15) NULL,
    
    -- Document
    DocumentType        NVARCHAR(20) NOT NULL DEFAULT 'TaxInvoice',  -- TaxInvoice, DeliveryChallan, BillOfSupply, Others
    DocumentNumber      NVARCHAR(30) NOT NULL,
    DocumentDate        DATE NOT NULL,
    
    -- Vehicle (Part B)
    VehicleNumber       NVARCHAR(20) NULL,
    VehicleType         NVARCHAR(10) NULL DEFAULT 'Regular',  -- Regular, OverDimensional
    DriverName          NVARCHAR(100) NULL,
    DriverLicenseNo     NVARCHAR(50) NULL,
    DriverMobile        NVARCHAR(20) NULL,
    
    -- Amount
    TaxableAmount       DECIMAL(18,2) NOT NULL,
    CGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGSTAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    CessAmount          DECIMAL(18,2) NOT NULL DEFAULT 0,
    OtherAmount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalValue          DECIMAL(18,2) NOT NULL,
    
    -- Consolidated
    IsConsolidated      BIT NOT NULL DEFAULT 0,
    ParentEWayBillId    BIGINT NULL,
    
    -- Cancel/Reject
    CancelledDate       DATETIME2 NULL,
    CancelledBy         BIGINT NULL,
    CancelReason        NVARCHAR(500) NULL,
    RejectedDate        DATETIME2 NULL,
    RejectedBy          BIGINT NULL,
    
    -- Audit
    CreatedBy           BIGINT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy          BIGINT NULL,
    ModifiedDate        DATETIME2 NULL,
    
    CONSTRAINT PK_EWayBills PRIMARY KEY CLUSTERED (EWayBillId),
    CONSTRAINT FK_EWayBills_Companies FOREIGN KEY (CompanyId) 
        REFERENCES master.Companies(CompanyId),
    CONSTRAINT FK_EWayBills_ParentEWayBill FOREIGN KEY (ParentEWayBillId) 
        REFERENCES compliance.EWayBills(EWayBillId),
    CONSTRAINT CK_EWayBills_TransportMode CHECK (TransportMode IN ('Road', 'Rail', 'Air', 'Ship')),
    CONSTRAINT CK_EWayBills_DocumentType CHECK (DocumentType IN ('TaxInvoice', 'DeliveryChallan', 'BillOfSupply', 'Others')),
    CONSTRAINT CK_EWayBills_EWayBillStatus CHECK (EWayBillStatus IN ('Pending', 'Generated', 'Cancelled', 'Expired', 'Rejected'))
);
GO

-- E-Way Bill Vehicles (Multi-vehicle support)
CREATE TABLE compliance.EWayBillVehicles
(
    EWayBillVehicleId   BIGINT IDENTITY(1,1) NOT NULL,
    EWayBillId          BIGINT NOT NULL,
    VehicleNumber       NVARCHAR(20) NOT NULL,
    VehicleType         NVARCHAR(10) NOT NULL DEFAULT 'Regular',
    DriverName          NVARCHAR(100) NULL,
    DriverLicenseNo     NVARCHAR(50) NULL,
    DriverMobile        NVARCHAR(20) NULL,
    FromPlace           NVARCHAR(200) NULL,
    FromStateCode       NVARCHAR(2) NULL,
    ToPlace             NVARCHAR(200) NULL,
    ToStateCode         NVARCHAR(2) NULL,
    Quantity            DECIMAL(18,4) NULL,
    IsPrimary           BIT NOT NULL DEFAULT 0,
    CreatedDate         DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_EWayBillVehicles PRIMARY KEY CLUSTERED (EWayBillVehicleId),
    CONSTRAINT FK_EWayBillVehicles_EWayBills FOREIGN KEY (EWayBillId) 
        REFERENCES compliance.EWayBills(EWayBillId)
);
GO

PRINT 'Tables compliance.EWayBills, compliance.EWayBillVehicles created successfully.';
GO
