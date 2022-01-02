--Quản lý: Thống kê doanh thu ngày
select count(DH.MaDH) as N'Tổng đơn hàng trong ngày', SUM(DH.TongGiaDH) as N'Tổng doanh thu trong ngày'
from DON_HANG DH
where '2021-12-31' = DH.NgayLapDH
go

-- Quản lý: Top sản phẩm bán chạy nhất
--alter table SAN_PHAM add SoLuongBan int
select SP.MaSP,SUM(CTDH.SoLuongDH) as 'So Luong SP da ban'
from DON_HANG DH, SAN_PHAM SP, CHI_TIET_DON_HANG CTDH
where CTDH.MaSP = SP.MaSP and DH.MaDH = CTDH.MaDH
group by SP.MaSP
having SUM(CTDH.SoLuongDH) >= all(
select SUM(CTDH.SoLuongDH)
from DON_HANG DH, SAN_PHAM SP, CHI_TIET_DON_HANG CTDH
where CTDH.MaSP = SP.MaSP and DH.MaDH = CTDH.MaDH
group by SP.MaSP)
go
-- Quản lý: Top sản phẩm bán chậm , thiet lap giam gia 10% cho san pham
select SP.MaSP,SUM(CTDH.SoLuongDH) as 'So Luong SP da ban', SP.GiaSP
from DON_HANG DH, SAN_PHAM SP, CHI_TIET_DON_HANG CTDH
where CTDH.MaSP = SP.MaSP and DH.MaDH = CTDH.MaDH
group by SP.MaSP, SP.GiaSP
having SUM(CTDH.SoLuongDH) <= all(
select SUM(CTDH.SoLuongDH)
from DON_HANG DH, SAN_PHAM SP, CHI_TIET_DON_HANG CTDH
where CTDH.MaSP = SP.MaSP and DH.MaDH = CTDH.MaDH
group by SP.MaSP)
go
--Quản lý: thiet lap giam gia 10% cho san pham
--Nhân sự: điểm danh
insert into DIEM_DANH(MaCa,MaNV,GioDiemDanh) values (1,1,'2021-12-31')
go
--Nhân sự: trả lương cho nhân viên thì sẽ thêm vào bảng LUONG
insert into LUONG(MaNV,NgayCapNhatLuong,LuongCung,LuongThuong) values (1,2021-12-31,700,100),(1,2021-11-31,700,0)
--Nhân sự: Tra cứu lịch sử lương
select *
from LUONG L
where L.MaNV = 1

CREATE INDEX SoLuongDH
on DON_HANG (NgayLapDH)
