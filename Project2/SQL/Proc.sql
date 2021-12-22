USE shop_db;
GO

CREATE PROC them_san_pham_vao_gio_hang @ma_kh INT, @ma_sp INT, @so_luong_them INT
AS
BEGIN TRANSACTION
BEGIN TRY
	DECLARE @so_luong_hien_tai INT;
	SET @so_luong_hien_tai = (SELECT SoLuongGioHang
								FROM GIO_HANG gh
								WHERE gh.MaKH = @ma_kh AND gh.MaSP = @ma_sp);
	IF @so_luong_hien_tai IS NULL
		BEGIN
			INSERT INTO GIO_HANG(MaKH, MaSP, SoLuongGioHang)
			VALUES (@ma_kh, @ma_sp, @so_luong_them);
		END
	ELSE
		BEGIN
			DECLARE @so_luong_moi INT;
			SET @so_luong_moi = @so_luong_hien_tai + @so_luong_them;
			IF @so_luong_moi <= 0
				BEGIN
					DELETE FROM GIO_HANG
					WHERE MaKH = @ma_kh AND MaSP = @ma_sp;
				END
			ELSE
				BEGIN
					UPDATE GIO_HANG
					SET SoLuongGioHang += @so_luong_them
					WHERE MaKH = @ma_kh AND MaSP = @ma_sp;
				END
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
END CATCH
GO

CREATE PROC tao_don_hang @ma_kh INT
AS 
BEGIN TRANSACTION
BEGIN TRY
	DECLARE @tong_gia DECIMAL, @ma_dh INT;
	SET @tong_gia = (SELECT SUM(gh.SoLuongGioHang * sp.GiaSP)
					FROM GIO_HANG gh
						JOIN SAN_PHAM sp ON gh.MaSP = sp.MaSP
					WHERE gh.MaKH = @ma_kh);
	INSERT INTO DON_HANG(MaKH, TongGiaDH) VALUES (@ma_kh, @tong_gia);
	SET @ma_dh = (SELECT TOP 1 MaDH FROM DON_HANG ORDER BY MaDH DESC);

	INSERT INTO CHI_TIET_DON_HANG(MaDH, MaSP, SoLuongDH, DonGiaDH)
	SELECT @ma_dh, gh.MaSP, gh.SoLuongGioHang, sp.GiaSP
	FROM GIO_HANG gh
		JOIN SAN_PHAM sp ON gh.MaSP = sp.MaSP
	WHERE gh.MaKH = @ma_kh;

	DELETE FROM GIO_HANG
	WHERE MaKH = @ma_kh;

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
END CATCH
GO

CREATE PROC tao_tai_khoan @tai_khoan VARCHAR(20), @mat_khau BINARY(16), 
						@ho_ten NVARCHAR(30), @dia_chi NVARCHAR(30),
						@sdt VARCHAR(10), @email VARCHAR(30),
						@ng_sinh DATE
AS
BEGIN TRANSACTION
BEGIN TRY
	INSERT INTO TAI_KHOAN(TaiKhoan, MatKhau, LoaiTK)
	VALUES (@tai_khoan, @mat_khau, 'KH');

	INSERT INTO KHACH_HANG(TaiKhoan, HoTenKH, DiaChiKH, SDT_KH, EmailKH, NgaySinhKH)
	VALUES (@tai_khoan, @ho_ten, @dia_chi, @sdt, @email, @ng_sinh);

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
END CATCH
GO

CREATE PROC thanh_toan_don_hang_atm @ma_dh INT, @so_tk CHAR(10), @ten_tk NVARCHAR(30), @ngan_hang NVARCHAR(30)
AS
BEGIN TRANSACTION
BEGIN TRY
	DECLARE @ma_kh INT;
	SET @ma_kh = (SELECT TOP 1 MaKH FROM DON_HANG dh WHERE dh.MaDH = @ma_dh AND dh.TrangThaiDH = N'Đang xử lý');
	
	IF @ma_kh IS NULL
		BEGIN
			ROLLBACK TRANSACTION;
			RETURN;
		END

	IF NOT EXISTS (SELECT STK
					FROM THE_ATM
					WHERE STK = @so_tk)
		BEGIN
			INSERT INTO THE_ATM(MaKH, STK, TenChuKhoan, NganHang)
			VALUES (@ma_kh, @so_tk, @ten_tk, @ngan_hang);
		END
	
	INSERT INTO THANH_TOAN_ATM(MaDH, STK)
	VALUES (@ma_dh, @so_tk);

	UPDATE DON_HANG
	SET TrangThaiDH = N'Đã thanh toán'
	WHERE MaDH = @ma_dh;

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
END CATCH
GO

CREATE PROC thanh_toan_don_hang_tien_mat @ma_dh INT, @cash DECIMAL(15, 2)
AS
BEGIN TRANSACTION
BEGIN TRY
	DECLARE @tong_tien DECIMAL(15, 2);
	SET @tong_tien = (SELECT TOP 1 TongGiaDH FROM DON_HANG dh WHERE dh.MaDH = @ma_dh AND dh.TrangThaiDH = N'Đang xử lý');
	
	IF @tong_tien IS NULL
		BEGIN
			ROLLBACK TRANSACTION;
			RETURN;
		END

	INSERT INTO THANH_TOAN_TIEN_MAT(MaDH, SoTienTraLai)
	VALUES (@ma_dh, @cash - @tong_tien);

	UPDATE KHACH_HANG
	SET SoTienDaDung += @tong_tien, DiemTichLuy += (@tong_tien / 10);

	UPDATE DON_HANG
	SET TrangThaiDH = N'Đã thanh toán'
	WHERE MaDH = @ma_dh;

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
END CATCH
GO

CREATE PROC xem_don_hang_da_thanh_toan @ma_kh INT
AS 
BEGIN
	SELECT dh.MaDH, dh.NgayLapDH, dh.TrangThaiDH, dh.TongGiaDH, tt_atm.ThoiGianTT_ATM, atm.STK, atm.TenChuKhoan, atm.NganHang
	FROM DON_HANG dh 
		JOIN THANH_TOAN_ATM tt_atm ON dh.MaDH = tt_atm.MaDH
		JOIN THE_ATM atm ON tt_atm.STK = atm.STK
	WHERE dh.MaKH = @ma_kh

	SELECT dh.MaDH, dh.NgayLapDH, dh.TrangThaiDH, dh.TongGiaDH, tt.ThoiGianTT_TM, tt.SoTienTraLai
	FROM DON_HANG dh 
		JOIN THANH_TOAN_TIEN_MAT tt ON dh.MaDH = tt.MaDH
	WHERE dh.MaKH = @ma_kh
	RETURN;
END