USE ORDER_ENTRY
GO

INSERT INTO dbo.Supplier
(
    SupplierID,
    SupplierName,
    SupplierStreetAddress,
    SupplierCity,
    SupplierState,
    SupplierZipCode
)
VALUES
(   'NC001',  -- SupplierID - char(5)
    N'CÔNG TY A', -- SupplierName - nvarchar(20)
    N'100 Nguyễn Văn Cừ', -- SupplierStreetAddress - nvarchar(30)
    N'TP Hồ Chí Minh', -- SupplierCity - nvarchar(20)
    N'abc', -- SupplierState - nvarchar(20)
    '123456'   -- SupplierZipCode - char(6)
),
(   'NC002',  -- SupplierID - char(5)
    N'CÔNG TY B', -- SupplierName - nvarchar(20)
    N'200 Nguyễn Văn Cừ', -- SupplierStreetAddress - nvarchar(30)
    N'TP Hồ Chí Minh', -- SupplierCity - nvarchar(20)
    N'abc', -- SupplierState - nvarchar(20)
    '123456'   -- SupplierZipCode - char(6)
),
(   'NC003',  -- SupplierID - char(5)
    N'CÔNG TY C', -- SupplierName - nvarchar(20)
    N'300 Nguyễn Văn Cừ', -- SupplierStreetAddress - nvarchar(30)
    N'TP Hồ Chí Minh', -- SupplierCity - nvarchar(20)
    N'abc', -- SupplierState - nvarchar(20)
    '123456'   -- SupplierZipCode - char(6)
)
GO

INSERT INTO dbo.Advertised_Item
(
    ItemNumber,
    ItemDescription,
    ItemDepartment,
    ItemWeight,
    ItemColor,
    ItemPrice,
    MinPriceSupplier,
    MinSuppliedPrice,
    TotalOrderedTime
)
VALUES
(   'SP0001',     -- ItemNumber - char(6)
    N'v.v',    -- ItemDescription - nvarchar(30)
    'v.v',     -- ItemDepartment - char(10)
    1.0,    -- ItemWeight - float
    'red',     -- ItemColor - char(10)
    10000,   -- ItemPrice - decimal(15, 2)
    'NC001',   -- MinPriceSupplier - char(5)
    NULL,   -- MinSuppliedPrice - decimal(15, 2)
    DEFAULT -- TotalOrderedTime - int
    ),
(   'SP0002',     -- ItemNumber - char(6)
    N'v.v',    -- ItemDescription - nvarchar(30)
    'v.v',     -- ItemDepartment - char(10)
    2.0,    -- ItemWeight - float
    'blue',     -- ItemColor - char(10)
    15000,   -- ItemPrice - decimal(15, 2)
    'NC002',   -- MinPriceSupplier - char(5)
    NULL,   -- MinSuppliedPrice - decimal(15, 2)
    DEFAULT -- TotalOrderedTime - int
    ),
(   'SP0003',     -- ItemNumber - char(6)
    N'v.v',    -- ItemDescription - nvarchar(30)
    'v.v',     -- ItemDepartment - char(10)
    1.0,    -- ItemWeight - float
    'black',     -- ItemColor - char(10)
    50000,   -- ItemPrice - decimal(15, 2)
    'NC003',   -- MinPriceSupplier - char(5)
    NULL,   -- MinSuppliedPrice - decimal(15, 2)
    DEFAULT -- TotalOrderedTime - int
    )
GO

INSERT INTO dbo.Customer
(
    CustomerIdentifier,
    CustomerTelephoneNumber,
    CustomerName,
    CustomerStreetAddress,
    CustomerCity,
    CustomerState,
    CustomerZipCode,
    CustomerCreditRating,
    CustomerTotalOrder
)
VALUES
(   'KH0001',      -- CustomerIdentifier - char(6)
    '0123456789',      -- CustomerTelephoneNumber - char(10)
    N'Nguyễn Văn A',     -- CustomerName - nvarchar(20)
    DEFAULT, -- CustomerStreetAddress - nvarchar(15)
    DEFAULT, -- CustomerCity - nvarchar(15)
    DEFAULT, -- CustomerState - nvarchar(15)
    DEFAULT, -- CustomerZipCode - char(6)
    DEFAULT, -- CustomerCreditRating - float
    DEFAULT  -- CustomerTotalOrder - int
    ),
