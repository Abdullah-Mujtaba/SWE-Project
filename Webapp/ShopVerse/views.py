from django.shortcuts import render, redirect
from django.contrib import messages
from datetime import datetime
from django.shortcuts import get_object_or_404, redirect
from django.http import HttpResponseRedirect, HttpResponse, HttpResponseNotFound
from django.views.generic import ListView, TemplateView, FormView, DeleteView, View
from django.urls import reverse_lazy
from django.db import IntegrityError
from .front import *

def login_page(request):
    return login_view(request)

def register_page(request):
    return register_view(request)

def browse_page(request):
    return browse_view(request)

def seller_page(request,id):
    return seller_view(request,id)

def add_product(request):
    return add_product_view(request)