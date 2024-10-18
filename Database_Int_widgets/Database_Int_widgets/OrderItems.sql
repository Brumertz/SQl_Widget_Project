CREATE TABLE [dbo].[OrderItems]
(
	[OrderNumber] VARCHAR(10) NOT NULL,
    [itemID] VARCHAR(10) NOT NULL,
    [Quantity] INT NOT NULL,
    PRIMARY KEY ([OrderNumber], [itemID]),
    FOREIGN KEY ([OrderNumber]) REFERENCES [Orders]([OrderNumber]),
    FOREIGN KEY ([itemID]) REFERENCES [item]([itemID])
)