(   'KH0002',      -- CustomerIdentifier - char(6)
    '035684952',      -- CustomerTelephoneNumber - char(10)
    N'Nguyễn Văn B',     -- CustomerName - nvarchar(20)
    DEFAULT, -- CustomerStreetAddress - nvarchar(15)
    DEFAULT, -- CustomerCity - nvarchar(15)
    DEFAULT, -- CustomerState - nvarchar(15)
    DEFAULT, -- CustomerZipCode - char(6)
    DEFAULT, -- CustomerCreditRating - float
    DEFAULT  -- CustomerTotalOrder - int
    ),
(   'KH0003',      -- CustomerIdentifier - char(6)
    '03568459',      -- CustomerTelephoneNumber - char(10)
    N'Nguyễn Văn C',     -- CustomerName - nvarchar(20)
    DEFAULT, -- CustomerStreetAddress - nvarchar(15)
    DEFAULT, -- CustomerCity - nvarchar(15)
    DEFAULT, -- CustomerState - nvarchar(15)
    DEFAULT, -- CustomerZipCode - char(6)
    DEFAULT, -- CustomerCreditRating - float
    DEFAULT  -- CustomerTotalOrder - int
    )

GO

INSERT INTO dbo.Credit_Card
(
    CustomerCreditCardNumber,
    CustomerIdentifier,
    CountOrder,
    CustomerCreditCardName,
    PreferredOption
)
VALUES
(   '12345678910',      -- CustomerCreditCardNumber - char(16)
    'KH0001',      -- CustomerIdentifier - char(6)
    DEFAULT, -- CountOrder - int
    N'Nguyễn Văn A',     -- CustomerCreditCardName - nvarchar(15)
    DEFAULT  -- PreferredOption - bit
    ),
(   '12345678911',      -- CustomerCreditCardNumber - char(16)
    'KH0001',      -- CustomerIdentifier - char(6)
    DEFAULT, -- CountOrder - int
    N'Nguyễn Văn A',     -- CustomerCreditCardName - nvarchar(15)
    DEFAULT  -- PreferredOption - bit
    ),
(   '22345678910',      -- CustomerCreditCardNumber - char(16)
    'KH0002',      -- CustomerIdentifier - char(6)
    DEFAULT, -- CountOrder - int
    N'Nguyễn Văn B',     -- CustomerCreditCardName - nvarchar(15)
    DEFAULT  -- PreferredOption - bit
    ),
(   '32345678910',      -- CustomerCreditCardNumber - char(16)
    'KH0003',      -- CustomerIdentifier - char(6)
    DEFAULT, -- CountOrder - int
    N'Nguyễn Văn C',     -- CustomerCreditCardName - nvarchar(15)
    DEFAULT  -- PreferredOption - bit
    )

GO

INSERT INTO dbo.Orders
(
    OrderNumber,
    CustomerIdentifer,
    OrderDate,
    ShippingStreetAddress,
    ShippingCity,
    ShippingState,
    ShippingZipCode,
    CustomerCreditCardNumber,
    ShippingDate,
    TotalPrice
)
VALUES
(   'OD000001',        -- OrderNumber - char(8)
    'KH0001',        -- CustomerIdentifer - char(6)
    DEFAULT,   -- OrderDate - datetime
    N'100 Nguyễn Văn Cừ',       -- ShippingStreetAddress - nvarchar(30)
    N' TP Hồ Chí Minh',       -- ShippingCity - nvarchar(20)
    0,      -- ShippingState - bit
    '123456',        -- ShippingZipCode - char(6)
    '12345678910',        -- CustomerCreditCardNumber - char(16)
    GETDATE(), -- ShippingDate - datetime
    DEFAULT    -- TotalPrice - decimal(15, 2)
    ),
(   'OD000002',        -- OrderNumber - char(8)
    'KH0001',        -- CustomerIdentifer - char(6)
    DEFAULT,   -- OrderDate - datetime
    N'100 Nguyễn Văn Cừ',       -- ShippingStreetAddress - nvarchar(30)
    N' TP Hồ Chí Minh',       -- ShippingCity - nvarchar(20)
    0,      -- ShippingState - bit
    '123456',        -- ShippingZipCode - char(6)
    '12345678911',        -- CustomerCreditCardNumber - char(16)
    GETDATE(), -- ShippingDate - datetime
    DEFAULT    -- TotalPrice - decimal(15, 2)
    ),
