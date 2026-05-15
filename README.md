# Hệ Thống Quản Lý Hội Nông Dân

Ứng dụng web quản lý hội viên và tổ chức Hội Nông Dân, xây dựng bằng Flask và MySQL.

## Công nghệ

- Flask 2.3
- MySQL 8.0 (hoặc 5.7+)
- openpyxl (nhập/xuất Excel)
- Docker Desktop

## Tính năng chính

- Quản lý hội viên: thêm, sửa, xóa, lọc, tìm kiếm
- Báo cáo tổng hợp hội viên theo xã
- **Báo cáo chi tiết**: hiển thị danh sách các Chi hội với số lượng hội viên, liên kết xem chi tiết hội viên
- Nhập hội viên từ file Excel, xuất báo cáo Excel với cấu trúc chính xác
- Đăng nhập theo vai trò (Admin, Chi hội, Tổ hội)

## Mặc định chạy bằng Docker Desktop

Đây là cách chạy mặc định cho dự án.

### 1. Mở Docker Desktop

Đảm bảo Docker Desktop đang ở trạng thái Running.

### 2. Chạy ứng dụng

```bash
docker compose up -d --build
```

### 3. Truy cập

- App: `http://localhost:5000`
- MySQL từ máy host: `localhost:3307`

### 4. Kiểm tra trạng thái

```bash
docker compose ps
```

### 5. Xem log

```bash
docker compose logs -f web
```

### 6. Dừng ứng dụng

```bash
docker compose down
```

## Cấu hình Docker

Tạo file `.env` (hoặc copy từ `.env.example`) rồi chỉnh các biến:

- `FLASK_ENV`
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_DB`
- `SECRET_KEY`

Lưu ý: khi chạy Docker, app kết nối DB qua host nội bộ `db` (đã cấu hình trong `docker-compose.yml`).

## Cấu trúc thư mục

```text
.
|-- app.py                  # Ứng dụng Flask chính
|-- config.py              # Cấu hình ứng dụng
|-- database.sql           # Schema và dữ liệu ban đầu
|-- init_db.py             # Script khởi tạo DB
|-- add_founded_date.py     # Script hỗ trợ thêm ngày thành lập
|-- docker-compose.yml     # Cấu hình Docker Compose
|-- Dockerfile             # Cấu hình Docker image
|-- requirements.txt       # Thư viện Python
|-- templates/             # HTML templates
|-- static/                # CSS, JS, images
`-- uploads/               # Thư mục tải lên hội viên
```

## Lỗi thường gặp khi chạy Docker

### Không kết nối được MySQL

- Kiểm tra trạng thái: `docker compose ps`.
- Xem log DB: `docker compose logs -f db`.
- Kiểm tra lại giá trị trong file `.env`.

### `ModuleNotFoundError: No module named 'MySQLdb'`

- Lỗi này thường chỉ gặp khi chạy local Python.
- Với Docker Desktop, build lại: `docker compose up -d --build`.

### Đăng nhập thất bại

- Kiểm tra tài khoản đã tồn tại trong bảng `users`.
- Kiểm tra cột `is_active = TRUE`.

## Ghi chú

- **Docker Desktop** là phương thức chạy mặc định cho dự án.
- **Tài khoản Admin**: mật khẩu `Hnd@123`
- **Trang Chi tiết Chi hội**: chỉ hiển thị các Chi hội (lọc theo `org_type='chi_hoi'`)
- **Xuất Excel**: tên file được sanitize, hỗ trợ xuất toàn bộ hội viên hoặc theo chi hội
- **File SQL**: dùng file đơn `database.sql` chứa toàn bộ schema
