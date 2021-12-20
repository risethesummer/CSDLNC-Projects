--create database shop_db
use shop_db
create table NHANVIEN
(
	MaNV int not null primary key,
	MaTK int unique,
	HoTenNV nvarchar(30),
	DiaChiNV nvarchar(30),
	NgaySinhNV date,
	EmailNV nvarchar(30),
	SDT_NV varchar(10),
	LoaiNV nvarchar(10)
)

CREATE TABLE TAIKHOAN
(
	MaTK int not null primary key,
	TaiKhoan varchar(20),
	MatKhau varchar(20),
	NgayLapTK datetime,
	TrangThai nvarchar(10),
	LoaiTK nvarchar(10),
)

--SO_LUONG_CNSP INT NOT NULL DEFAULT 0 CONSTRAINT CHK_CHI_NHANH_SP_SO_LUONG CHECK (SO_LUONG_CNSP >= 0)

CREATE TABLE TAIKHOANKH
(
	MaTK int unique,
	DiemTichLuy int,
	SoTienDaDung float not null default 0 constraint TAIKHOANKH_SoTienDaDung check (SoTienDaDung >=0)
)

CREATE TABLE KHACHHANG
(
	MaKH int not null primary key,
	MaTK int unique,
	HoTenKH nvarchar(30),
	DiaChiKH nvarchar(30),
	SDT_KH varchar(10),
	EmailKH varchar(30),
	NgaySinhKH date
)

CREATE TABLE LUONG
(
	MaNV int not null primary key,
	NgayCapNhatLuong datetime not null,
	LuongCung int,
	LuongThuong int
)

CREATE TABLE DIEMDANH
(
	MaNV int unique not null,
	GioDiemDanh datetime
)

CREATE TABLE CALAMVIEC
(
	MaCa int not null primary key,
	NgayCa  date not null,
	GioCa datetime not null,
	SoNhanVien int not null,
)

ALTER TABLE DIEMDANH ADD MaCa INT NOT NULL

ALTER TABLE NHANVIEN ADD CONSTRAINT FK_NHANVIEN_TAIKHOAN FOREIGN KEY (MaTK) REFERENCES TAIKHOAN(MaTK)
ALTER TABLE LUONG ADD CONSTRAINT FK_LUONG_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
ALTER TABLE DIEMDANH ADD CONSTRAINT FK_DIEMDANH_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
ALTER TABLE DIEMDANH ADD CONSTRAINT FK_DIEMDANH_CALAMVIEC FOREIGN KEY (MaCa) REFERENCES CALAMVIEC(MaCa)
ALTER TABLE TAIKHOANKH ADD CONSTRAINT FK_TAIKHOANKH_TAIKHOAN FOREIGN KEY (MaTK) REFERENCES TAIKHOAN(MaTK)
ALTER TABLE KHACHHANG ADD CONSTRAINT FK_KHACHHANG_TAIKHOAN FOREIGN KEY (MaTK) REFERENCES TAIKHOAN(MaTK)