(   'OD000003',        -- OrderNumber - char(8)
    'KH0002',        -- CustomerIdentifer - char(6)
    DEFAULT,   -- OrderDate - datetime
    N'200 Nguyễn Văn Cừ',       -- ShippingStreetAddress - nvarchar(30)
    N' TP Hồ Chí Minh',       -- ShippingCity - nvarchar(20)
    0,      -- ShippingState - bit
    '123456',        -- ShippingZipCode - char(6)
    '12345678910',        -- CustomerCreditCardNumber - char(16)
    GETDATE(), -- ShippingDate - datetime
    DEFAULT    -- TotalPrice - decimal(15, 2)
    )

GO

INSERT INTO dbo.Ordered_Item
(
    ItemNumber,
    OrderNumber,
    QuantityOrdered,
    SellingPrice,
    ShippingDate,
    TotalPriceOrderedItem
)
VALUES
(   'SP0001',      -- ItemNumber - char(6)
    'OD000001',      -- OrderNumber - char(8)
    1,       -- QuantityOrdered - int
    10000,    -- SellingPrice - decimal(15, 2)
    DEFAULT, -- ShippingDate - datetime
    10000     -- TotalPriceOrderedItem - decimal(15, 2)
    ),
(   'SP0002',      -- ItemNumber - char(6)
    'OD000001',      -- OrderNumber - char(8)
    1,       -- QuantityOrdered - int
    15000,    -- SellingPrice - decimal(15, 2)
    DEFAULT, -- ShippingDate - datetime
    15000     -- TotalPriceOrderedItem - decimal(15, 2)
    ),
(   'SP0002',      -- ItemNumber - char(6)
    'OD000002',      -- OrderNumber - char(8)
    1,       -- QuantityOrdered - int
    15000,    -- SellingPrice - decimal(15, 2)
    DEFAULT, -- ShippingDate - datetime
    15000     -- TotalPriceOrderedItem - decimal(15, 2)
    ),
(   'SP0003',      -- ItemNumber - char(6)
    'OD000002',      -- OrderNumber - char(8)
    1,       -- QuantityOrdered - int
    50000,    -- SellingPrice - decimal(15, 2)
    DEFAULT, -- ShippingDate - datetime
    50000     -- TotalPriceOrderedItem - decimal(15, 2)
    ),
(   'SP0001',      -- ItemNumber - char(6)
    'OD000003',      -- OrderNumber - char(8)
    1,       -- QuantityOrdered - int
    10000,    -- SellingPrice - decimal(15, 2)
    DEFAULT, -- ShippingDate - datetime
    10000     -- TotalPriceOrderedItem - decimal(15, 2)
    ),
(   'SP0003',      -- ItemNumber - char(6)
    'OD000001',      -- OrderNumber - char(8)
    1,       -- QuantityOrdered - int
    15000,    -- SellingPrice - decimal(15, 2)
    DEFAULT, -- ShippingDate - datetime
    15000     -- TotalPriceOrderedItem - decimal(15, 2)
    )
GO

INSERT INTO dbo.Restock_Item
(
    ItemNumber,
    SupplierID,
    PurchasePrice
)
VALUES
(   'SP0001',  -- ItemNumber - char(6)
    'NC001',  -- SupplierID - char(5)
    10000 -- PurchasePrice - decimal(15, 2)
    ),
(   'SP0001',  -- ItemNumber - char(6)
    'NC002',  -- SupplierID - char(5)
    11000 -- PurchasePrice - decimal(15, 2)
    ),
(   'SP0002',  -- ItemNumber - char(6)
    'NC001',  -- SupplierID - char(5)
    18000 -- PurchasePrice - decimal(15, 2)
    ),
(   'SP0001',  -- ItemNumber - char(6)
    'NC003',  -- SupplierID - char(5)
    15000 -- PurchasePrice - decimal(15, 2)
    ),
(   'SP0003',  -- ItemNumber - char(6)
    'NC002',  -- SupplierID - char(5)
    50000 -- PurchasePrice - decimal(15, 2)
    ),
(   'SP0003',  -- ItemNumber - char(6)
    'NC003',  -- SupplierID - char(5)
    51000 -- PurchasePrice - decimal(15, 2)
    )