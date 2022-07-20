Cái file này không cần chạy
USE shop_db
go
-- Xem danh sách sản phẩm còn hàng thuộc loại 'Hoa vieng' 
SELECT *
FROM dbo.SAN_PHAM
WHERE LoaiSP = 'Hoa vieng'
-- Giải pháp: Tạo view => mỗi lần muốn xem danh sách chỉ cần select view (không cần where)
CREATE VIEW [danh_sach_san_pham_hoa_vieng] AS
SELECT MaSP, TenSP, MoTaSP, SoLuongTonKho, GiaSP
FROM dbo.SAN_PHAM
WHERE LoaiSP = 'Hoa vieng' and SoLuongTonKho > 0
WITH CHECK OPTION;

SELECT * FROM danh_sach_san_pham_hoa_vieng
--DROP VIEW danh_sach_san_pham_hoa_vieng

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
-- Xem lịch sử chi tiết các đơn hàng đã mua và giao thành công của khach hang
SELECT DH.MaKH, DH.MaDH, DH.NgayLapDH, CTDH.MaSP, CTDH.DonGiaDH, CTDH.DonGiaDH, CTDH.SoLuongDH
FROM dbo.DON_HANG DH JOIN CHI_TIET_DON_HANG CTDH ON  DH.MaDH = CTDH.MaDH
WHERE TrangThaiDH = 'Da giao'

--Vấn đề: Giao tác này thực hiện với tần suất lớn, phải kết bảng nhiều lần dẫn đến giảm hiệu suất
--Giải pháp: Tạo view danh sách đơn hàng đã giao để hạn chế kết bảng và giảm dữ liệu truy xuất
CREATE VIEW [danh_sach_don_hang_da_giao] AS
SELECT DH.MaKH, DH.MaDH, DH.NgayLapDH, CTDH.MaSP, CTDH.DonGiaDH, CTDH.SoLuongDH
FROM dbo.DON_HANG DH JOIN CHI_TIET_DON_HANG CTDH ON  DH.MaDH = CTDH.MaDH
WHERE TrangThaiDH = 'Da giao'
WITH CHECK OPTION;

select * from danh_sach_don_hang_da_giao

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-- Xem danh sách sản phẩm sắp xếp theo độ bán chạy
SELECT SP.MaSP, SUM(CTDH.SoLuongDH) AS N'Số lượng sản phẩm đã bán'
FROM (dbo.SAN_PHAM SP JOIN dbo.CHI_TIET_DON_HANG CTDH ON SP.MaSP = CTDH.MaSP)
	JOIN dbo.DON_HANG DH ON DH.MaDH = CTDH.MaDH
GROUP BY SP.MaSP
HAVING SUM(CTDH.SoLuongDH) >= ALL (SELECT SUM(CTDH.SoLuongDH)
									FROM (dbo.SAN_PHAM JOIN dbo.CHI_TIET_DON_HANG ON dbo.SAN_PHAM.MaSP = CHI_TIET_DON_HANG.MaSP)
											JOIN dbo.DON_HANG ON DON_HANG.MaDH = CHI_TIET_DON_HANG.MaDH
									GROUP BY SAN_PHAM.MaSP)
ORDER BY SUM(CTDH.SoLuongDH) DESC;

-- Vấn đề: Giao tác này được truy xuất với tần suất lớn, có rất nhiều phép kết bảng xảy ra làm giảm hiệu suất truy vấn
-- Giải pháp: Thêm thuộc tính SoLuongDaBan vào bảng SAN_PHAM để lưu lại số lượng đã bán của từng sản phẩm, từ đó dễ dàng thực hiện câu truy vấn trên
-- SAN_PHAM.SoLuongDaBan = SUM(CHI_TIET_DON_HANG.SoLuongSP) (Điều kiện: SAN_PHAM.MaSP = CHI_TIET_DON_HANG.MaSP)

ALTER TABLE SAN_PHAM ADD SoLuongDaBan INT;

SELECT * FROM SAN_PHAM
ORDER BY SoLuongDaBan DESC;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-- Quản lý nhập hàng (xuất hàng) trong năm 2020, 2021 và những năm trước năm 2020
-- Ví dụ: Xem lịch sử nhập hàng trong năm 2020
-- Vấn đề: Khi dữ liệu ngày càng tăng (vài triệu bảng ghi) và thường xuyên cập nhật,
-- việc truy vấn, sửa đổi, backup ... rất khó văn và performance không tốt
-- Giải pháp: Phân đoạn trên bảng DON_GIAO_HANG (nhập hàng về) đề dễ quản trị và tăng performance
-- (việc truy xuất trên một đoạn sẽ nhanh hơn rất nhiều so với trên toàn bộ bảng)

--Tao filegroup
ALTER DATABASE shop_db ADD FILEGROUP FG2019AndBefore
ALTER DATABASE shop_db ADD FILEGROUP FG2020
ALTER DATABASE shop_db ADD FILEGROUP FG2021AndAfter
go
--Tao data file cho mỗi filegroup
ALTER DATABASE shop_db ADD FILE (NAME = N'FY2019AndBefore', FILENAME = N'D:\FY2019AndBefore.ndf') TO FILEGROUP FG2019AndBefore
ALTER DATABASE shop_db ADD FILE (NAME = N'FY2020', FILENAME = N'D:\FY2020.ndf') TO FILEGROUP FG2020
ALTER DATABASE shop_db ADD FILE (NAME = N'FY2021AndAfter', FILENAME = N'D:\FY2021AndAfter.ndf') TO FILEGROUP FG2021AndAfter
go
--Tạo partition function
CREATE PARTITION FUNCTION PFunc_NgayLap(DATETIME) AS RANGE RIGHT FOR VALUES ('2020-01-01', '2021-01-01')
GO
-- Tạo partition scheme
CREATE PARTITION SCHEME PScheme_NgayLap AS PARTITION PFunc_NgayLap TO (FG2019AndBefore, FG2020, FG2021AndAfter)
go
--Tạo bảng DON_GIAO_HANG và DON_DAT_HANG dùng partition scheme
-- DROP TABLE CHI_TIET_DON_GIAO_HANG
-- DROP TABLE DON_GIAO_HANG

CREATE TABLE DON_GIAO_HANG (
    MaDGH INT IDENTITY(1,1),
    NgayLapDGH DATETIME NOT NULL DEFAULT GETDATE(),
    MaDDH INT NOT NULL,
    MaNV INT NOT NULL,
	FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN(MaNV),
	FOREIGN KEY (MaDDH) REFERENCES DON_DAT_HANG(MaDDH)
) ON PScheme_NgayLap(NgayLapDGH);
GO
CREATE CLUSTERED INDEX CI_DON_GIAO_HANG_NgayLap ON DON_GIAO_HANG(NgayLapDGH) ON PScheme_NgayLap(NgayLapDGH)
GO
CREATE TABLE CHI_TIET_DON_GIAO_HANG (
    MaDGH INT NOT NULL,
    MaSP INT NOT NULL,
    DonGiaDGH DECIMAL(15,2) NOT NULL CONSTRAINT positive_ctdgh_dongia CHECK (DonGiaDGH >= 0),
    SoLuongDGH INT DEFAULT 1 CONSTRAINT positive_ctdgh_soluong CHECK (SoLuongDGH > 0),
	PRIMARY KEY (MaDGH,MaSP),
	FOREIGN KEY (MaDGH) REFERENCES DON_GIAO_HANG(MaDGH),
	FOREIGN KEY (MaSP) REFERENCES SAN_PHAM(MaSP)
);
