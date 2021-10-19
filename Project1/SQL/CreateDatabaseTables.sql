CREATE DATABASE cua_hang;
USE cua_hang;

--Tạo bảng khách hàng
CREATE TABLE KhachHang (Ma CHAR(8) PRIMARY KEY, --example: hd000000 -> hd999999
	Ho NVARCHAR(10) NOT NULL,
	Ten NVARCHAR(10) NOT NULL,
	NgaySinh DATE,
	SoNha INT CONSTRAINT CHK_KhachHang_SoNha CHECK (SoNha >= 0),
	Duong NVARCHAR(50),
	Phuong NVARCHAR(50),
	Quan NVARCHAR(50),
	ThanhPho NVARCHAR(50) NOT NULL,
	SoDT VARCHAR(15) CONSTRAINT CHK_KhachHang_SDT CHECK (SoDT NOT LIKE '%[^0-9]%')); --phone characters are digits

--Tạo bảng hóa đơn
CREATE TABLE HoaDon (Ma CHAR(8) PRIMARY KEY, --example: hd000000 -> hd999999
	MaKH CHAR(8) NOT NULL,
	NgayLap DATE DEFAULT GETDATE(),
	TongTien INT NOT NULL CONSTRAINT CHK_HoaDon_TongTien CHECK (TongTien >= 0),
	CONSTRAINT FK_HoaDon_MaKH FOREIGN KEY (MaKH) REFERENCES KhachHang(Ma));

--Tạo bảng sản phẩm
CREATE TABLE SanPham (Ma CHAR(7) PRIMARY KEY, --example: sp00000 -> sp99999
	Ten NVARCHAR(50) NOT NULL UNIQUE,
	SoLuongTon INT DEFAULT 0 CONSTRAINT CHK_SanPham_SoLuongTon CHECK (SoLuongTon >= 0),
	MoTa NVARCHAR(100) DEFAULT '',
	Gia INT NOT NULL CONSTRAINT CHK_SanPham_Gia CHECK (Gia >= 0));

--Tạo bảng chi tiết hóa đơn
CREATE TABLE HoaDonChiTiet (MaHD CHAR(8) NOT NULL,
	MaSP CHAR(7) NOT NULL,
	SoLuong INT NOT NULL CONSTRAINT CHK_HoaDonChiTiet_SoLuong CHECK (SoLuong > 0),
	GiaBan INT NOT NULL CONSTRAINT CHK_HoaDonChiTiet_GiaBan CHECK (GiaBan >= 0),
	GiaGiam INT DEFAULT 0 CONSTRAINT CHK_HoaDonChiTiet_GiaGiam CHECK (GiaGiam >= 0),
	ThanhTien INT NOT NULL CONSTRAINT CHK_HoaDonChiTiet_ThanhTien CHECK (ThanhTien >= 0),
	PRIMARY KEY (MaHD, MaSP),
	CONSTRAINT FK_HoaDonChiTiet_MaHD FOREIGN KEY (MaHD) REFERENCES HoaDon(Ma),
	CONSTRAINT FK_HoaDonChiTiet_MaSP FOREIGN KEY (MaSP) REFERENCES SanPham(Ma));