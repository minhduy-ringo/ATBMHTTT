from django.db import models

class Chinhanh(models.Model):
    ma_chinhanh = models.CharField(primary_key=True, max_length=20, verbose_name='Mã chi nhánh')
    tenchinhanh = models.CharField(max_length=50, blank=True, null=True, verbose_name='Tên chi nhánh')

    class Meta:
        managed = False
        db_table = 'chinhanh'


class Donvi(models.Model):
    ma_donvi = models.CharField(primary_key=True, max_length=20, verbose_name='Mã đơn vị')
    tendonvi = models.CharField(max_length=50, blank=True, null=True, verbose_name='Tên đơn vị')
    truongdonvi = models.ForeignKey('Thanhvien', models.DO_NOTHING, related_name='+', db_column='truongdonvi', blank=True, null=True, verbose_name='Trưởng đơn vị')

    class Meta:
        managed = False
        db_table = 'donvi'

class Thanhvien(models.Model):
    ma_thanhvien = models.AutoField(primary_key=True, blank=True, editable=False, verbose_name='Mã thành viên')
    hoten = models.CharField(max_length=50, blank=True, null=True, verbose_name='Họ và tên')
    gioitinh = models.CharField(max_length=3, blank=True, null=True, verbose_name='Giới tính')
    quequan = models.CharField(max_length=100, blank=True, null=True, verbose_name='Quê quán')
    namsinh = models.CharField(max_length=4, blank=True, null=True, verbose_name='Năm sinh')
    quoctich = models.CharField(max_length=20, blank=True, null=True, verbose_name='Quốc tịch')
    diachi = models.CharField(max_length=100, blank=True, null=True, verbose_name='Địa chỉ')
    donvi = models.ForeignKey(Donvi, models.DO_NOTHING, db_column='donvi', blank=True, null=True, verbose_name='Đơn vị')
    chinhanh = models.ForeignKey(Chinhanh, models.DO_NOTHING, db_column='chinhanh', blank=True, null=True, verbose_name='Chi nhánh')
    luong = models.FloatField(blank=True, null=True, verbose_name='Lương')
    congtac = models.BooleanField(blank=True, null=True, verbose_name='Công tác')
    tamnghi = models.BooleanField(blank=True, null=True, verbose_name='Tạm nghỉ')

    class Meta:
        managed = False
        db_table = 'thanhvien'

class Cutri(models.Model):
    ma_thanhvien = models.OneToOneField('Thanhvien', models.DO_NOTHING, db_column='ma_cutri', primary_key=True)
    hoten = models.CharField(max_length=50, blank=True, null=True, verbose_name='Họ và tên')
    gioitinh = models.CharField(max_length=3, blank=True, null=True, verbose_name='Giới tính')
    quequan = models.CharField(max_length=100, blank=True, null=True, verbose_name='Quê quán')
    namsinh = models.CharField(max_length=4, blank=True, null=True, verbose_name='Năm sinh')
    quoctich = models.CharField(max_length=20, blank=True, null=True, verbose_name='Quốc tịch')
    diachi = models.CharField(max_length=100, blank=True, null=True, verbose_name='Địa chỉ')
    donvi = models.ForeignKey(Donvi, models.DO_NOTHING, db_column='donvi', blank=True, null=True, verbose_name='Đơn vị')
    chinhanh = models.ForeignKey(Chinhanh, models.DO_NOTHING, db_column='chinhanh', blank=True, null=True, verbose_name='Chi nhánh')

    class Meta:
        managed = False
        db_table = 'cutri'

class Btc(models.Model):
    ma_btc = models.OneToOneField('Thanhvien', models.DO_NOTHING, db_column='ma_btc', primary_key=True)
    hoten = models.CharField(max_length=50, blank=True, null=True)
    namsinh = models.CharField(max_length=4, blank=True, null=True)
    gioitinh = models.CharField(max_length=3, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'btc'

class Giamsat(models.Model):
    ma_giamsat = models.OneToOneField('Thanhvien', models.DO_NOTHING, db_column='ma_giamsat', primary_key=True)
    hoten = models.CharField(max_length=50, blank=True, null=True)
    namsinh = models.CharField(max_length=4, blank=True, null=True)
    gioitinh = models.CharField(max_length=3, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'giamsat'

class Theodoi(models.Model):
    ma_theodoi = models.OneToOneField(Thanhvien, models.DO_NOTHING, db_column='ma_theodoi', primary_key=True)
    hoten = models.CharField(max_length=50, blank=True, null=True)
    namsinh = models.CharField(max_length=4, blank=True, null=True)
    gioitinh = models.CharField(max_length=3, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'theodoi'

class ToLap(models.Model):
    ma_tolap = models.OneToOneField(Thanhvien, models.DO_NOTHING, db_column='ma_tolap', primary_key=True)
    hoten = models.CharField(max_length=50, blank=True, null=True)
    namsinh = models.CharField(max_length=4, blank=True, null=True)
    gioitinh = models.CharField(max_length=3, blank=True, null=True)
    donvi = models.ForeignKey(Donvi, models.DO_NOTHING, db_column='donvi', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'to_lap'


class Ungcuvien(models.Model):
    ma_ucv = models.OneToOneField(Thanhvien, models.DO_NOTHING, db_column='ma_ucv', primary_key=True)
    hoten = models.CharField(max_length=50, blank=True, null=True)
    namsinh = models.CharField(max_length=4, blank=True, null=True)
    donvi = models.ForeignKey(Donvi, models.DO_NOTHING, db_column='donvi', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'ungcuvien'

class Roles(models.Model):
    role_id = models.IntegerField(primary_key=True, verbose_name='Mã quyền')
    role = models.CharField(max_length=128, verbose_name='Tên quyền')
    con_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'binhbau_roles'

class UserRole(models.Model):
    grantee = models.CharField(primary_key=True, max_length=128, verbose_name='Mã thành viên')
    granted_role = models.CharField(max_length=128, verbose_name='Quyền')
    admin_option = models.CharField(max_length=3)
    con_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'binhbau_user_roles'