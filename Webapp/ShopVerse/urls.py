from django.urls import path
from django.urls import reverse
from . import views
from .views import *

urlpatterns = [
    path('', views.login_page, name='login_page'),  # Serve at root
    path('register/', views.register_page, name='register_page'),
    path('browse/', views.browse_page, name='browse_page'),
]