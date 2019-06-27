from django.shortcuts import render

# General display view
from django.views.generic import ListView, DetailView  
# General edit view include add, delete and update.
from django.views.generic.edit import CreateView, DeleteView, UpdateView  

from thanhvien.models import *
from . import forms

# Create your views here.
def home_btc(request):
    thanhvien_list = Thanhvien.objects.all()
    ungcuvien_list = Ungcuvien.objects.all()

    fm=forms.ThemUcv()
    if request.method == 'POST':
        fm=forms.ThemUcv(request.POST)
    if fm.is_valid():
            ucv = fm.save(commit=False)
            tv = Thanhvien.objects.get(pk=ucv.ma_ucv.ma_thanhvien)
            ucv.hoten = tv.hoten
            ucv.namsinh = tv.namsinh
            ucv.donvi = tv.donvi
            ucv.save()

    context = {
        'thanhvien_list': thanhvien_list,
        'ungcuvien_list': ungcuvien_list,
        'form': fm,
    }
    return render(request, 'btc/btc.html', context)

def home_tolap(request):
    return None

def home_giamsat():
    return None

