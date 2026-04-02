# Hệ Thống Quản Lý Hội Nông Dân

Ứng dụng web quản lý hội viên và tổ chức Hội Nông Dân, xây dựng bằng Flask và MySQL.

## Công nghệ

- Flask 2.3
- MySQL 8.0 (hoặc 5.7+)
- openpyxl (nhập/xuất Excel)
- Docker Desktop

## Tính năng chính

- Quản lý hội viên: thêm, sửa, xóa, lọc, tìm kiếm
- Quản lý tổ chức theo phân cấp: xã -> chi hội -> tổ hội
- Báo cáo tổng hợp và chi tiết hội viên
- Nhập hội viên từ file Excel, xuất báo cáo Excel
- Đăng nhập theo vai trò

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
|-- app.py
|-- config.py
|-- database.sql
|-- init_db.py
|-- migrate_db.py
|-- create_admin.py
|-- update_admin.py
|-- docker-compose.yml
|-- Dockerfile
|-- requirements.txt
|-- templates/
|-- static/
`-- uploads/
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

- Tài liệu này ưu tiên luồng Docker Desktop mặc định.
- Theo yêu cầu hiện tại: chưa xóa file thật trong project, chỉ dọn lại nội dung tài liệu.
