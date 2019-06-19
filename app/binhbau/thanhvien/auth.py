from django.conf import settings
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import User
import cx_Oracle

class OracleAuthBackend:
    """
    """
    def authenticate(self, request, username = None, password = None):
        # Tạo chuỗi dsn để kết nối với oracle db
        dsnStr = cx_Oracle.makedsn(
            settings.ORACLE_HOST,
            settings.ORACLE_POST,
            settings.ORACLE_SID,
            settings.ORACLE_SERVICE_NAME)
        # Kiểm tra kết nối
        try:
            auth_con = cx_Oracle.connect(user=username, password=password, dsn=dsnStr)
            auth_con.close()
        except:
            return None
        # Kết nối thành công, tạo username tương ứng cho người dùng và thêm vào app
        oracle_user = username.upper()
        try:
            user = User.objects.get(username = oracle_user)
        except:
            user = User(username = oracle_user)
            user.set_unusable_password()
            try:
                user.save()
            except:
                return None
        return user

    def get_user(self, user_id):
        try:
            return User.objects.get(pk = user_id)
        except:
            return None


