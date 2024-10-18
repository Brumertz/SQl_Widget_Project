CREATE TABLE [dbo].[customer]
([CustomerNumber] VARCHAR(10) NOT NULL PRIMARY KEY,
    [CustomerName] VARCHAR(100) NOT NULL,
    [CustomerAddress] VARCHAR(255) NULL,
    [CustomerCity] VARCHAR(50) NULL,
    [CustomerState] CHAR(2) NULL
)
