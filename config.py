import os
from datetime import timedelta

class Config:
    """Config chung"""
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-production'
    PERMANENT_SESSION_LIFETIME = timedelta(days=7)
    
class DevelopmentConfig(Config):
    """Config phát triển"""
    DEBUG = True
    MYSQL_HOST = 'localhost'
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = ''  # Thay bằng password MySQL của bạn
    MYSQL_DB = 'hoi_nong_dan'
    MYSQL_CURSORCLASS = 'DictCursor'

class ProductionConfig(Config):
    """Config production"""
    DEBUG = False
    MYSQL_HOST = os.environ.get('MYSQL_HOST')
    MYSQL_USER = os.environ.get('MYSQL_USER')
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD')
    MYSQL_DB = os.environ.get('MYSQL_DB')
    MYSQL_CURSORCLASS = 'DictCursor'

config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}
