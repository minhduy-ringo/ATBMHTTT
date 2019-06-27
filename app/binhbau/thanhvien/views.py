from django.contrib.auth import login
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect

from thanhvien.models import UserRole
from thanhvien.auth import OracleAuthBackend

@login_required
def user_redirect(request):
    current_user = request.user

    # Nếu là superuser login vào trang admin
    if current_user.username == 'QUANTRI':
        return redirect('/admin/')

    role = UserRole.objects.get(grantee=current_user.username)
    if role.granted_role == 'NHANVIEN':
        return redirect('/nhanvien/home/')
    if role.granted_role == 'BTC':
        return redirect('/quanly/btc/')

def home(request):
    return render(request, 'thanhvien/nhanvien.html')
