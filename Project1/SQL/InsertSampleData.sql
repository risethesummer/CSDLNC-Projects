use cua_hang;

INSERT INTO KhachHang(Ma, Ho, Ten, NgaySinh, SoNha, Duong, Phuong, Quan, ThanhPho, SoDT)
VALUES
	('kh000000', N'Hồ', N'Nhật Linh', '2001-05-19', 155, N'Trần Xuân Soạn', N'Tân Hưng', N'7', N'Hồ Chí Minh', '012876888'), 
	('kh000001', N'Trần', N'Phước Xuân', '2000-06-28', 342, N'Nguyễn Hữu Thọ', N'Tân Thuận Đông', N'7', N'Hồ Chí Minh', '0981113679'), 
	('kh000002', 'Lionel', 'Messi', '1998-12-15', 1, N'Võ Trưởng Toản', '02', N'Bình Thạnh', N'Hồ Chí Minh', '0898886789'), 
	('kh000003', N'Nguyễn', N'Thị Thảo', '2003-03-25', 66, N'Số 1', N'An Lạc', N'Bình Tân', N'Hồ Chí Minh', '07783893222'), 
	('kh000004', N'Võ', N'Văn Thiện', '1995-07-07', 108, N'Tân Hương', N'Tân Quý', N'Tân Phú', N'Hồ Chí Minh', '08655544455'), 
	('kh000005', N'Phùng', N'Thanh Độ', '2003-04-13', 581, N'Khóm Vĩnh  Tây', N'Núi Sam', NULL, N'Châu Đốc', '012876888'), 
	('kh000006', N'Đạt', N'Văn Tây', '1996-03-17', 206, N'Nguyễn Tri Phương', N'An Bình', NULL, N'Dĩ An', '0919799991');

INSERT INTO HoaDon (Ma, MaKH, TongTien)
VALUES
	('hd000000', 'kh000000',0),-- 130000),
	('hd000001', 'kh000005',0),-- 275000),
	('hd000002', 'kh000003',0),-- 85000),
	('hd000003', 'kh000004',0)-- 135000);

INSERT INTO SanPham(Ma, Ten, SoLuongTon, MoTa, Gia)
VALUES
	('sp00000', N'Khoai Tây Chiên gói', 1000, N'Đồ ăn vặt', 20000),
	('sp00001', N'Đường cát trắng bịch', 262, N'Gia vị nấu ăn', 25000),
	('sp00002', N'Cá mòi hộp', 56, N'Thức ăn đóng hộp', 15000),
	('sp00003', N'Muối i-ốt bịch', 1635, N'Gia vị nấu ăn', 5000),
	('sp00004', N'Sữa tươi bịch', 354, N'Nước giải khát', 8000),
	('sp00005', N'Cocacola chai', 536, N'Nước giải khát', 10000),
	('sp00006', N'Sữa đặc lon', 473, N'Nguyên liệu nấu ăn', 23000),
	('sp00007', N'Cá ngừ ngâm dầu hộp', 113, N'Thức ăn đóng hộp', 31000),
	('sp00008', N'Chả cá bịch 500g', 53, N'Nguyên liệu nấu ăn', 77000);

INSERT INTO HoaDonChiTiet (MaHD, MaSP, SoLuong, GiaGiam)
VALUES
	('hd000000', 'sp00000', 3, 0),
	('hd000000', 'sp00008', 1, 7000),

	('hd000001', 'sp00001', 2, 0),
	('hd000001', 'sp00003', 3, 0),
	('hd000001', 'sp00004', 10, 1000),
	('hd000001', 'sp00008', 2, 7000),

	('hd000002', 'sp00002', 1, 0),
	('hd000002', 'sp00005', 6, 1000),
	('hd000002', 'sp00006', 1, 3000),

	('hd000003', 'sp00001', 3,  0),
	('hd000003', 'sp00007', 2,  1000);

