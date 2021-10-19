CREATE TRIGGER TRG_HDCT_GiaBan_InsteadOfInsert
ON HoaDonChiTiet
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO HoaDonChiTiet(MaHD, MaSP, SoLuong, GiaBan, GiaGiam, ThanhTien)
	SELECT MaHD, MaSP, SoLuong, SP.Gia, GiaGiam, (SP.Gia - GiaGiam) * SoLuong
	From INSERTED INNER JOIN SanPham SP
		ON INSERTED.MaSP = SP.Ma
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