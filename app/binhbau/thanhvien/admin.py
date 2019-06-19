from django.contrib import admin

from .models import Thanhvien, Donvi, Chinhanh

# Thêm models vào admin
admin.site.register(Thanhvien)
admin.site.register(Donvi)
admin.site.register(Chinhanh)