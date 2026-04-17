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
    MYSQL_PORT = 3307
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = 'rootpassword'
    MYSQL_DB = 'hoi_nong_dan'
    MYSQL_CURSORCLASS = 'DictCursor'

class ProductionConfig(Config):
    """Config production"""
    DEBUG = False
    MYSQL_HOST = os.environ.get('MYSQL_HOST') or 'localhost'
    # Use port 3306 for Docker internal network, 3307 for host external
    MYSQL_PORT = int(os.environ.get('MYSQL_PORT') or 3306)
    MYSQL_USER = os.environ.get('MYSQL_USER') or 'root'
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD') or 'rootpassword'
    MYSQL_DB = os.environ.get('MYSQL_DB') or 'hoi_nong_dan'
    MYSQL_CURSORCLASS = 'DictCursor'

config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}
