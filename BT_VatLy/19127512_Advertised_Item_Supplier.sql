CREATE TABLE Advertised_Item (
    ItemNumber CHAR(6) PRIMARY KEY,
    ItemDescription NVARCHAR NOT NULL,
    ItemDepartment CHAR(10) NOT NULL,
    ItemWeight FLOAT NOT NULL,
    ItemColor Char(10) NOT NULL, 
    ItemPrice DECIMAL(15,2) NOT NULL CONSTRAINT pos_ItemPrice CHECK(ItemPrice >= 0),
    MinPriceSupplier CHAR(5) NULL,
    MinSuppliedPrice DECIMAL(15,2) NULL,
    TotalOrderedTime INT NOT NULL CONSTRAINT pos_TotalOrderedTime CHECK (TotalOrderedTime >= 0)
);

CREATE TABLE Supplier (
    SupplierID CHAR(5) PRIMARY KEY,
    SupplierName NVARCHAR(20) NOT NULL,
    SupplierStreetAddress NVARCHAR(30) NOT NULL,
    SupplierCity NVARCHAR(20) NOT NULL,
    SupplierState NVARCHAR(20) NOT NULL,
    SupplierZipCode CHAR(6) NOT NULL
);

ALTER TABLE Advertised_Item ADD CONSTRAINT FK_Advertised_Item_Supplier FOREIGN KEY (MinPriceSupplier) REFERENCES Supplier(SupplierID);