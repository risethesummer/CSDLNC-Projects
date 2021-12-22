
--------- UPDATE TOTAL PRICE OF ORDERS ------------
---------------------------------------------------
CREATE PROCEDURE UpdateTotalPriceOrders @OrderNumber CHAR(8)
AS
BEGIN
	DECLARE @TotalPrice DECIMAL(15,2);
	SET @TotalPrice = 0;
	IF (EXISTS (SELECT * 
				FROM dbo.Ordered_Item
				WHERE OrderNumber = @OrderNumber))
		BEGIN
			--Total price = sum of total price of detailed rows
			SET @TotalPrice = (SELECT SUM(Ordered_Item.TotalPriceOrderedItem)
							FROM Ordered_Item
							WHERE @OrderNumber = OrderNumber)
		END
	UPDATE dbo.Orders
	SET TotalPrice = @TotalPrice
 	WHERE OrderNumber = @OrderNumber;
END;
GO


----------- INSERT ORDERED_ITEM -----------
-------------------------------------------
CREATE TRIGGER TRG_Ordered_Item_Insert
ON dbo.Ordered_Item
INSTEAD OF INSERT AS
BEGIN
	BEGIN TRY
		--Store some variables to quickly use
		DECLARE @OrderNumber CHAR(8), @ItemNumber CHAR(6), @SellingPrice DECIMAL(15,2), @QuantityOrdered INT;
		--Use cursor to loop through the inserted table
		DECLARE AddOrderedItemCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
			FOR SELECT OrderNumber, ItemNumber, SellingPrice, QuantityOrdered FROM inserted;

		--Open the cursor to fetch data
		OPEN AddOrderedItemCursor;
		FETCH NEXT FROM AddOrderedItemCursor INTO @OrderNumber, @ItemNumber, @SellingPrice, @QuantityOrdered;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (@SellingPrice IS NULL)
			BEGIN
				SET @SellingPrice = (SELECT TOP 1 ItemPrice
									FROM Advertised_Item
									WHERE ItemNumber = @ItemNumber);
			END
			
			--Insert new Ordered_Item
			INSERT INTO Ordered_Item (OrderNumber, ItemNumber, SellingPrice, QuantityOrdered, TotalPriceOrderedItem)
			VALUES (@OrderNumber, @ItemNumber, @SellingPrice, @QuantityOrdered, @QuantityOrdered * @SellingPrice);

			--Update TotalPrice of the ORDERS
			EXEC UpdateTotalPriceOrders @OrderNumber;

			--Read the next row
			FETCH NEXT FROM AddOrderedItemCursor INTO @OrderNumber, @ItemNumber, @SellingPrice, @QuantityOrdered;
		END
		--Close and deallocate the resource for the cursor
		CLOSE AddOrderedItemCursor;
		DEALLOCATE AddOrderedItemCursor;
	END TRY
	BEGIN CATCH
		--The trigger drops here that means the steps above the closing cursor step have not done
		--so, we need to close the cursor
		IF CURSOR_STATUS('local', 'AddOrderedItemCursor') >= 0 --Check to make sure the cursor has not been closed
			BEGIN
				CLOSE AddOrderedItemCursor;
				DEALLOCATE AddOrderedItemCursor;
			END
		RAISERROR('Could not insert new Ordered_Item', 16, 1);
		ROLLBACK TRANSACTION;
	END CATCH;	
END;
GO

----------- UPDATE ORDERED_ITEM -----------
-------------------------------------------
CREATE TRIGGER TRG_Ordered_Item_Update
ON Ordered_Item
INSTEAD OF UPDATE
AS
BEGIN
	BEGIN TRY		
		--Store some variables to quickly use
		DECLARE @OrderNumber CHAR(8), @ItemNumber CHAR(6), @SellingPrice DECIMAL(15,2),  @QuantityOrdered INT;
		--Use cursor to loop through the inserted table
		DECLARE UpdateOrderedItemCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
			FOR SELECT OrderNumber, ItemNumber, SellingPrice, QuantityOrdered FROM inserted;

		OPEN UpdateOrderedItemCursor;
		FETCH NEXT FROM UpdateOrderedItemCursor INTO @OrderNumber, @ItemNumber, @SellingPrice, @QuantityOrdered;

		--The inserted table can have multiple rows of data
		--Use cursor to loop through all of them
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			--The sell price is null
			IF @SellingPrice IS NULL
				BEGIN
					CLOSE UpdateOrderedItemCursor;
					DEALLOCATE UpdateOrderedItemCursor;
					RAISERROR('The price is null or the Order does not exist', 16, 1);
					ROLLBACK TRANSACTION;
				END

			UPDATE Ordered_Item -- OrderNumber, ItemNumber are primary keys, so we can not update
			SET 
				QuantityOrdered = @QuantityOrdered, 
				SellingPrice = @SellingPrice,
				TotalPriceOrderedItem = @SellingPrice * @QuantityOrdered
			WHERE Ordered_Item.OrderNumber = @OrderNumber AND Ordered_Item.ItemNumber = @ItemNumber

			--Update TotalPrice of the Order
			EXEC UpdateTotalPriceOrders @OrderNumber;

			--Read the next row
			FETCH NEXT FROM UpdateOrderedItemCursor INTO @OrderNumber, @ItemNumber, @SellingPrice, @QuantityOrdered;
		END
		--Close and deallocate the resource for the cursor
		CLOSE UpdateOrderedItemCursor;
		DEALLOCATE UpdateOrderedItemCursor;
	END TRY
	BEGIN CATCH
		--The trigger drops here that means the steps above the closing cursor step have not done
		--so, we need to close the cursor
		IF CURSOR_STATUS('local', 'UpdateOrderedItemCursor') >= 0 --Check to make sure the cursor has not been closed
			BEGIN
				CLOSE UpdateOrderedItemCursor;
				DEALLOCATE UpdateOrderedItemCursor;
			END
		RAISERROR('Could not update the Ordered_Item', 16, 1);
		ROLLBACK TRANSACTION;
	END CATCH;	
END;
GO

----------- DELETE ORDERED_ITEM -----------
-------------------------------------------
CREATE TRIGGER TRG_Ordered_Item_Delete
ON Ordered_Item
AFTER DELETE
AS
BEGIN

	DECLARE @OrderNumber CHAR(8);
	--Use cursor to loop through the deleted table
	DECLARE DeleteOrderedItemCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
		FOR SELECT OrderNumber FROM inserted;

	OPEN DeleteOrderedItemCursor;
	FETCH NEXT FROM DeleteOrderedItemCursor INTO @OrderNumber;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC UpdateTotalPriceOrders @OrderNumber;
		FETCH NEXT FROM DeleteOrderedItemCursor INTO @OrderNumber;
	END
	CLOSE DeleteOrderedItemCursor;
	DEALLOCATE DeleteOrderedItemCursor;
END;
GO