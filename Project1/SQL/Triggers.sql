USE cua_hang;
GO
DROP TRIGGER TRG_HDCT_HoaDonChiTiet_InsteadOfInsert, TRG_HDCT_HoaDonChiTiet_InsteadOfUpdate, TRG_HDCT_HoaDonChiTiet_InsteadOfDelete
GO

--------------------------------------------------------
-- a. Thanh tien CTHD= (So luong * (Gia ban-Gia giam)) #
-- b. Tong tien (mahd) = sum(ThanhTien)cthd(mahd)      #
--------------------------------------------------------

------------------------- INSERT -------------------------
----------------------------------------------------------
CREATE TRIGGER TRG_HDCT_HoaDonChiTiet_InsteadOfInsert
ON HoaDonChiTiet
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO HoaDonChiTiet(MaHD, MaSP, SoLuong, GiaBan, GiaGiam, ThanhTien)
	SELECT MaHD, MaSP, SoLuong, SP.Gia, GiaGiam, (SP.Gia - GiaGiam) * SoLuong
	From inserted INNER JOIN SanPham SP ON inserted.MaSP = SP.Ma

	UPDATE HoaDon
		SET TongTien += SUM_INSERTED.SUM_THANHTIEN
		FROM (
			SELECT MaHD, SUM((SP.Gia - GiaGiam) * SoLuong) as SUM_THANHTIEN
			FROM INSERTED INNER JOIN SanPham SP ON inserted.MaSP = SP.Ma
			GROUP BY MaHD
		) SUM_INSERTED
		WHERE HoaDon.Ma = SUM_INSERTED.MaHD;
END

------------------------- UPDATE -------------------------
----------------------------------------------------------
GO
CREATE TRIGGER TRG_HDCT_HoaDonChiTiet_InsteadOfUpdate
ON HoaDonChiTiet
INSTEAD OF UPDATE
AS
BEGIN
	UPDATE HoaDonChiTiet -- MaHD, MaSP is key so we can not update
	SET SoLuong = INSERTED.SoLuong, 
	GiaBan = SP.Gia,
	GiaGiam = INSERTED.GiaGiam,
	ThanhTien = (SP.Gia - INSERTED.GiaGiam) * INSERTED.SoLuong
	FROM INSERTED INNER JOIN SanPham SP ON SP.Ma = INSERTED.MaSP
	WHERE HoaDonChiTiet.MaHD = INSERTED.MaHD AND HoaDonChiTiet.MaSP = INSERTED.MaSP

	UPDATE HoaDon
	SET TongTien = TongTien - SUM_UPDATED.SUM_THANHTIEN_BOT + SUM_UPDATED.SUM_THANHTIEN_THEM  
	FROM ( -- For an UPDATE, Inserted contains the new values (after the update) while Deleted contains the old values before the update. 
		SELECT 
			INSERTED.MaHD,
			SUM((SP.Gia - INSERTED.GiaGiam) * INSERTED.SoLuong) AS SUM_THANHTIEN_THEM,
			SUM((SP.Gia - DELETED.GiaGiam) * DELETED.SoLuong) AS SUM_THANHTIEN_BOT
		FROM INSERTED
			INNER JOIN DELETED ON INSERTED.MaHD = DELETED.MaHD AND INSERTED.MaSP = DELETED.MaSP
			INNER JOIN SanPham SP ON inserted.MaSP = SP.Ma
		GROUP BY INSERTED.MaHD
	) SUM_UPDATED
	WHERE HoaDon.Ma = SUM_UPDATED.MaHD;
END

------------------------- DELETE -------------------------
----------------------------------------------------------
GO
CREATE TRIGGER TRG_HDCT_HoaDonChiTiet_InsteadOfDelete
ON HoaDonChiTiet
INSTEAD OF DELETE
AS
BEGIN
	DELETE HoaDonChiTiet
	FROM DELETED
	WHERE HoaDonChiTiet.MaHD = DELETED.MaHD AND HoaDonChiTiet.MaSP = DELETED.MaSP

	UPDATE HoaDon
	SET HoaDon.TongTien -= SUM_DELETED.SUM_THANHTIEN
	FROM (
		SELECT DELETED.MaHD, SUM(DELETED.ThanhTien) AS SUM_THANHTIEN
		FROM DELETED
		GROUP BY DELETED.MaHD
	) SUM_DELETED
	WHERE HoaDon.Ma = SUM_DELETED.MaHD;
END