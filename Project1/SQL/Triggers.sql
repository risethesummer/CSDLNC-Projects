CREATE TRIGGER TRG_HDCT_GiaBan_InsteadOfInsert
ON HoaDonChiTiet
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO HoaDonChiTiet(MaHD, MaSP, SoLuong, GiaBan, GiaGiam, ThanhTien)
	SELECT MaHD, MaSP, SoLuong, SP.Gia, GiaGiam, (SP.Gia - GiaGiam) * SoLuong
	From inserted INNER JOIN SanPham SP
		ON inserted.MaSP = SP.Ma
	
	UPDATE HoaDon
	SET TongTien = (SELECT SUM(HDCT.ThanhTien)
					FROM HoaDonChiTiet HDCT
					WHERE Ma = HDCT.MaHD)
	WHERE Ma = (SELECT TOP 1 i.MaHD
				FROM inserted i)
END

CREATE TRIGGER TRG_HDCT_GiaBan_GiaGiam_AfterInsertUpdate
ON HoaDonChiTiet
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT * 
				FROM inserted i
				WHERE i.ThanhTien < 0)
		BEGIN
			ROLLBACK TRANSACTION
		END
END