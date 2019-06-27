from django.urls import path
from . import views

urlpatterns = [
    path('btc/', views.home_btc, name='quanly_btc'),
    path('tolap/', views.home_tolap, name='quanly_tolap'),
    path('giamsat/',views.home_giamsat,name='quanly_giamsat')
]