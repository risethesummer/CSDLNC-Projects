--Cho danh sach cac hoa don lap trong nam 2020
USE cua_hang

SELECT HD.* --AS N'DANH SÁCH CÁC HÓA ĐƠN LẬP TRONG NĂM 2020' 
FROM HoaDon HD
WHERE DATEPART(YEAR,HD.NgayLap) = 2020
GO

--Cho danh sach cac khach hang	 o TPHCM
SELECT KH.* --AS N'DANH SÁCH CÁC KHÁCH HÀNG Ở TP HCM'
FROM KhachHang KH
WHERE KH.ThanhPho LIKE N'%Hồ Chí Minh' --For case: TP Hồ Chí Minh
		OR KH.ThanhPho LIKE N'%HCM' --For case: TPHCM
GO

--Cho danh sach cac san pham co gia trong mot khoang tu ... den
SELECT SP.* --.Ma AS N' DANH SÁCH CÁC SẢN PHẨM CÓ GIÁ TRONG KHOẢNG TỪ 10000 ĐẾN 20000', SP.Gia AS N'GIÁ'
FROM SanPham SP
WHERE SP.Gia BETWEEN 10000 AND 20000
GO

--CHO DANH SACH CAC SAN PHAM CO SO LUONG TON < 100
SELECT SP.* --AS N' DANH SÁCH CÁC SẢN PHẨM CÓ SỐ LƯỢNG TỒN < 100', SP.SoLuongTon AS N'SỐ LƯỢNG TỒN'
FROM SanPham SP
WHERE SP.SoLuongTon < 100
GO

--Cho danh sách các sản phẩm bán chạy nhất (số lượng bán nhiều nhất)
SELECT SP.*
FROM SanPham SP
	JOIN HoaDonChiTiet HDCT ON SP.Ma = HDCT.MaSP
GROUP BY SP.Ma, SP.Ten, SP.Gia, SP.MoTa, SP.SoLuongTon
HAVING SUM(HDCT.SoLuong) >= ALL (SELECT SUM(SoLuong)
									FROM HoaDonChiTiet
									GROUP BY MaSP)
GO

--Cho danh sách các sản phẩm có doanh thu cao nhất
SELECT SP.*
FROM SanPham SP
	JOIN HoaDonChiTiet HDCT ON SP.Ma = HDCT.MaSP
GROUP BY SP.Ma, SP.Ten, SP.Gia, SP.MoTa, SP.SoLuongTon
HAVING SUM(HDCT.SoLuong * HDCT.ThanhTien) >= ALL (SELECT SUM(SoLuong * ThanhTien)
													FROM HoaDonChiTiet
													GROUP BY MaSP)