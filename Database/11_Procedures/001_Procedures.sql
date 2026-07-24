-- ============================================================================
-- TEXTILE ERP - STORED PROCEDURES
-- ============================================================================

USE TextileERP;
GO

-- ============================================================================
-- PROCEDURE: sp_GetNextDocumentNumber
-- Description: Generate sequential document numbers with gap prevention
-- ============================================================================
CREATE OR ALTER PROCEDURE master.sp_GetNextDocumentNumber
    @CompanyId BIGINT,
    @DocumentType NVARCHAR(30),
    @FinancialYear NVARCHAR(10),
    @NextNumber NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Prefix NVARCHAR(20);
    DECLARE @CurrentNumber BIGINT;
    DECLARE @MinDigits INT;
    DECLARE @NewNumber BIGINT;
    
    -- Get or create sequence
    IF NOT EXISTS (
        SELECT 1 FROM compliance.DocumentSequence 
        WHERE CompanyId = @CompanyId 
        AND DocumentType = @DocumentType 
        AND FinancialYear = @FinancialYear
    )
    BEGIN
        INSERT INTO compliance.DocumentSequence (CompanyId, DocumentType, FinancialYear, CurrentNumber, MinDigits)
        VALUES (@CompanyId, @DocumentType, @FinancialYear, 0, 6);
    END
    
    -- Lock the row and get current number
    SELECT @Prefix = Prefix, @CurrentNumber = CurrentNumber, @MinDigits = MinDigits
    FROM compliance.DocumentSequence WITH (UPDLOCK, HOLDLOCK)
    WHERE CompanyId = @CompanyId 
    AND DocumentType = @DocumentType 
    AND FinancialYear = @FinancialYear;
    
    -- Increment
    SET @NewNumber = @CurrentNumber + 1;
    
    -- Update
    UPDATE compliance.DocumentSequence 
    SET CurrentNumber = @NewNumber,
        ModifiedDate = GETDATE()
    WHERE CompanyId = @CompanyId 
    AND DocumentType = @DocumentType 
    AND FinancialYear = @FinancialYear;
    
    -- Format number
    SET @NextNumber = @Prefix + RIGHT('0000000000' + CAST(@NewNumber AS NVARCHAR(10)), @MinDigits);
    
    SELECT @NextNumber AS DocumentNumber;
END
GO

