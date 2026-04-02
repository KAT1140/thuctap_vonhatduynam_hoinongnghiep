"""
Script tạo database và tài khoản admin
"""

import MySQLdb
from werkzeug.security import generate_password_hash
import time

# Cấu hình MySQL
MYSQL_HOST = 'localhost'
MYSQL_USER = 'root'
MYSQL_PASSWORD = ''
MYSQL_DB = 'hoi_nong_dan'

def create_database():
    """Tạo database và bảng"""
    print("=" * 60)
    print("KHỞI TẠO DATABASE")
    print("=" * 60)
    
    try:
        # Kết nối không có database trước
        conn = MySQLdb.connect(
            host=MYSQL_HOST,
            user=MYSQL_USER,
            passwd=MYSQL_PASSWORD,
            charset='utf8mb4'
        )
        
        cursor = conn.cursor()
        print("✅ Kết nối MySQL thành công!")
        
        # Đọc file SQL
        with open('database.sql', 'r', encoding='utf-8') as f:
            sql_script = f.read()
        
        # Chạy các lệnh SQL
        for statement in sql_script.split(';'):
            statement = statement.strip()
            if statement:
                try:
                    cursor.execute(statement)
                except Exception as e:
                    print(f"⚠️  Lệnh: {statement[:50]}... → {e}")
        
        conn.commit()
        cursor.close()
        conn.close()
        
        print("✅ Database và bảng tạo thành công!")
        return True
        
    except MySQLdb.Error as e:
        print(f"❌ Lỗi MySQL: {e}")
        return False

def create_admin():
    """Tạo tài khoản admin"""
    print("\n" + "=" * 60)
    print("TẠO TÀI KHOẢN ADMIN")
    print("=" * 60)
    
    admin_info = {
        'username': 'Admin_Xa_HungMymoi',
        'password': 'Hnd@1234',
        'email': 'admin@hnd-thachhat.vn',
        'full_name': 'Admin Xã Hùng Mỹ',
        'phone': '0987654321'
    }
    
    print(f"\n📋 Tạo tài khoản:")
    print(f"   Username: {admin_info['username']}")
    print(f"   Password: {admin_info['password']}")
    
    try:
        time.sleep(1)  # Chờ database đã tạo xong
        
        conn = MySQLdb.connect(
            host=MYSQL_HOST,
            user=MYSQL_USER,
            passwd=MYSQL_PASSWORD,
            db=MYSQL_DB,
            charset='utf8mb4'
        )
        
        cursor = conn.cursor()
        
        # Kiểm tra tài khoản đã tồn tại
        cursor.execute("SELECT id FROM users WHERE username = %s", (admin_info['username'],))
        existing = cursor.fetchone()
        
        if existing:
            print(f"⚠️  Tài khoản đã tồn tại, xóa và tạo lại...")
            cursor.execute("DELETE FROM users WHERE username = %s", (admin_info['username'],))
            conn.commit()
        
        # Hash password
        password_hash = generate_password_hash(admin_info['password'])
        
        # Tạo admin
        cursor.execute("""
            INSERT INTO users (username, password, email, full_name, phone, role, is_active)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            admin_info['username'],
            password_hash,
            admin_info['email'],
            admin_info['full_name'],
            admin_info['phone'],
            'admin',
            True
        ))
        
        admin_id = cursor.lastrowid
        conn.commit()
        cursor.close()
        conn.close()
        
        print(f"\n✅ Tài khoản admin tạo thành công!")
        print(f"\n" + "=" * 60)
        print(f"🎉 ĐĂNG NHẬP NGAY:")
        print(f"=" * 60)
        print(f"   Username: {admin_info['username']}")
        print(f"   Password: {admin_info['password']}")
        print(f"   URL: http://localhost:5000")
        print(f"=" * 60)
        return True
        
    except MySQLdb.Error as e:
        print(f"❌ Lỗi: {e}")
        return False

if __name__ == '__main__':
    if create_database():
        create_admin()
        print("\n✅ Hoàn thành! Chạy: python app.py")
    else:
        print("\n❌ Khởi tạo thất bại!")
