# # This is an auto-generated Django model module.
# # You'll have to do the following manually to clean this up:
# #   * Rearrange models' order
# #   * Make sure each model has one field with primary_key=True
# #   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
# #   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# # Feel free to rename the models, but don't rename db_table values or field names.
# from django.db import models


# class Btc(models.Model):
#     ma_btc = models.ForeignKey('Thanhvien', models.DO_NOTHING, db_column='ma_btc', primary_key=True)
#     hoten = models.CharField(max_length=50, blank=True, null=True)
#     namsinh = models.CharField(max_length=4, blank=True, null=True)
#     gioitinh = models.CharField(max_length=3, blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'btc'


# class Chinhanh(models.Model):
#     ma_chinhanh = models.CharField(primary_key=True, max_length=20)
#     tenchinhanh = models.CharField(max_length=50, blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'chinhanh'


# class Donvi(models.Model):
#     ma_donvi = models.CharField(primary_key=True, max_length=20)
#     tendonvi = models.CharField(max_length=50, blank=True, null=True)
#     truongdonvi = models.ForeignKey('Thanhvien', models.DO_NOTHING, db_column='truongdonvi', blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'donvi'


# class Giamsat(models.Model):
#     ma_giamsat = models.ForeignKey('Thanhvien', models.DO_NOTHING, db_column='ma_giamsat', primary_key=True)
#     hoten = models.CharField(max_length=50, blank=True, null=True)
#     namsinh = models.CharField(max_length=4, blank=True, null=True)
#     gioitinh = models.CharField(max_length=3, blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'giamsat'


# class Phieubau(models.Model):
#     ma_phieubau = models.FloatField(primary_key=True)
#     ma_thanhvien = models.ForeignKey('Thanhvien', models.DO_NOTHING, db_column='ma_thanhvien')
#     ucv1 = models.FloatField(blank=True, null=True)
#     ucv2 = models.FloatField(blank=True, null=True)
#     ucv3 = models.FloatField(blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'phieubau'
#         unique_together = (('ma_phieubau', 'ma_thanhvien'),)


# class Thanhvien(models.Model):
#     ma_thanhvien = models.FloatField(primary_key=True)
#     hoten = models.CharField(max_length=50, blank=True, null=True)
#     gioitinh = models.CharField(max_length=3, blank=True, null=True)
#     quequan = models.CharField(max_length=100, blank=True, null=True)
#     namsinh = models.CharField(max_length=4, blank=True, null=True)
#     quoctich = models.CharField(max_length=20, blank=True, null=True)
#     diachi = models.CharField(max_length=100, blank=True, null=True)
#     donvi = models.ForeignKey(Donvi, models.DO_NOTHING, db_column='donvi', blank=True, null=True)
#     chinhanh = models.ForeignKey(Chinhanh, models.DO_NOTHING, db_column='chinhanh', blank=True, null=True)
#     luong = models.FloatField(blank=True, null=True)
#     congtac = models.BooleanField(blank=True, null=True)
#     tamnghi = models.BooleanField(blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'thanhvien'


# class Theodoi(models.Model):
#     ma_theodoi = models.ForeignKey(Thanhvien, models.DO_NOTHING, db_column='ma_theodoi', primary_key=True)
#     hoten = models.CharField(max_length=50, blank=True, null=True)
#     namsinh = models.CharField(max_length=4, blank=True, null=True)
#     gioitinh = models.CharField(max_length=3, blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'theodoi'


# class Thongbao(models.Model):
#     ma_noidung = models.CharField(primary_key=True, max_length=20)
#     noidung = models.CharField(max_length=100, blank=True, null=True)
#     loaitb = models.CharField(max_length=4, blank=True, null=True)
#     column_ols = models.CharField(max_length=3, blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'thongbao'


# class ToLap(models.Model):
#     ma_tolap = models.ForeignKey(Thanhvien, models.DO_NOTHING, db_column='ma_tolap', primary_key=True)
#     hoten = models.CharField(max_length=50, blank=True, null=True)
#     namsinh = models.CharField(max_length=4, blank=True, null=True)
#     gioitinh = models.CharField(max_length=3, blank=True, null=True)
#     donvi = models.ForeignKey(Donvi, models.DO_NOTHING, db_column='donvi', blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'to_lap'


# class Ungcuvien(models.Model):
#     ma_ucv = models.ForeignKey(Thanhvien, models.DO_NOTHING, db_column='ma_ucv', primary_key=True)
#     hoten = models.CharField(max_length=50, blank=True, null=True)
#     namsinh = models.CharField(max_length=4, blank=True, null=True)
#     chucvu = models.CharField(max_length=50, blank=True, null=True)
#     donvi = models.ForeignKey(Donvi, models.DO_NOTHING, db_column='donvi', blank=True, null=True)

#     class Meta:
#         managed = False
#         db_table = 'ungcuvien'
