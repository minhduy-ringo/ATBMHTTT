from django.contrib import admin
from django.contrib.auth.models import Group

from .models import Thanhvien, Donvi, Chinhanh, UserRole, Roles

#
class ThanhVienAdmin(admin.ModelAdmin):
    list_display = ('ma_thanhvien', 'hoten')
    exclude = ('title',)

class UserRoleAdmin(admin.ModelAdmin):
    list_display = ('grantee', 'granted_role')
    ordering = ('grantee',)
    
    def has_add_permission(self, request):
        return False

class RolesAdmin(admin.ModelAdmin):
    list_display = ('role_id', 'role')
    ordering = ('role_id',)
    
    def has_add_permission(self, request):
        return False

# Thêm models vào admin
admin.site.site_header = 'Quản lý bình bầu'
admin.site.site_title = 'Trang chủ'
admin.site.index_title = 'Bình bầu'

admin.site.register(Thanhvien, ThanhVienAdmin)
admin.site.register(Donvi)
admin.site.register(Chinhanh)
admin.site.register(UserRole, UserRoleAdmin)
admin.site.register(Roles, RolesAdmin)

admin.site.unregister(Group)