"""
Migration cập nhật schema theo yêu cầu thực tế:
- Phân cấp tổ chức: xã -> chi hội -> tổ hội
- Bổ sung trường hội viên
- Chuẩn hóa quyền: admin, to_hoi, hoi_vien
"""

import MySQLdb
from config import config
import os


def run_migration():
    cfg = config[os.environ.get('FLASK_ENV', 'development')]

    conn = MySQLdb.connect(
        host=cfg.MYSQL_HOST,
        user=cfg.MYSQL_USER,
        passwd=cfg.MYSQL_PASSWORD,
        db=cfg.MYSQL_DB,
        charset='utf8mb4'
    )
    cursor = conn.cursor()

    statements = [
        "UPDATE users SET role='to_hoi' WHERE role='manager'",
        "UPDATE users SET role='hoi_vien' WHERE role='user'",
        "ALTER TABLE users MODIFY COLUMN role ENUM('admin', 'to_hoi', 'hoi_vien') DEFAULT 'hoi_vien'",

        "ALTER TABLE organizations ADD COLUMN IF NOT EXISTS org_type ENUM('xa', 'chi_hoi', 'to_hoi') NOT NULL DEFAULT 'xa' AFTER name",
        "ALTER TABLE organizations ADD COLUMN IF NOT EXISTS parent_id INT NULL AFTER org_type",
        "ALTER TABLE organizations ADD COLUMN IF NOT EXISTS hamlet_name VARCHAR(150) NULL AFTER parent_id",
        "ALTER TABLE organizations ADD CONSTRAINT fk_org_parent FOREIGN KEY (parent_id) REFERENCES organizations(id) ON DELETE SET NULL",

        "ALTER TABLE members ADD COLUMN IF NOT EXISTS date_of_birth DATE NULL AFTER full_name",
        "ALTER TABLE members ADD COLUMN IF NOT EXISTS gender ENUM('nam', 'nu', 'khac') DEFAULT 'khac' AFTER date_of_birth",
        "ALTER TABLE members ADD COLUMN IF NOT EXISTS education_level VARCHAR(150) NULL AFTER address",
        "ALTER TABLE members ADD COLUMN IF NOT EXISTS ethnicity VARCHAR(100) NULL AFTER education_level",
        "ALTER TABLE members ADD COLUMN IF NOT EXISTS religion VARCHAR(100) NULL AFTER ethnicity",
        "ALTER TABLE members ADD COLUMN IF NOT EXISTS hamlet_name VARCHAR(150) NULL AFTER religion",
        "ALTER TABLE members ADD COLUMN IF NOT EXISTS member_type ENUM('thuong', 'dang_vien', 'nong_cot') DEFAULT 'thuong' AFTER hamlet_name",

        "CREATE INDEX idx_organizations_parent ON organizations(parent_id)",
        "CREATE INDEX idx_organizations_type ON organizations(org_type)"
    ]

    for sql in statements:
        try:
            cursor.execute(sql)
            print(f"OK: {sql[:80]}...")
        except Exception as error:
            message = str(error)
            if "Duplicate" in message or "already exists" in message or "Duplicate key name" in message:
                print(f"SKIP: {sql[:80]}...")
            elif "Duplicate foreign key constraint name" in message:
                print(f"SKIP FK: {sql[:80]}...")
            else:
                print(f"ERROR: {sql}\n -> {error}")
                raise

    conn.commit()
    cursor.close()
    conn.close()
    print("\nMigration hoàn tất.")


if __name__ == '__main__':
    run_migration()