-- ============================================================================
-- PROCEDURE: sp_CalculateGST
-- Description: Calculate GST for a transaction
-- ============================================================================
CREATE OR ALTER PROCEDURE master.sp_CalculateGST
    @CompanyId BIGINT,
    @PartyId BIGINT,
    @StateCode NVARCHAR(2),
    @TaxableAmount DECIMAL(18,2),
    @GSTRate DECIMAL(5,2),
    @IsInterState BIT,
    @CGSTAmount DECIMAL(18,2) OUTPUT,
    @SGSTAmount DECIMAL(18,2) OUTPUT,
    @IGSTAmount DECIMAL(18,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CompanyStateCode NVARCHAR(2);
    
    -- Get company state code
    SELECT @CompanyStateCode = StateCode 
    FROM master.Companies 
    WHERE CompanyId = @CompanyId;
    
    -- Determine if inter-state
    IF @StateCode IS NOT NULL
        SET @IsInterState = CASE WHEN @CompanyStateCode <> @StateCode THEN 1 ELSE 0 END;
    
    -- Calculate GST
    IF @IsInterState = 1
    BEGIN
        -- Inter-state: IGST
        SET @CGSTAmount = 0;
        SET @SGSTAmount = 0;
        SET @IGSTAmount = @TaxableAmount * @GSTRate / 100;
    END
    ELSE
    BEGIN
        -- Intra-state: CGST + SGST
        SET @CGSTAmount = @TaxableAmount * (@GSTRate / 2) / 100;
        SET @SGSTAmount = @TaxableAmount * (@GSTRate / 2) / 100;
        SET @IGSTAmount = 0;
    END
    
    SELECT @CGSTAmount AS CGSTAmount, @SGSTAmount AS SGSTAmount, @IGSTAmount AS IGSTAmount;
END
GO

-- ============================================================================
-- PROCEDURE: sp_UpdateStock
-- Description: Update stock levels for an item
-- ============================================================================
CREATE OR ALTER PROCEDURE inventory.sp_UpdateStock
    @CompanyId BIGINT,
    @ItemId BIGINT,
    @GodownId BIGINT,
    @Quantity DECIMAL(18,4),
    @Rate DECIMAL(18,4),
    @TransactionType NVARCHAR(20),  -- Inward, Outward
    @BatchNumber NVARCHAR(50) = NULL,
    @ColorCode NVARCHAR(20) = NULL,
    @ShadeCode NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    DECLARE @CurrentQuantity DECIMAL(18,4);
    DECLARE @CurrentValue DECIMAL(18,2);
    
    -- Get current stock
    SELECT @CurrentQuantity = CurrentQuantity, @CurrentValue = CurrentValue
    FROM inventory.StockSummary
    WHERE CompanyId = @CompanyId 
    AND ItemId = @ItemId 
    AND GodownId = @GodownId
    AND ISNULL(BatchNumber, '') = ISNULL(@BatchNumber, '')
    AND ISNULL(ColorCode, '') = ISNULL(@ColorCode, '')
    AND ISNULL(ShadeCode, '') = ISNULL(@ShadeCode, '');
    
    -- Set defaults
    SET @CurrentQuantity = ISNULL(@CurrentQuantity, 0);
    SET @CurrentValue = ISNULL(@CurrentValue, 0);
    
    IF @TransactionType = 'Inward'
    BEGIN
        -- Inward: Increase stock
        UPDATE inventory.StockSummary
        SET CurrentQuantity = CurrentQuantity + @Quantity,
            CurrentValue = CurrentValue + (@Quantity * @Rate),
            InwardQuantity = InwardQuantity + @Quantity,
            InwardValue = InwardValue + (@Quantity * @Rate),
            LastMovementDate = GETDATE(),
            ModifiedDate = GETDATE()
        WHERE CompanyId = @CompanyId 
        AND ItemId = @ItemId 
        AND GodownId = @GodownId
        AND ISNULL(BatchNumber, '') = ISNULL(@BatchNumber, '')
        AND ISNULL(ColorCode, '') = ISNULL(@ColorCode, '')
        AND ISNULL(ShadeCode, '') = ISNULL(@ShadeCode, '');
        
        -- Insert if not exists
        IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO inventory.StockSummary (
                CompanyId, ItemId, GodownId, BatchNumber, ColorCode, ShadeCode,
                InwardQuantity, InwardValue, CurrentQuantity, CurrentValue, LastMovementDate
            )
            VALUES (
                @CompanyId, @ItemId, @GodownId, @BatchNumber, @ColorCode, @ShadeCode,
                @Quantity, @Quantity * @Rate, @Quantity, @Quantity * @Rate, GETDATE()
            );
        END
    END
    ELSE IF @TransactionType = 'Outward'
    BEGIN
        -- Outward: Decrease stock
        UPDATE inventory.StockSummary
        SET CurrentQuantity = CurrentQuantity - @Quantity,
            CurrentValue = CurrentValue - (@Quantity * @Rate),
            OutwardQuantity = OutwardQuantity + @Quantity,
            OutwardValue = OutwardValue + (@Quantity * @Rate),
            LastMovementDate = GETDATE(),
            ModifiedDate = GETDATE()
        WHERE CompanyId = @CompanyId 
        AND ItemId = @ItemId 
        AND GodownId = @GodownId
        AND ISNULL(BatchNumber, '') = ISNULL(@BatchNumber, '')
        AND ISNULL(ColorCode, '') = ISNULL(@ColorCode, '')
        AND ISNULL(ShadeCode, '') = ISNULL(@ShadeCode, '');
    END
    
    COMMIT TRANSACTION;
END
GO

-- ============================================================================
-- PROCEDURE: sp_CalculateTDS
-- Description: Calculate TDS based on section and threshold
-- ============================================================================
CREATE OR ALTER PROCEDURE master.sp_CalculateTDS
    @PartyId BIGINT,
    @Amount DECIMAL(18,2),
    @TDSSection NVARCHAR(10),
    @TDSDeducted DECIMAL(18,2) OUTPUT,
    @IsApplicable BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TDSRate DECIMAL(5,2);
    DECLARE @Threshold DECIMAL(18,2);
    DECLARE @IsPANValidated BIT;
    DECLARE @IsIndividual BIT;
    
    -- Get party TDS details
    SELECT @IsPANValidated = CASE WHEN PAN IS NOT NULL AND LEN(PAN) = 10 THEN 1 ELSE 0 END
    FROM master.Parties
    WHERE PartyId = @PartyId;
    
    -- Set rate based on section and PAN
    SET @IsApplicable = 1;
    
    IF @TDSSection = '194C'
    BEGIN
        SET @TDSRate = CASE WHEN @IsPANValidated = 1 THEN 1 ELSE 2 END;
        SET @Threshold = 30000;  -- Per transaction threshold
    END
    ELSE IF @TDSSection = '194Q'
    BEGIN
        SET @TDSRate = CASE WHEN @IsPANValidated = 1 THEN 0.1 ELSE 2 END;
        SET @Threshold = 5000000;  -- 50 Lakh
    END
    ELSE IF @TDSSection = '194J'
    BEGIN
        SET @TDSRate = CASE WHEN @IsPANValidated = 1 THEN 10 ELSE 20 END;
        SET @Threshold = 30000;  -- Per transaction threshold
    END
    ELSE IF @TDSSection = '194A'
    BEGIN
        SET @TDSRate = CASE WHEN @IsPANValidated = 1 THEN 10 ELSE 20 END;
        SET @Threshold = 40000;  -- 40000 for banks, 5000 for others
    END
    ELSE IF @TDSSection = '194I(a)'
    BEGIN
        SET @TDSRate = CASE WHEN @IsPANValidated = 1 THEN 2 ELSE 20 END;
        SET @Threshold = 240000;  -- 2.4 Lakh per annum
    END
    ELSE IF @TDSSection = '194I(b)'
    BEGIN
        SET @TDSRate = CASE WHEN @IsPANValidated = 1 THEN 10 ELSE 20 END;
        SET @Threshold = 240000;  -- 2.4 Lakh per annum
    END
    ELSE
    BEGIN
        SET @TDSRate = 10;
        SET @Threshold = 0;
    END
    
    -- Check threshold
    IF @Amount >= @Threshold
    BEGIN
        SET @TDSDeducted = @Amount * @TDSRate / 100;
        SET @IsApplicable = 1;
    END
    ELSE
    BEGIN
        SET @TDSDeducted = 0;
        SET @IsApplicable = 0;
    END
    
    SELECT @TDSDeducted AS TDSDeducted, @IsApplicable AS IsApplicable;
END
GO

-- ============================================================================
-- PROCEDURE: sp_CalculateTCS
-- Description: Calculate TCS based on section
-- ============================================================================
CREATE OR ALTER PROCEDURE master.sp_CalculateTCS
    @PartyId BIGINT,
    @Amount DECIMAL(18,2),
    @TCSSection NVARCHAR(10),
    @TCSAmount DECIMAL(18,2) OUTPUT,
    @IsApplicable BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TCSRate DECIMAL(5,2);
    DECLARE @Threshold DECIMAL(18,2);
    
    -- Set rate based on section
    SET @IsApplicable = 1;
    
    IF @TCSSection = '206C(1H)'
    BEGIN
        SET @TCSRate = 0.075;  -- 0.075% (0.1% from Oct 2023)
        SET @Threshold = 5000000;  -- 50 Lakh
    END
    ELSE IF @TCSSection = '206C(1G)'
    BEGIN
        SET @TCSRate = 0.5;  -- 0.5% for remittance under LRS
        SET @Threshold = 700000;  -- 7 Lakh per financial year
    END
    ELSE IF @TCSSection = '206C(1F)'
    BEGIN
        SET @TCSRate = 1;  -- 1%
        SET @Threshold = 5000000;  -- 50 Lakh
    END
    ELSE
    BEGIN
        SET @TCSRate = 0.075;
        SET @Threshold = 5000000;
    END
    
    -- Check threshold
    IF @Amount >= @Threshold
    BEGIN
        SET @TCSAmount = @Amount * @TCSRate / 100;
        SET @IsApplicable = 1;
    END
    ELSE
    BEGIN
        SET @TCSAmount = 0;
        SET @IsApplicable = 0;
    END
    
    SELECT @TCSAmount AS TCSAmount, @IsApplicable AS IsApplicable;
END
GO

-- ============================================================================
-- PROCEDURE: sp_GetStockSummary
-- Description: Get stock summary for items
-- ============================================================================
CREATE OR ALTER PROCEDURE inventory.sp_GetStockSummary
    @CompanyId BIGINT,
    @ItemId BIGINT = NULL,
    @GodownId BIGINT = NULL,
    @CategoryType NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        i.ItemId,
        i.ItemCode,
        i.ItemName,
        i.HSNCode,
        i.GSTRate,
        g.GodownId,
        g.GodownName,
        i.UnitId,
        u.UnitName,
        ss.BatchNumber,
        ss.ColorCode,
        ss.ShadeCode,
        ss.CurrentQuantity,
        ss.CurrentValue,
        ss.ReservedQuantity,
        ss.AvailableQuantity,
        ss.AverageRate,
        ss.LastPurchaseDate,
        ss.LastSalesDate
    FROM inventory.StockSummary ss
    INNER JOIN master.Items i ON ss.ItemId = i.ItemId
    INNER JOIN master.Godowns g ON ss.GodownId = g.GodownId
    INNER JOIN master.Units u ON i.UnitId = u.UnitId
    WHERE ss.CompanyId = @CompanyId
    AND (@ItemId IS NULL OR ss.ItemId = @ItemId)
    AND (@GodownId IS NULL OR ss.GodownId = @GodownId)
    ORDER BY i.ItemCode, g.GodownName;
END
GO

-- ============================================================================
-- PROCEDURE: sp_GetGSTSummary
-- Description: Get GST summary for a period
-- ============================================================================
CREATE OR ALTER PROCEDURE tax.sp_GetGSTSummary
    @CompanyId BIGINT,
    @FromDate DATE,
    @ToDate DATE,
    @ReturnType NVARCHAR(10) = 'GSTR1'
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @ReturnType = 'GSTR1'
    BEGIN
        SELECT 
            si.InvoiceDate,
            si.InvoiceNumber,
            p.PartyName,
            p.GSTIN,
            si.CustomerStateCode AS StateCode,
            CASE WHEN si.IsInterState = 1 THEN 'Inter-State' ELSE 'Intra-State' END AS SupplyType,
            si.TotalTaxableAmount AS TaxableAmount,
            si.TotalCGST AS CGST,
            si.TotalSGST AS SGST,
            si.TotalIGST AS IGST,
            si.TotalCess AS Cess,
            si.NetAmount AS InvoiceValue
        FROM sales.SalesInvoices si
        INNER JOIN master.Parties p ON si.CustomerId = p.PartyId
        WHERE si.CompanyId = @CompanyId
        AND si.InvoiceDate BETWEEN @FromDate AND @ToDate
        AND si.IsCancelled = 0
        ORDER BY si.InvoiceDate, si.InvoiceNumber;
    END
    ELSE IF @ReturnType = 'GSTR3B'
    BEGIN
        SELECT 
            'Outward Supplies' AS Description,
            SUM(si.TotalTaxableAmount) AS TaxableValue,
            SUM(si.TotalCGST) AS CGST,
            SUM(si.TotalSGST) AS SGST,
            SUM(si.TotalIGST) AS IGST,
            SUM(si.TotalCess) AS Cess
        FROM sales.SalesInvoices si
        WHERE si.CompanyId = @CompanyId
        AND si.InvoiceDate BETWEEN @FromDate AND @ToDate
        AND si.IsCancelled = 0
        
        UNION ALL
        
        SELECT 
            'Inward Supplies (RCM)' AS Description,
            SUM(pi.TotalTaxableAmount) AS TaxableValue,
            SUM(pi.TotalCGST) AS CGST,
            SUM(pi.TotalSGST) AS SGST,
            SUM(pi.TotalIGST) AS IGST,
            SUM(pi.TotalCess) AS Cess
        FROM purchase.PurchaseInvoices pi
        WHERE pi.CompanyId = @CompanyId
        AND pi.InvoiceDate BETWEEN @FromDate AND @ToDate
        AND pi.IsReverseCharge = 1
        AND pi.IsCancelled = 0;
    END
END
GO

-- ============================================================================
-- PROCEDURE: sp_GetOutstandingReport
-- Description: Get outstanding report for customers/suppliers
-- ============================================================================
CREATE OR ALTER PROCEDURE finance.sp_GetOutstandingReport
    @CompanyId BIGINT,
    @PartyType NVARCHAR(10),  -- Customer, Supplier
    @PartyId BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @PartyType = 'Customer'
    BEGIN
        SELECT 
            p.PartyId,
            p.PartyCode,
            p.PartyName,
            p.GSTIN,
            p.Phone,
            p.Email,
            SUM(or1.InvoiceAmount) AS TotalInvoiceAmount,
            SUM(or1.PaidAmount) AS TotalPaidAmount,
            SUM(or1.BalanceAmount) AS TotalBalanceAmount,
            MIN(or1.DueDate) AS EarliestDueDate,
            MAX(or1.DaysOverdue) AS MaxDaysOverdue
        FROM finance.OutstandingReceivable or1
        INNER JOIN master.Parties p ON or1.CustomerId = p.PartyId
        WHERE or1.CompanyId = @CompanyId
        AND or1.IsActive = 1
        AND (@PartyId IS NULL OR or1.CustomerId = @PartyId)
        GROUP BY p.PartyId, p.PartyCode, p.PartyName, p.GSTIN, p.Phone, p.Email
        HAVING SUM(or1.BalanceAmount) > 0
        ORDER BY SUM(or1.BalanceAmount) DESC;
    END
    ELSE IF @PartyType = 'Supplier'
    BEGIN
        SELECT 
            p.PartyId,
            p.PartyCode,
            p.PartyName,
            p.GSTIN,
            p.Phone,
            p.Email,
            SUM(op.InvoiceAmount) AS TotalInvoiceAmount,
            SUM(op.PaidAmount) AS TotalPaidAmount,
            SUM(op.BalanceAmount) AS TotalBalanceAmount,
            MIN(op.DueDate) AS EarliestDueDate,
            MAX(op.DaysOverdue) AS MaxDaysOverdue
        FROM finance.OutstandingPayable op
        INNER JOIN master.Parties p ON op.SupplierId = p.PartyId
        WHERE op.CompanyId = @CompanyId
        AND op.IsActive = 1
        AND (@PartyId IS NULL OR op.SupplierId = @PartyId)
        GROUP BY p.PartyId, p.PartyCode, p.PartyName, p.GSTIN, p.Phone, p.Email
        HAVING SUM(op.BalanceAmount) > 0
        ORDER BY SUM(op.BalanceAmount) DESC;
    END
END
GO

-- ============================================================================
-- PROCEDURE: sp_GenerateEWayBill
-- Description: Prepare E-way bill data for generation
-- ============================================================================
CREATE OR ALTER PROCEDURE compliance.sp_GenerateEWayBill
    @CompanyId BIGINT,
    @InvoiceId BIGINT,
    @InvoiceType NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CompanyGSTIN NVARCHAR(15);
    DECLARE @CompanyStateCode NVARCHAR(2);
    DECLARE @InvoiceValue DECIMAL(18,2);
    DECLARE @IsInterState BIT;
    
    -- Get company details
    SELECT @CompanyGSTIN = GSTIN, @CompanyStateCode = StateCode
    FROM master.Companies
    WHERE CompanyId = @CompanyId;
    
    IF @InvoiceType = 'Sales'
    BEGIN
        SELECT 
            si.SalesInvoiceId,
            si.InvoiceNumber,
            si.InvoiceDate,
            si.InvoiceValue,
            si.IsInterState,
            @CompanyGSTIN AS SupplierGSTIN,
            @CompanyStateCode AS SupplierStateCode,
            p.GSTIN AS RecipientGSTIN,
            si.CustomerStateCode AS RecipientStateCode,
            p.PartyName AS RecipientName,
            si.PlaceOfSupplyStateCode AS PlaceOfSupplyCode,
            si.TotalTaxableAmount AS TaxableAmount,
            si.TotalCGST AS CGSTAmount,
            si.TotalSGST AS SGSTAmount,
            si.TotalIGST AS IGSTAmount,
            si.TotalCess AS CessAmount,
            si.NetAmount AS TotalValue,
            CASE WHEN si.InvoiceValue > 50000 THEN 1 ELSE 0 END AS IsEWayBillRequired
        FROM sales.SalesInvoices si
        INNER JOIN master.Parties p ON si.CustomerId = p.PartyId
        WHERE si.SalesInvoiceId = @InvoiceId
        AND si.CompanyId = @CompanyId;
    END
END
GO

-- ============================================================================
-- PROCEDURE: sp_GenerateIRN
-- Description: Prepare E-invoice data for IRN generation
-- ============================================================================
CREATE OR ALTER PROCEDURE compliance.sp_GenerateIRN
    @CompanyId BIGINT,
    @InvoiceId BIGINT,
    @InvoiceType NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CompanyGSTIN NVARCHAR(15);
    DECLARE @CompanyStateCode NVARCHAR(2);
    
    -- Get company details
    SELECT @CompanyGSTIN = GSTIN, @CompanyStateCode = StateCode
    FROM master.Companies
    WHERE CompanyId = @CompanyId;
    
    IF @InvoiceType = 'Sales'
    BEGIN
        SELECT 
            si.SalesInvoiceId,
            si.InvoiceNumber,
            si.InvoiceDate,
            si.InvoiceType,
            @CompanyGSTIN AS SupplierGSTIN,
            c.LegalName AS SupplierLegalName,
            c.TradeName AS SupplierTradeName,
            c.AddressLine1 + ', ' + ISNULL(c.City, '') AS SupplierAddress,
            c.City AS SupplierCity,
            @CompanyStateCode AS SupplierStateCode,
            c.PinCode AS SupplierPinCode,
            c.Phone AS SupplierPhone,
            c.Email AS SupplierEmail,
            p.GSTIN AS RecipientGSTIN,
            p.LegalName AS RecipientLegalName,
            p.TradeName AS RecipientTradeName,
            p.AddressLine1 + ', ' + ISNULL(p.City, '') AS RecipientAddress,
            p.City AS RecipientCity,
            si.CustomerStateCode AS RecipientStateCode,
            p.PinCode AS RecipientPinCode,
            p.Phone AS RecipientPhone,
            p.Email AS RecipientEmail,
            si.PlaceOfSupplyStateCode AS PlaceOfSupplyCode,
            si.TotalTaxableAmount AS TaxableAmount,
            si.TotalCGST AS CGSTAmount,
            si.TotalSGST AS SGSTAmount,
            si.TotalIGST AS IGSTAmount,
            si.TotalCess AS CessAmount,
            si.NetAmount AS TotalInvoiceValue,
            CASE WHEN si.InvoiceValue > 5000 THEN 1 ELSE 0 END AS IsEInvoiceRequired
        FROM sales.SalesInvoices si
        INNER JOIN master.Parties p ON si.CustomerId = p.PartyId
        INNER JOIN master.Companies c ON si.CompanyId = c.CompanyId
        WHERE si.SalesInvoiceId = @InvoiceId
        AND si.CompanyId = @CompanyId;
    END
END
GO

PRINT 'All stored procedures created successfully.';
GO
