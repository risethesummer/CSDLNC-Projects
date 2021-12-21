USE BTVatLy;
GO

CREATE TRIGGER instead_of_insert_restock_item
ON Restock_Item
INSTEAD OF INSERT
AS
BEGIN
    -- add restock item into physical
    INSERT INTO Restock_Item(ItemNumber,SupplierID,PurchasePrice)
    SELECT inserted.ItemNumber,inserted.SupplierID,inserted.PurchasePrice
    FROM inserted

    -- change min-price when items have lower minPrice or null minPrice
    UPDATE AI 
    SET AI.MinSuppliedPrice = inserted.PurchasePrice,
    AI.MinPriceSupplier = inserted.SupplierID
    FROM Advertised_Item AI 
    INNER JOIN inserted ON inserted.ItemNumber = AI.ItemNumber
    WHERE AI.MinSuppliedPrice IS NULL  
    OR inserted.PurchasePrice < AI.MinPriceSupplier
END
GO

CREATE TRIGGER instead_of_delete_restock_item
ON Restock_Item
INSTEAD OF DELETE
AS
BEGIN
    DELETE Restock_Item
    FROM Restock_Item INNER JOIN deleted 
    ON deleted.SupplierID = Restock_Item.SupplierID 
    AND deleted.ItemNumber = Restock_Item.ItemNumber 

    UPDATE AI 
    SET AI.MinSuppliedPrice = RI.PurchasePrice,
    AI.MinPriceSupplier = RI.SupplierID
    FROM Advertised_Item AI 
    INNER JOIN deleted ON deleted.ItemNumber = AI.ItemNumber
    INNER JOIN (
        SELECT RI.*
        FROM Restock_Item RI
        WHERE NOT EXISTS (
            SELECT 1
            FROM Restock_Item
            WHERE Restock_Item.PurchasePrice < RI.PurchasePrice
            AND Restock_Item.ItemNumber = RI.ItemNumber
            AND Restock_Item.SupplierID != RI.SupplierID
        )
    ) RI ON RI.ItemNumber = AI.ItemNumber
END
GO

CREATE TRIGGER instead_of_update_restock_item
ON Restock_Item
INSTEAD OF UPDATE
AS
BEGIN
    UPDATE RI
    SET RI.PurchasePrice = inserted.PurchasePrice
    FROM Restock_Item RI
    INNER JOIN inserted
    ON inserted.SupplierID = RI.SupplierID 
    AND inserted.ItemNumber = RI.ItemNumber

    -- change min-price when items have lower minPrice or null minPrice
    UPDATE AI 
    SET AI.MinSuppliedPrice = inserted.PurchasePrice,
    AI.MinPriceSupplier = inserted.SupplierID
    FROM Advertised_Item AI 
    INNER JOIN inserted ON inserted.ItemNumber = AI.ItemNumber
    WHERE AI.MinSuppliedPrice IS NULL  
    OR inserted.PurchasePrice < AI.MinPriceSupplier
END
