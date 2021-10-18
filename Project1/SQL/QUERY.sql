--Cho danh sach cac hoa don lap trong nam 2020
USE cua_hang
SELECT HD.Ma AS N'DANH SÁCH CÁC HÓA ĐƠN LẬP TRONG NĂM 2020' 
FROM HoaDon HD
WHERE DATEPART(YEAR,HD.NgayLap) = 2020
GO

--Cho danh sach cac khach hang	 o TPHCM
SELECT KH.Ma AS N'DANH SÁCH CÁC KHÁCH HÀNG Ở TP HCM'
FROM KhachHang KH
WHERE KH.ThanhPho = N'Hồ Chí Minh'
GO

--Cho danh sach cac san pham co gia trong mot khoang tu ... den
SELECT SP.Ma AS N' DANH SÁCH CÁC SẢN PHẨM CÓ GIÁ TRONG KHOẢNG TỪ 10000 ĐẾN 20000', SP.Gia AS N'GIÁ'
FROM SanPham SP
WHERE SP.Gia BETWEEN 10000 AND 20000
GO

--CHO DANH SACH CAC SAN PHAM CO SO LUONG TON < 100
SELECT SP.Ma AS N' DANH SÁCH CÁC SẢN PHẨM CÓ SỐ LƯỢNG TỒN < 100', SP.SoLuongTon AS N'SỐ LƯỢNG TỒN'
FROM SanPham SP
WHERE SP.SoLuongTon < 100
GO

