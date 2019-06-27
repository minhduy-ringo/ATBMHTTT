from django import forms
from django.forms import ModelForm

from thanhvien.models import Ungcuvien

class ThemUcv(ModelForm):
    class Meta:
        model = Ungcuvien
        fields = ('ma_ucv',)

class ThemCutri(ModelForm):
    class Meta:
        model = Ungcuvien
        fields = ('ma_ucv',)