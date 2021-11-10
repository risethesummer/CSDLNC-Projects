USE cua_hang;
GO

----------------------------------------------------------
---------UPDATE DETAILED BILL STORED PROCEDURE------------
----------------------------------------------------------
--Update current total price for a bill by its detailed rows
CREATE PROCEDURE UpdateTotalPriceBill @MaHD CHAR(8)
AS
BEGIN
	DECLARE @TongTien INT;
	--Prices of detailed bill rows
	--Default is 0 if there is no detailed bill row
	SET @TongTien = 0;
	IF (EXISTS (SELECT * 
				FROM CT_HoaDon
				WHERE CT_HoaDon.MaHD = @MaHD))
		BEGIN
			--Total price = sum of total price of detailed rows
			SET @TongTien = (SELECT SUM(CT_HoaDon.ThanhTien)
							FROM CT_HoaDon
							WHERE @MaHD = CT_HoaDon.MaHD)
		END
	UPDATE HoaDon
	SET TongTien = @TongTien
 	WHERE HoaDon.MaHD = @MaHD;
END
GO

----------------------------------------------------------
------------------------- INSERT DETAILED BILL------------
----------------------------------------------------------
--Trigger instead of inserting a new detailed bill
CREATE TRIGGER TRG_HDCT_InsteadOfInserting
ON CT_HoaDon
INSTEAD OF INSERT
AS
BEGIN
	BEGIN TRY
		--Store some variables to quickly use
		DECLARE @MaHD CHAR(8), @MaSP CHAR(7), @GiaBan INT, @GiaGiam INT,  @SoLuong INT;
		--Use cursor to loop through the inserted table
		DECLARE AddBillDetailedCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
			FOR SELECT MaHD, MaSP, GiaBan, GiaGiam, SoLuong FROM inserted;

		--Open the cursor to fetch data
		OPEN AddBillDetailedCursor;
		FETCH NEXT FROM AddBillDetailedCursor INTO @MaHD, @MaSP, @GiaBan, @GiaGiam, @SoLuong;
		
		--The inserted table can have multiple rows of data
		--Use cursor to loop through all of them
		WHILE @@FETCH_STATUS = 0
		BEGIN

			--If the user wants use another price instead of the product price on the system
			--Otherwise, set the price to the price on the system
			IF (@GiaBan IS NULL)
			BEGIN
				SET @GiaBan = (SELECT TOP 1 SP.Gia
								FROM SanPham SP
								WHERE SP.MaSP = @MaSP);
			END

			--If the discount is greater than the sell price -> set it to the sell price
			IF (@GiaGiam > @GiaBan)
			BEGIN
				SET @GiaGiam = @GiaBan;
			END
			
			--Insert new detailed bill
			INSERT INTO CT_HoaDon(MaHD, MaSP, SoLuong, GiaBan, GiaGiam, ThanhTien)
			VALUES (@MaHD, @MaSP, @SoLuong, @GiaBan, @GiaGiam, @SoLuong * (@GiaBan - @GiaGiam));

			--Update total price of the bill
			EXEC UpdateTotalPriceBill @MaHD;

			--Read the next row
			FETCH NEXT FROM AddBillDetailedCursor INTO @MaHD, @MaSP, @GiaBan, @GiaGiam, @SoLuong;
		END
		--Close and deallocate the resource for the cursor
		CLOSE AddBillDetailedCursor;
		DEALLOCATE AddBillDetailedCursor;
	END TRY
	BEGIN CATCH
		--The trigger drops here that means the steps above the closing cursor step have not done
		--so, we need to close the cursor
		IF CURSOR_STATUS('local', 'AddBillDetailedCursor') >= 0 --Check to make sure the cursor has not been closed
			BEGIN
				CLOSE AddBillDetailedCursor;
				DEALLOCATE AddBillDetailedCursor;
			END
		RAISERROR('Could not insert new bill detailed', 16, 1);
		ROLLBACK TRANSACTION;
	END CATCH;	
END

