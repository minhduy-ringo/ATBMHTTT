from django.db import models

class Chinhanh(models.Model):
    ma_chinhanh = models.CharField(primary_key=True, max_length=20)
    tenchinhanh = models.CharField(max_length=50, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'chinhanh'


class Donvi(models.Model):
    ma_donvi = models.CharField(primary_key=True, max_length=20)
    tendonvi = models.CharField(max_length=50, blank=True, null=True)
    truongdonvi = models.ForeignKey('Thanhvien', models.DO_NOTHING, related_name='+', db_column='truongdonvi', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'donvi'

class Thanhvien(models.Model):
    ma_thanhvien = models.AutoField(primary_key=True, blank=True, editable=False)
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