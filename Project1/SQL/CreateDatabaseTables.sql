CREATE DATABASE cua_hang;
GO

USE cua_hang;
GO

----------------------
--Tạo bảng khách hàng-
----------------------
CREATE TABLE KhachHang (MaKH CHAR(8) PRIMARY KEY, --example: hd000000 -> hd999999
	Ho NVARCHAR(10) NOT NULL,
	Ten NVARCHAR(10) NOT NULL,
	NgSinh DATE,
	SoNha INT CONSTRAINT CHK_KhachHang_SoNha CHECK (SoNha >= 0),
	Duong NVARCHAR(50),
	Phuong NVARCHAR(50),
	Quan NVARCHAR(50),
	TPho NVARCHAR(50) NOT NULL,
	DienThoai VARCHAR(15) NOT NULL CONSTRAINT CHK_KhachHang_SDT CHECK (DienThoai NOT LIKE '%[^0-9]%')); --phone characters are digits
GO

----------------------
--Tạo bảng hóa đơn----
----------------------
CREATE TABLE HoaDon (MaHD CHAR(8) PRIMARY KEY, --example: hd000000 -> hd999999
	MaKH CHAR(8) NOT NULL,
	NgayLap DATE NOT NULL DEFAULT GETDATE(),
	TongTien INT NOT NULL DEFAULT 0 CONSTRAINT CHK_HoaDon_TongTien CHECK (TongTien >= 0),
	CONSTRAINT FK_HoaDon_MaKH FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH) ON DELETE CASCADE);
GO

---------------------
--Tạo bảng sản phẩm--
---------------------
CREATE TABLE SanPham (MaSP CHAR(7) PRIMARY KEY, --example: sp00000 -> sp99999
	TenSP NVARCHAR(50) NOT NULL UNIQUE,
	SoLuongTon INT NOT NULL DEFAULT 0 CONSTRAINT CHK_SanPham_SoLuongTon CHECK (SoLuongTon >= 0),
	MoTa NVARCHAR(100) DEFAULT '',
	Gia INT NOT NULL CONSTRAINT CHK_SanPham_Gia CHECK (Gia >= 0));
GO

------------------------------
--Tạo bảng chi tiết hóa đơn---
------------------------------
CREATE TABLE CT_HoaDon (MaHD CHAR(8) NOT NULL,
	MaSP CHAR(7) NOT NULL,
	SoLuong INT NOT NULL CONSTRAINT CHK_CTHD_SoLuong CHECK (SoLuong > 0),
	GiaBan INT CONSTRAINT CHK_CTHD_GiaBan CHECK (GiaBan >= 0),
	GiaGiam INT NOT NULL DEFAULT 0 CONSTRAINT CHK_CTHD_GiaGiam CHECK (GiaGiam >= 0),
	ThanhTien INT CONSTRAINT CHK_CTHD_ThanhTien CHECK (ThanhTien >= 0),
	PRIMARY KEY (MaHD, MaSP),
	CONSTRAINT FK_CTHD_MaHD FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD) ON DELETE CASCADE,
	CONSTRAINT FK_CTDH_MaSP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON DELETE CASCADE);
GO

--------------------------------------
--Tạo index cho MaSP trong CT_HoaDon--
--------------------------------------
CREATE NONCLUSTERED INDEX [CT_HoaDon_MaSP_ID]
ON CT_HoaDon([MaSP])