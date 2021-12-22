USE ORDER_ENTRY
GO

CREATE TYPE PRODUCT_QUANTITY AS TABLE
(
	ITEM_NUMBER CHAR(6),
	QUANTITY INT
);
GO


CREATE PROCEDURE CreateOrder @OrderNumber CHAR(8),@CustomerIdentifer CHAR(6),@OrderDate DATETIME,@ShippingStreetAddress nvarchar(30),@ShippingCity nvarchar(20),
							 @ShippingState bit, @ShippingZipCode char(6), @CustomerCreditCardNumber char(16), @TotalPrice decimal(15, 2), @PRODUCT_QUANTITY PRODUCT_QUANTITY READONLY,
							 @CustomerCreditCardName nvarchar(15)
AS 
BEGIN
	--TINH TOTAL PRICE
	SET @TotalPrice = (SELECT SUM(PQ.QUANTITY * AI.ItemPrice)
						FROM Advertised_Item AI JOIN  @PRODUCT_QUANTITY PQ ON AI.ItemNumber = PQ.ITEM_NUMBER)
	--TAO DON HANG
	INSERT INTO Orders(OrderNumber,CustomerIdentifer,OrderDate,ShippingStreetAddress,ShippingCity,ShippingState,ShippingZipCode,CustomerCreditCardNumber,TotalPrice)
	VALUES(@OrderNumber,@CustomerIdentifer,@OrderDate,@ShippingStreetAddress,@ShippingCity, @ShippingState,@ShippingZipCode,@CustomerCreditCardNumber,
			@TotalPrice)

	--TAO CHI TIET DON HANG
	INSERT INTO Ordered_Item(ItemNumber,OrderNumber,QuantityOrdered,SellingPrice,TotalPriceOrderedItem)
	SELECT PQ.ITEM_NUMBER,@OrderNumber,PQ.QUANTITY,AI.ItemPrice, PQ.QUANTITY*AI.ItemPrice
	FROM @PRODUCT_QUANTITY PQ JOIN Advertised_Item AI ON PQ.ITEM_NUMBER = AI.ItemNumber

	--UPDATE SO LAN DAT HANG CUA KHACH HANG
	UPDATE Customer
	SET CustomerTotalOrder = CustomerTotalOrder + 1
	WHERE CustomerIdentifier = @CustomerIdentifer

	--UPDATE SO LAN DAT CUA SAN PHAM
	UPDATE Advertised_Item
	SET TotalOrderedTime = TotalOrderedTime + 1
	WHERE EXISTS(SELECT PQ.ITEM_NUMBER
				FROM @PRODUCT_QUANTITY PQ
				WHERE PQ.ITEM_NUMBER = ItemNumber)
	--NEU KHACH HANG CHUA CO CREDIT CARD NUMBER THI INSERT BO SUNG
	IF NOT EXISTS(SELECT CustomerCreditCardNumber
					FROM Credit_Card 
					WHERE Credit_Card.CustomerCreditCardNumber = @CustomerCreditCardNumber)
					BEGIN
						INSERT INTO Credit_Card(CustomerCreditCardNumber,CustomerCreditCardName,CustomerIdentifier)
						VALUES(@CustomerCreditCardNumber,@CustomerCreditCardName,@CustomerIdentifer)

					END
	--UPDATE COUNT ORDER
	ELSE
	BEGIN
		UPDATE Credit_Card
		SET CountOrder = CountOrder + 1
		WHERE CustomerIdentifier = @CustomerIdentifer
	END
END