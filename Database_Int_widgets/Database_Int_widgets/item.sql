-- Create table item
CREATE TABLE [item] (
    [itemID] VARCHAR(10) NOT NULL PRIMARY KEY,
    [Description] VARCHAR(100) NULL,
    [UnitPrice] DECIMAL(10, 2) NOT NULL
);