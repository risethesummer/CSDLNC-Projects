CREATE TYPE PRODUCT_QUANTITY AS TABLE
(
	ITEM_NUMBER CHAR(6),
	QUANTITY INT
);
GO


CREATE PROCEDURE CreateOrder @OrderNumber CHAR(8),@CustomerIdentifer CHAR(6),@OrderDate DATETIME,@ShippingStreetAddress nvarchar(30),@ShippingCity nvarchar(20),
							 @ShippingState bit, @ShippingZipCode char(6), @CustomerCreditCardNumber char(16), @TotalPrice decimal(15, 2), @PRODUCT_QUANTITY PRODUCT_QUANTITY READONLY
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
	SET CustomerTotalOrder = CustomerTotalOrder+1
END