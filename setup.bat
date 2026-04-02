@echo off
REM Script setup tự động cho Windows

setlocal enabledelayedexpansion

echo.
echo ================================
echo Hoi Nong Dan Viet Nam - Setup
echo ================================
echo.

REM Kiểm tra Python
py --version >nul 2>&1
if errorlevel 1 (
    echo Loi: Python chua duoc cai dat hoac không có trong PATH
    echo Tai Python tại: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Tạo virtual environment
echo Tao virtual environment...
py -m venv venv

REM Kích hoạt virtual environment
call venv\Scripts\activate.bat

REM Cài đặt requirements
echo Cai dat dependencies...
pip install -r requirements.txt

REM Kiểm tra MySQL
echo.
echo Kiem tra MySQL...
mysql --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo KIEM TRA: MySQL chua duoc cai dat hoac không có trong PATH
    echo Tai MySQL tại: https://dev.mysql.com/downloads/mysql/
    echo.
    echo Hoac, neu da cai dat MySQL, them duong dan MySQL vao PATH:
    echo - Duong dan mac dinh: C:\Program Files\MySQL\MySQL Server 8.0\bin
    pause
) else (
    echo Nhap password MySQL neu co:
    mysql -u root -p < database.sql
    if errorlevel 1 (
        echo.
        echo Loi: Khong the tao database
        pause
        exit /b 1
    )
)

REM Tạo admin
echo.
echo Tao tai khoan admin...
python create_admin.py

REM Seed data
echo.
set /p seed="Ban co muon them du lieu mau khong? (y/n): "
if /i "%seed%"=="y" (
    python seed_data.py
)

echo.
echo ==========================================
echo Setup hoan thanh!
echo Chay ung dung: python app.py
echo Truy cap: http://localhost:5000
echo ==========================================
pause
