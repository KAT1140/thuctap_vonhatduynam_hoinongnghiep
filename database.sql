/**
 * Database: Hội Nông Dân Thực Tập
 * Quản lý thông tin hội viên, tổ chức cấp xã/chi hội/tổ hội
 */

CREATE DATABASE IF NOT EXISTS hoi_nong_dan;
USE hoi_nong_dan;


/**
 * ============================================
 * BẢNG USERS - Quản lý người dùng hệ thống
 * ============================================
 * Role: admin (quản trị viên), chi_hoi (chi hội), to_hoi (trưởng tổ), hoi_vien (hội viên)
 */
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID người dùng',
    username VARCHAR(100) UNIQUE NOT NULL COMMENT 'Tên đăng nhập',
    password VARCHAR(255) NOT NULL COMMENT 'Mật khẩu (hash)',
    email VARCHAR(100) COMMENT 'Email',
    full_name VARCHAR(100) COMMENT 'Họ và tên',
    phone VARCHAR(20) COMMENT 'Số điện thoại',
    organization_id INT COMMENT 'ID tổ chức quản lý (nếu là chi_hoi hoặc to_hoi)',
    role ENUM('admin', 'chi_hoi', 'to_hoi', 'hoi_vien') DEFAULT 'hoi_vien' COMMENT 'Vai trò',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Kích hoạt',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_username (username),
    KEY idx_role (role)
) COMMENT='Người dùng hệ thống';


/**
 * ============================================
 * BẢNG ORGANIZATIONS - Cấu trúc hành chính
 * ============================================
 * Cấp bậc HÀNH CHÍNH: Xã → Chi Hội → Tổ Hội
 * 
 * Ví dụ:
 *   - Xã Hưng Mỹ (xa, parent=null)
 *     - Chi Hội Linh Xuân (chi_hoi, parent=Xã)
 *       - Tổ Hội Ấp Đa Hòa (to_hoi, parent=Chi Hội)
 */
CREATE TABLE organizations (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID tổ chức',
    name VARCHAR(255) NOT NULL COMMENT 'Tên tổ chức/ấp',
    org_type ENUM('xa', 'chi_hoi', 'to_hoi') NOT NULL DEFAULT 'xa' COMMENT 'Loại: xã, chi hội, tổ hội',
    parent_id INT COMMENT 'ID tổ chức cha',
    hamlet_name VARCHAR(150) COMMENT 'Tên ấp (nếu là tổ hội)',
    address TEXT COMMENT 'Địa chỉ',
    phone VARCHAR(20) COMMENT 'Số điện thoại',
    email VARCHAR(100) COMMENT 'Email',
    leader_name VARCHAR(100) COMMENT 'Tên trưởng tổ/chi hội',
    status VARCHAR(50) DEFAULT 'active' COMMENT 'Trạng thái: active, inactive',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES organizations(id) ON DELETE SET NULL,
    KEY idx_org_type (org_type),
    KEY idx_parent_id (parent_id),
    KEY idx_status (status)
) COMMENT='Tổ chức (xã, chi hội, tổ hội)';


/**
 * ============================================
 * BẢNG MEMBERS - Danh sách hội viên
 * ============================================
 * Member types: thuong (thường), dang_vien (đảng viên), nong_cot (nòng cốt)
 * Status: active (hoạt động), inactive (ngừng hoạt động), suspended (tạm khóa)
 */
CREATE TABLE members (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID hội viên',
    full_name VARCHAR(100) NOT NULL COMMENT 'Họ và tên',
    date_of_birth DATE COMMENT 'Ngày sinh',
    gender ENUM('nam', 'nu', 'khac') DEFAULT 'khac' COMMENT 'Giới tính',
    id_number VARCHAR(20) UNIQUE COMMENT 'Số CMND/CCCD',
    phone VARCHAR(20) COMMENT 'Số điện thoại',
    email VARCHAR(100) COMMENT 'Email',
    address TEXT COMMENT 'Địa chỉ thường trú',
    education_level VARCHAR(150) COMMENT 'Trình độ học vấn',
    ethnicity VARCHAR(100) COMMENT 'Dân tộc',
    religion VARCHAR(100) COMMENT 'Tôn giáo',
    organization_id INT NOT NULL COMMENT 'ID tổ hội chính',
    member_type ENUM('thuong', 'dang_vien', 'nong_cot') DEFAULT 'thuong' COMMENT 'Phân loại: thường, đảng viên, nòng cốt',
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active' COMMENT 'Trạng thái',
    join_date DATE COMMENT 'Ngày gia nhập hội',
    party_join_date DATE COMMENT 'Ngày vào Đảng',
    specialty VARCHAR(150) COMMENT 'Chuyên môn/Kỹ năng',
    politics VARCHAR(100) COMMENT 'Chính trị',
    username VARCHAR(100) COMMENT 'Tên tài khoản (nếu là hội viên login)',
    password VARCHAR(255) COMMENT 'Mật khẩu (hash)',
    is_verified BOOLEAN DEFAULT FALSE COMMENT 'Đã xác thực',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE RESTRICT,
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE SET NULL,
    KEY idx_organization_id (organization_id),
    KEY idx_status (status),
    KEY idx_member_type (member_type),
    KEY idx_id_number (id_number)
) COMMENT='Danh sách hội viên';


/**
 * ============================================
 * BẢNG MEMBER_ORGANIZATIONS - Hội viên tham gia nhiều tổ hội
 * ============================================
 * Hỗ trợ many-to-many: 1 hội viên có thể gia nhập nhiều tổ chức
 */
CREATE TABLE member_organizations (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID liên kết',
    member_id INT NOT NULL COMMENT 'ID hội viên',
    organization_id INT NOT NULL COMMENT 'ID tổ chức',
    join_date DATE COMMENT 'Ngày gia nhập tổ chức này',
    role_in_org VARCHAR(100) COMMENT 'Vai trò trong tổ chức (nếu có)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE,
    UNIQUE KEY unique_member_org (member_id, organization_id),
    KEY idx_member_id (member_id),
    KEY idx_organization_id (organization_id)
) COMMENT='Quan hệ hội viên - tổ chức (many-to-many)';


/**
 * ============================================
 * BẢNG REPORTS - Báo cáo hoạt động
 * ============================================
 */
CREATE TABLE reports (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID báo cáo',
    title VARCHAR(255) NOT NULL COMMENT 'Tiêu đề',
    description TEXT COMMENT 'Mô tả ngắn',
    content LONGTEXT COMMENT 'Nội dung báo cáo',
    report_date DATE COMMENT 'Ngày báo cáo',
    organization_id INT NOT NULL COMMENT 'ID tổ chức',
    created_by INT NOT NULL COMMENT 'ID người tạo',
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft' COMMENT 'Trạng thái',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    KEY idx_org_id (organization_id),
    KEY idx_status (status),
    KEY idx_report_date (report_date)
) COMMENT='Báo cáo hoạt động';


/**
 * ============================================
 * BẢNG ACTIVITY_LOGS - Lịch sử hoạt động
 * ============================================
 */
CREATE TABLE activity_logs (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID log',
    user_id INT NOT NULL COMMENT 'ID người dùng',
    action VARCHAR(255) NOT NULL COMMENT 'Hành động (thêm, sửa, xóa...)',
    details TEXT COMMENT 'Chi tiết hành động',
    ip_address VARCHAR(45) COMMENT 'Địa chỉ IP',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    KEY idx_user_id (user_id),
    KEY idx_created_at (created_at)
) COMMENT='Lịch sử hoạt động người dùng';
