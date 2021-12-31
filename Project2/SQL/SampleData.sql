USE shop_db;

INSERT INTO SAN_PHAM(TenSP, MoTaSP, LoaiSP, GiaSP, DuongDanHinhAnh, SoLuongTonKho)
VALUES
(N'Trầu bà', N'Nét đẹp sang trọng', N'Hoa văn phòng', 50000, 'trau-ba.png', 1000),
(N'Lưỡi hổ phát tài', N'Trừ tà, xua đuổi tiểu nhân', N'Hoa văn phòng', 40000, 'luoi-ho.png', 1000),
(N'Khởi sắc thành công', N'Tượng trưng cho năng lượng', N'Hoa chúc mừng', 4500000, 'khoi-sac.png', 1000),
(N'Vững bước', N'Thích hợp tặng dịp khai trương', N'Hoa chúc mừng', 4400000, 'vung-buoc.png', 1000),
('You are beautiful', N'Là phụ nữ hãy sống như cây', N'Hoa tình yêu', 750000, 'you-are-beautiful.png', 200),
('LA VIE EN ROSE', N'Thông điệp của lòng yêu mến', N'Hoa tình yêu', 750000, 'la-vie-en-rose.png', 500),
('Litghting Berry Fresh', N'Mang không khí Noel', N'Bánh', 550000, 'berry-fresh.png', 100),
('Tous les Jours', N'Điểm nhấn đặc biệt', 'Bánh', 600000, 'tous-les-jours.png', 1000);

SELECT * FROM SAN_PHAM