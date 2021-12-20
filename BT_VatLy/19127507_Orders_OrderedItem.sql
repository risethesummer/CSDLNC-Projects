CREATE DATABASE ORDER_ENTRY
GO

USE ORDER_ENTRY
GO

CREATE TABLE Orders (
	OrderNumber CHAR(8) PRIMARY KEY,
	CustomerIdentifer CHAR(6) NULL ,
	OrderDate DATETIME NOT NULL,
	ShippingStreetAddress NVARCHAR(30) NOT NULL,
	ShippingCity NVARCHAR(20) NOT NULL,
	ShippingState BIT NOT NULL,
	ShippingZipCode CHAR(6) NOT NULL,
	CustomerCreditCardNumber CHAR(16) NOT NULL,
	ShippingDate DATETIME NOT NULL,
	TotalPrice DECIMAL(15,2) NULL
	CONSTRAINT CHK_Orders CHECK (TotalPrice >= 0)
)
GO

CREATE TABLE Ordered_Item (
	ItemNumber CHAR(6),
	OrderNumber CHAR(8),
	QuantityOrdered INT NOT NULL,
	SellingPrice DECIMAL(15,2) NOT NULL,
	ShippingDate DATETIME NOT NULL,
	TotalPriceOrderedItem DECIMAL(15,2),
	PRIMARY KEY (ItemNumber, OrderNumber),
	CONSTRAINT CHK_Ordered_Item CHECK (QuantityOrdered >= 0 AND SellingPrice >= 0)
)
GO

ALTER TABLE dbo.Ordered_Item ADD CONSTRAINT FK_OrderedItem
FOREIGN KEY (OrderNumber) REFERENCES dbo.Orders(OrderNumber)
ALTER TABLE dbo.ORDERS ADD CONSTRAINT FK_CustomerOrder
FOREIGN KEY (CustomerIdentifer) REFERENCES Customer(CustomerIdentifier)
ALTER TABLE dbo.ORDERS ADD CONSTRAINT FK_CardOrder
FOREIGN KEY (CustomerCreditCardNumber) REFERENCES Credit_Card(CustomerCreditCardNumber)