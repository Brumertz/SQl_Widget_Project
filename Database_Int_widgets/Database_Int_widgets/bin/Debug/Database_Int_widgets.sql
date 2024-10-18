﻿/*
Deployment script for Database_Int_widgets

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Database_Int_widgets"
:setvar DefaultFilePrefix "Database_Int_widgets"
:setvar DefaultDataPath "C:\Users\30085204\AppData\Local\Microsoft\VisualStudio\SSDT\Database_Int_widgets"
:setvar DefaultLogPath "C:\Users\30085204\AppData\Local\Microsoft\VisualStudio\SSDT\Database_Int_widgets"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE,
                DISABLE_BROKER 
            WITH ROLLBACK IMMEDIATE;
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creating Table [dbo].[customer]...';


GO
CREATE TABLE [dbo].[customer] (
    [CustomerNumber]  VARCHAR (10)  NOT NULL,
    [CustomerName]    VARCHAR (100) NOT NULL,
    [CustomerAddress] VARCHAR (255) NULL,
    [CustomerCity]    VARCHAR (50)  NULL,
    [CustomerState]   CHAR (2)      NULL,
    PRIMARY KEY CLUSTERED ([CustomerNumber] ASC)
);


GO
PRINT N'Creating Table [dbo].[item]...';


GO
CREATE TABLE [dbo].[item] (
    [itemID]      VARCHAR (10)    NOT NULL,
    [Description] VARCHAR (100)   NULL,
    [UnitPrice]   DECIMAL (10, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([itemID] ASC)
);


GO
PRINT N'Creating Table [dbo].[OrderItems]...';


GO
CREATE TABLE [dbo].[OrderItems] (
    [OrderNumber] VARCHAR (10) NOT NULL,
    [itemID]      VARCHAR (10) NOT NULL,
    [Quantity]    INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([OrderNumber] ASC, [itemID] ASC)
);


GO
PRINT N'Creating Table [dbo].[Orders]...';


GO
CREATE TABLE [dbo].[Orders] (
    [OrderNumber]    VARCHAR (10) NOT NULL,
    [OrderDate]      DATE         NOT NULL,
    [CustomerNumber] VARCHAR (10) NOT NULL,
    PRIMARY KEY CLUSTERED ([OrderNumber] ASC)
);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[OrderItems]...';


GO
ALTER TABLE [dbo].[OrderItems] WITH NOCHECK
    ADD FOREIGN KEY ([OrderNumber]) REFERENCES [dbo].[Orders] ([OrderNumber]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[OrderItems]...';


GO
ALTER TABLE [dbo].[OrderItems] WITH NOCHECK
    ADD FOREIGN KEY ([itemID]) REFERENCES [dbo].[item] ([itemID]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Orders]...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD FOREIGN KEY ([CustomerNumber]) REFERENCES [dbo].[customer] ([CustomerNumber]);


GO
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

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
CREATE TABLE [#__checkStatus] (
    id           INT            IDENTITY (1, 1) PRIMARY KEY CLUSTERED,
    [Schema]     NVARCHAR (256),
    [Table]      NVARCHAR (256),
    [Constraint] NVARCHAR (256)
);

SET NOCOUNT ON;

DECLARE tableconstraintnames CURSOR LOCAL FORWARD_ONLY
    FOR SELECT SCHEMA_NAME([schema_id]),
               OBJECT_NAME([parent_object_id]),
               [name],
               0
        FROM   [sys].[objects]
        WHERE  [parent_object_id] IN (OBJECT_ID(N'dbo.OrderItems'), OBJECT_ID(N'dbo.Orders'))
               AND [type] IN (N'F', N'C')
                   AND [object_id] IN (SELECT [object_id]
                                       FROM   [sys].[check_constraints]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0
                                       UNION
                                       SELECT [object_id]
                                       FROM   [sys].[foreign_keys]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0);

DECLARE @schemaname AS NVARCHAR (256);

DECLARE @tablename AS NVARCHAR (256);

DECLARE @checkname AS NVARCHAR (256);

DECLARE @is_not_trusted AS INT;

DECLARE @statement AS NVARCHAR (1024);

BEGIN TRY
    OPEN tableconstraintnames;
    FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
    WHILE @@fetch_status = 0
        BEGIN
            PRINT N'Checking constraint: ' + @checkname + N' [' + @schemaname + N'].[' + @tablename + N']';
            SET @statement = N'ALTER TABLE [' + @schemaname + N'].[' + @tablename + N'] WITH ' + CASE @is_not_trusted WHEN 0 THEN N'CHECK' ELSE N'NOCHECK' END + N' CHECK CONSTRAINT [' + @checkname + N']';
            BEGIN TRY
                EXECUTE [sp_executesql] @statement;
            END TRY
            BEGIN CATCH
                INSERT  [#__checkStatus] ([Schema], [Table], [Constraint])
                VALUES                  (@schemaname, @tablename, @checkname);
            END CATCH
            FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
        END
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') >= 0
    CLOSE tableconstraintnames;

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') = -1
    DEALLOCATE tableconstraintnames;

SELECT N'Constraint verification failed:' + [Schema] + N'.' + [Table] + N',' + [Constraint]
FROM   [#__checkStatus];

IF @@ROWCOUNT > 0
    BEGIN
        DROP TABLE [#__checkStatus];
        RAISERROR (N'An error occurred while verifying constraints', 16, 127);
    END

SET NOCOUNT OFF;

DROP TABLE [#__checkStatus];


GO
PRINT N'Update complete.';


GO
