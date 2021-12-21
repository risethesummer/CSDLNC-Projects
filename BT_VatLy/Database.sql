CREATE DATABASE ORDER_ENTRY
GO

USE ORDER_ENTRY
GO

CREATE TABLE Supplier (
    SupplierID CHAR(5) PRIMARY KEY,
    SupplierName NVARCHAR(20) NOT NULL,
    SupplierStreetAddress NVARCHAR(30) NOT NULL,
    SupplierCity NVARCHAR(20) NOT NULL,
    SupplierState NVARCHAR(20) NOT NULL,
    SupplierZipCode CHAR(6) NOT NULL
);
GO

CREATE TABLE Advertised_Item (
    ItemNumber CHAR(6) PRIMARY KEY,
    ItemDescription NVARCHAR(30) NOT NULL,
    ItemDepartment CHAR(10) NOT NULL,
    ItemWeight FLOAT NOT NULL CHECK(ItemWeight > 0),
    ItemColor CHAR(10) NOT NULL, 
    ItemPrice DECIMAL(15,2) NOT NULL CONSTRAINT pos_ItemPrice CHECK(ItemPrice >= 0),
    MinPriceSupplier CHAR(5),
    MinSuppliedPrice DECIMAL(15,2),
    TotalOrderedTime INT NOT NULL DEFAULT 0 CONSTRAINT pos_TotalOrderedTime CHECK (TotalOrderedTime >= 0),
	FOREIGN KEY (MinPriceSupplier) REFERENCES Supplier(SupplierID)
);
GO

CREATE TABLE Restock_Item (
	ItemNumber CHAR(6) NOT NULL,
	SupplierID CHAR(5) NOT NULL,
	PurchasePrice DECIMAL(15, 2) NOT NULL CHECK(PurchasePrice > 0),
	FOREIGN KEY (ItemNumber) REFERENCES Advertised_Item(ItemNumber),
	FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);
GO

CREATE TABLE Customer
(
	CustomerIdentifier CHAR(6) PRIMARY KEY,
	CustomerTelephoneNumber CHAR(10) NOT NULL UNIQUE,
	CustomerName NVARCHAR(20) NOT NULL,
	CustomerStreetAddress NVARCHAR(15) NOT NULL DEFAULT '',
	CustomerCity NVARCHAR(15) NOT NULL DEFAULT '',
	CustomerState NVARCHAR(15) NOT NULL DEFAULT '',
	CustomerZipCode CHAR(6) NOT NULL DEFAULT '',
	CustomerCreditRating FLOAT NOT NULL DEFAULT 0,
	CustomerTotalOrder INT NOT NULL DEFAULT 0 CHECK(CustomerTotalOrder >= 0)
);
GO

CREATE TABLE Credit_Card
(
	CustomerCreditCardNumber CHAR(16) PRIMARY KEY,
	CustomerIdentifier CHAR(6) NOT NULL,
	CountOrder INT NOT NULL DEFAULT 1 CHECK (CountOrder >=0),
	CustomerCreditCardName NVARCHAR(15) NOT NULL,
	PreferredOption BIT DEFAULT 0,
	FOREIGN KEY (CustomerIdentifier) REFERENCES Customer(CustomerIdentifier)
);
GO

CREATE TABLE Orders (
	OrderNumber CHAR(8) PRIMARY KEY,
	CustomerIdentifer CHAR(6) NOT NULL,
	OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
	ShippingStreetAddress NVARCHAR(30) NOT NULL,
	ShippingCity NVARCHAR(20) NOT NULL,
	ShippingState BIT NOT NULL,
	ShippingZipCode CHAR(6) NOT NULL,
	CustomerCreditCardNumber CHAR(16) NOT NULL,
	ShippingDate DATETIME NOT NULL,
	TotalPrice DECIMAL(15,2) NOT NULL DEFAULT 0 CONSTRAINT CHK_Orders CHECK (TotalPrice >= 0),
	FOREIGN KEY (CustomerIdentifer) REFERENCES Customer(CustomerIdentifier),
	FOREIGN KEY (CustomerCreditCardNumber) REFERENCES Credit_Card(CustomerCreditCardNumber)
);
GO

CREATE TABLE Ordered_Item (
	ItemNumber CHAR(6) NOT NULL,
	OrderNumber CHAR(8) NOT NULL,
	QuantityOrdered INT NOT NULL CHECK(QuantityOrdered > 0),
	SellingPrice DECIMAL(15,2) NOT NULL CHECK(SellingPrice >= 0),
	ShippingDate DATETIME NOT NULL DEFAULT GETDATE(),
	TotalPriceOrderedItem DECIMAL(15,2) NOT NULL CHECK (TotalPriceOrderedItem >= 0),
	PRIMARY KEY (ItemNumber, OrderNumber),
	FOREIGN KEY (OrderNumber) REFERENCES dbo.Orders(OrderNumber),
	FOREIGN KEY (ItemNumber) REFERENCES dbo.Advertised_Item(ItemNumber)
);
GO
