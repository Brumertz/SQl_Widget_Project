/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
-- 1. Ensure all tables were created successfully
IF OBJECT_ID('[customer]') IS NULL
BEGIN
    PRINT 'Error: Table [customer] was not created successfully.'
END
ELSE
BEGIN
    PRINT 'Table [customer] created successfully.'
END

IF OBJECT_ID('[Orders]') IS NULL
BEGIN
    PRINT 'Error: Table [Orders] was not created successfully.'
END
ELSE
BEGIN
    PRINT 'Table [Orders] created successfully.'
END

IF OBJECT_ID('[OrderItems]') IS NULL
BEGIN
    PRINT 'Error: Table [OrderItems] was not created successfully.'
END
ELSE
BEGIN
    PRINT 'Table [OrderItems] created successfully.'
END

IF OBJECT_ID('[item]') IS NULL
BEGIN
    PRINT 'Error: Table [item] was not created successfully.'
END
ELSE
BEGIN
    PRINT 'Table [item] created successfully.'
END
GO

-- 2. Check foreign key integrity (no orphaned rows)
-- Ensure there are no orphaned Orders without a Customer
SELECT * 
FROM [Orders] o
WHERE NOT EXISTS (
    SELECT 1 FROM [customer] c
    WHERE c.[CustomerNumber] = o.[CustomerNumber]
);

-- Ensure there are no orphaned OrderItems without an Order
SELECT * 
FROM [OrderItems] oi
WHERE NOT EXISTS (
    SELECT 1 FROM [Orders] o
    WHERE o.[OrderNumber] = oi.[OrderNumber]
);

-- Ensure there are no orphaned OrderItems without an item
SELECT * 
FROM [OrderItems] oi
WHERE NOT EXISTS (
    SELECT 1 FROM [item] i
    WHERE i.[itemID] = oi.[itemID]
);

-- 3. Insert sample data for testing (optional)
-- Insert sample customers
INSERT INTO [customer] ([CustomerNumber], [CustomerName], [CustomerAddress], [CustomerCity], [CustomerState])
VALUES 
('C001', 'John Doe', '123 Main St', 'New York', 'NY'),
('C002', 'Jane Smith', '456 Oak St', 'Los Angeles', 'CA');

-- Insert sample items
INSERT INTO [item] ([itemID], [Description], [UnitPrice])
VALUES 
('I001', 'Widget A', 9.99),
('I002', 'Widget B', 19.99);

-- Insert sample orders
INSERT INTO [Orders] ([OrderNumber], [OrderDate], [CustomerNumber])
VALUES 
('O001', '2024-10-11', 'C001'),
('O002', '2024-10-12', 'C002');

-- Insert sample order items
INSERT INTO [OrderItems] ([OrderNumber], [itemID], [Quantity])
VALUES 
('O001', 'I001', 2),
('O002', 'I002', 1);
GO

-- 4. Ensure all inserted sample data is valid
-- Check customer data
SELECT * FROM [customer];
-- Check item data
SELECT * FROM [item];
-- Check order data
SELECT * FROM [Orders];
-- Check order items data
SELECT * FROM [OrderItems];
GO
