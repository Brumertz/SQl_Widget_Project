CREATE TABLE [dbo].[Orders]
(
	[OrderNumber] VARCHAR(10) NOT NULL PRIMARY KEY,
    [OrderDate] DATE NOT NULL,
    [CustomerNumber] VARCHAR(10) NOT NULL,
    FOREIGN KEY ([CustomerNumber]) REFERENCES [customer]([CustomerNumber])
)