----------------------------------------------------------
------------------------- UPDATE DETAILED BILL------------
----------------------------------------------------------
--Trigger instead of updating a new detailed bill
CREATE TRIGGER TRG_HDCT_InsteadOfUpdating
ON CT_HoaDon
INSTEAD OF UPDATE
AS
BEGIN
	BEGIN TRY		
		--Store some variables to quickly use
		DECLARE @MaHD CHAR(8), @MaSP CHAR(7), @GiaBan INT, @GiaGiam INT,  @SoLuong INT;
		--Use cursor to loop through the inserted table
		DECLARE UpdateBillDetailedCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
			FOR SELECT MaHD, MaSP, GiaBan, GiaGiam, SoLuong FROM inserted;

		OPEN UpdateBillDetailedCursor;
		FETCH NEXT FROM UpdateBillDetailedCursor INTO @MaHD, @MaSP, @GiaBan, @GiaGiam, @SoLuong;

		--The inserted table can have multiple rows of data
		--Use cursor to loop through all of them
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			--The sell price is null
			IF @GiaBan IS NULL
				BEGIN
					CLOSE UpdateBillDetailedCursor;
					DEALLOCATE UpdateBillDetailedCursor;
					RAISERROR('The price is null or the bill does not exist', 16, 1);
					ROLLBACK TRANSACTION;
				END

			UPDATE CT_HoaDon -- MaHD, MaSP are primary keys, so we can not update
			SET 
				SoLuong = @SoLuong, 
				GiaBan = @GiaBan,
				GiaGiam = @GiaGiam,
				ThanhTien = (@GiaBan - @GiaGiam) * @SoLuong
			WHERE CT_HoaDon.MaHD = @MaHD AND CT_HoaDon.MaSP = @MaSP

			--Update total price of the bill
			EXEC UpdateTotalPriceBill @MaHD;

			--Read the next row
			FETCH NEXT FROM UpdateBillDetailedCursor INTO @MaHD, @MaSP, @GiaBan, @GiaGiam, @SoLuong;
		END
		--Close and deallocate the resource for the cursor
		CLOSE UpdateBillDetailedCursor;
		DEALLOCATE UpdateBillDetailedCursor;
	END TRY
	BEGIN CATCH
		--The trigger drops here that means the steps above the closing cursor step have not done
		--so, we need to close the cursor
		IF CURSOR_STATUS('local', 'UpdateBillDetailedCursor') >= 0 --Check to make sure the cursor has not been closed
			BEGIN
				CLOSE UpdateBillDetailedCursor;
				DEALLOCATE UpdateBillDetailedCursor;
			END
		RAISERROR('Could not update the bill detailed', 16, 1);
		ROLLBACK TRANSACTION;
	END CATCH;	
END
GO

----------------------------------------------------------
------------------------- DELETE DETAILED BILL------------
----------------------------------------------------------
--Trigger after deleting a new detailed bill
CREATE TRIGGER TRG_HDCT_AfterDeleting
ON CT_HoaDon
AFTER DELETE
AS
BEGIN

	DECLARE @MaHD CHAR(8);
	--Use cursor to loop through the deleted table
	DECLARE DeleteBillDetailedCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
		FOR SELECT MaHD FROM inserted;

	OPEN DeleteBillDetailedCursor;
	FETCH NEXT FROM DeleteBillDetailedCursor INTO @MaHD;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--If there is no remaining bill detailed of the bill -> delete the bill
		IF NOT EXISTS (SELECT * 
						FROM CT_HoaDon
						WHERE CT_HoaDon.MaHD = @MaHD)
			BEGIN
				DELETE FROM HoaDon
				WHERE HoaDon.MaHD = @MaHD;
			END
		--If the bill still has bill detailed -> update total price
		ELSE
			BEGIN
				EXEC UpdateTotalPriceBill @MaHD;
			END
		--Fetch next row
		FETCH NEXT FROM DeleteBillDetailedCursor INTO @MaHD;
	END
	CLOSE DeleteBillDetailedCursor;
	DEALLOCATE DeleteBillDetailedCursor;
END
GO

----------------------------------------------------------
------------------------- INSERT BILL---------------------
----------------------------------------------------------
--Trigger checking the total price after inserting the bill
CREATE TRIGGER TRG_HD_AfterInserting
ON HoaDon
AFTER INSERT
AS
BEGIN
	DECLARE @MaHD CHAR(8);

	DECLARE AddBillCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
		FOR SELECT MaHD FROM inserted;

	OPEN AddBillCursor;
	FETCH NEXT FROM AddBillCursor INTO @MaHD;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Update total price if inserting a ridiculous value
		EXEC UpdateTotalPriceBill @MaHD;
		FETCH NEXT FROM AddBillCursor INTO @MaHD;
	END
	CLOSE AddBillCursor;
	DEALLOCATE AddBillCursor;
END
GO

----------------------------------------------------------
------------------------- UPDATE BILL---------------------
----------------------------------------------------------
--Trigger checking the total price after updating the bill
CREATE TRIGGER TRG_HD_AfterUpdating
ON HoaDon
AFTER UPDATE
AS
BEGIN
	DECLARE @MaHD CHAR(8), @TongTien INT;
	DECLARE UpdateBillCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
		FOR SELECT MaHD, TongTien FROM inserted;

	OPEN UpdateBillCursor;
	FETCH NEXT FROM UpdateBillCursor INTO @MaHD, @TongTien;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--If the total is not equal to the sum price of detailed rows
		IF @TongTien != (SELECT SUM(HDCT.ThanhTien)
							FROM CT_HoaDon HDCT
							WHERE HDCT.MaHD = @MaHD)
		BEGIN
			RAISERROR('Could not update the bill', 16, 1);
			ROLLBACK TRANSACTION;
		END
		FETCH NEXT FROM UpdateBillCursor INTO @MaHD, @TongTien;
	END
	CLOSE UpdateBillCursor;
	DEALLOCATE UpdateBillCursor;
END