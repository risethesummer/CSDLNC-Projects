CREATE TYPE PRODUCT_QUANTITY AS TABLE
(
	ITEM_NUMBER CHAR(6),
	QUANTITY INT
);
GO


CREATE PROCEDURE DeleteOrder @OrderNumber CHAR(8)
AS 
BEGIN
	UPDATE Customer
	SET CustomerTotalOrder -= 1
	WHERE EXISTS (SELECT cs.CustomerIdentifier 
					FROM Customer cs 
						JOIN Orders od ON cs.CustomerIdentifier = od.CustomerIdentifer
					WHERE od.OrderNumber = @OrderNumber);  

	UPDATE Advertised_Item
	SET TotalOrderedTime -= 1
	WHERE EXISTS (SELECT od.ItemNumber
					FROM Ordered_Item od
					WHERE od.OrderNumber = @OrderNumber AND od.ItemNumber = Advertised_Item.ItemNumber);

	DECLARE @credit_number CHAR(16);
	SET @credit_number = (SELECT TOP 1 od.CustomerCreditCardNumber
							FROM Orders od
							WHERE od.OrderNumber = @OrderNumber) 


END



	