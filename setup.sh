#!/bin/bash
# Script setup tự động cho Linux/Mac

echo "================================"
echo "Hội Nông Dân Việt Nam - Setup"
echo "================================"

# Tạo virtual environment
echo "Tạo virtual environment..."
python3 -m venv venv

# Kích hoạt virtual environment
source venv/bin/activate

# Cài đặt dependencies
echo "Cài đặt dependencies..."
pip install -r requirements.txt

# Tạo database
echo "Tạo database..."
mysql -u root -p < database.sql

# Tạo admin
echo "Tạo tài khoản admin..."
python create_admin.py

# Seed data
read -p "Bạn có muốn thêm dữ liệu mẫu không? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    python seed_data.py
fi

echo "Setup hoàn thành!"
echo "Chạy ứng dụng: python app.py"
