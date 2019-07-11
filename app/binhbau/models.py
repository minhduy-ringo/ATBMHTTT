# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255, blank=True, null=True)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128, blank=True, null=True)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.BooleanField()
    username = models.CharField(unique=True, max_length=150, blank=True, null=True)
    first_name = models.CharField(max_length=30, blank=True, null=True)
    last_name = models.CharField(max_length=150, blank=True, null=True)
    email = models.CharField(max_length=254, blank=True, null=True)
    is_staff = models.BooleanField()
    is_active = models.BooleanField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Btc(models.Model):
    ma_btc = models.ForeignKey('Thanhvien', models.DO_NOTHING, db_column='ma_btc', primary_key=True)
    hoten = models.CharField(max_length=50, blank=True, null=True)
    namsinh = models.CharField(max_length=4, blank=True, null=True)
    gioitinh = models.CharField(max_length=3, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'btc'


class Chinhanh(models.Model):
    ma_chinhanh = models.CharField(primary_key=True, max_length=20)
    tenchinhanh = models.CharField(max_length=50, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'chinhanh'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200, blank=True, null=True)
    action_flag = models.IntegerField()
    change_message = models.TextField(blank=True, null=True)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100, blank=True, null=True)
    model = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255, blank=True, null=True)
    name = models.CharField(max_length=255, blank=True, null=True)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField(blank=True, null=True)
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class Donvi(models.Model):
    ma_donvi = models.CharField(primary_key=True, max_length=20)
    tendonvi = models.CharField(max_length=50, blank=True, null=True)
    truongdonvi = models.ForeignKey('Thanhvien', models.DO_NOTHING, db_column='truongdonvi', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'donvi'


class Giamsat(models.Model):
    ma_giamsat = models.ForeignKey('Thanhvien', models.DO_NOTHING, db_column='ma_giamsat', primary_key=True)
    hoten = models.CharField(max_length=50, blank=True, null=True)
    namsinh = models.CharField(max_length=4, blank=True, null=True)
    gioitinh = models.CharField(max_length=3, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'giamsat'


class Phieubau(models.Model):
    ma_phieubau = models.IntegerField(primary_key=True)
    ma_thanhvien = models.IntegerField('Thanhvien', models.DO_NOTHING, db_column='ma_thanhvien')
    ucv1 = models.CharField(max_length=100,blank=False)
    ucv2 = models.CharField(max_length=100,blank=False)
    ucv3 = models.CharField(max_length=100,blank=False)

    class Meta:
        managed = False
        db_table = 'phieubau'
        unique_together = (('ma_phieubau', 'ma_thanhvien'),)


class Thanhvien(models.Model):
    ma_thanhvien = models.FloatField(primary_key=True)
    hoten = models.CharField(max_length=50, blank=True, null=True)
    gioitinh = models.CharField(max_length=3, blank=True, null=True)
    quequan = models.CharField(max_length=100, blank=True, null=True)
    namsinh = models.CharField(max_length=4, blank=True, null=True)
    quoctich = models.CharField(max_length=20, blank=True, null=True)
    diachi = models.CharField(max_length=100, blank=True, null=True)
    donvi = models.ForeignKey(Donvi, models.DO_NOTHING, db_column='donvi', blank=True, null=True)
    chinhanh = models.ForeignKey(Chinhanh, models.DO_NOTHING, db_column='chinhanh', blank=True, null=True)
    luong = models.FloatField(blank=True, null=True)
    congtac = models.BooleanField(blank=True, null=True)
    tamnghi = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'thanhvien'
