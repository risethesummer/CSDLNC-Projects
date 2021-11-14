# CSDLNC-Projects
Mô tả đồ án #1 môn học
1. Chuẩn bị dữ liệu: Tạo csdl và phát sinh dữ liệu mẫu để test chỉ mục như sau:
- KhachHang (MakH, Ho, Ten, Ngsinh, SoNha, Duong, Phuong, Quan, Tpho,
DienThoai)  100.000 rows, trong đó 2/3 số Khách hàng ở TPHCM, còn lại là các
tỉnh thành khác.
- HoaDon (MaHD, MaKH, NgayLap, TongTien)  500.000 rows, trong đó ngày lập
hoá đơn là từ 05-2020 đến 6/2021
- CT_HoaDon (MaHD, MaSP, SoLuong, GiaBan, GiaGiam, ThanhTien)  1 triệu
rows
- SanPham (MaSP, TenSP, SoLuongTon, Mota, Gia)  10.000 sp, trong đó 2/3 số
dòng bỏ trống mô tả

- Hướng dẫn sử dụng tool: https://blog.devart.com/generate-test-data-with-sql-
data-generator.html

- Sinh viên tự xác định kiểu dữ liệu, độ dài dữ liệu cho lược đồ trên. Dữ liệu phát
sinh phải đảm bảo liên hệ ý nghĩa
a. (tổng tiền hoá đơn = sum (chi tiết hoá đơn) của hoá đơn đó.
b. HoaDon (MaKH) thuộc KhachHang(MaKH)
c. CT_HoaDon (MaHD, MaSP) thuộc SanPham (MaSP) và HoaDon (MaHD)
d. Họ Tên khách hàng là chuỗi có ý nghĩa
 Hồ Thị Hoàng Vy 
 ABC DEF 

2. Cài trigger sau:
a. Thành tiền CTHD= (Số lượng * (Giá bán-Giá giảm))
b. Tổng tiền (mahd) = sum (ThanhTien) cthd(mahd)
3. Viết các truy vấn sau:
a. Cho danh sách các hoá đơn lập trong năm 2020
b. Cho danh sách các khách hàng ở TPHCM
c. Cho danh sách các sản phẩm có giá trong một khoảng từ....đến
d. Cho danh sách các sản phẩm có số lượng tồn <100
e. Cho danh sách các sản phẩm bán chạy nhất (số lượng bán nhiều nhất)
f. Cho danh sách các sản phẩm có doanh thu cao nhất
4. Lập trình giao diện:
a. Thêm mới hoá đơn

b. Xem danh sách hoá đơn
c. Thống kê doanh thu theo tháng
5. Từ các kết quả truy vấn của câu 3, ghi nhận lại index recommendation từ
execution plan (nếu có), Quan sát exection plan giải thích execution plan. Ngoài
ra, nhận xét execution plan (thời gian thực thi) Cho một số trường hợp sau:
a. Select * from A join B join C on.... Và Select * from A,B,C where A.x = B.x....
b. Select * from A jọin B (A có số dòng nhỏ, B rất lớn) và Select * from B join
A
6. Quy định nộp bài:

Thư mục nộp bài nén (.rar, .zip) đặt tên MaNhom_DA1:
 Script tạo csdl trên (.sql),
 Script truy vấn, tạo index
 Báo cáo (.doc) giải thích kết quả chạy truy vấn và quan sát execution
plan gồm có/không có index), kết quả điều chỉnh chỉ mục (nếu có) dựa
vào gợi ý của sqlserver hoặc tự đề xuất
 Source code lập trình giao diện post lên github
 Phân công công việc, % hoàn thành của nhóm và thành viên, xuất report
từ Github
 Quay video có camera quá trình thảo luận, hoạt động nhóm (tạo drive
folder đặt tên mã nhóm, nộp link vào báo cáo .doc ở trên, lưu ý drive
folder này sử dụng cho các lần nộp sau)
