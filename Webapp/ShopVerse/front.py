from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.db import IntegrityError, connection
from django.urls import *
from django.contrib import messages

from django.contrib.auth import authenticate, login
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.hashers import check_password




def browse_view(request):
    # Retrieve the selected category and subcategory names from the form
    selected_category = request.POST.get('selected_category')
    selected_subcategory = request.POST.get('selected_subcategory')
    
    if not selected_category and not selected_subcategory:
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM Products")  # Get all products
                products = cursor.fetchall()
                print(f"Products found: {products}")
        except Exception as e:
            messages.error(request, f"An error occurred: {str(e)}")
    
    else:
        if selected_category:
            selected_category = selected_category.capitalize()

        if selected_subcategory:
            selected_subcategory = selected_subcategory.capitalize()
        
        print(f"Selected Category: {selected_category}")
        print(f"Selected Subcategory: {selected_subcategory}")
        
        try:
            with connection.cursor() as cursor:
                # Get the CategoryID using the CategoryName
                cursor.execute("""SELECT CategoryID FROM Category WHERE CategoryName = %s""", [selected_category])
                category_id = cursor.fetchone()
                
                if not category_id:
                    messages.error(request, f"Category '{selected_category}' not found.")
                    return render(request, 'browse.html', {'products': []})
                
                # Get the SubCategoryID using the SubCategoryName and CategoryID
                cursor.execute("""SELECT SubCategoryID FROM SubCategory
                                WHERE SubCategoryName = %s AND CategoryID = %s""",
                            [selected_subcategory, category_id[0]])  # category_id[0] is the actual CategoryID
                
                subcategory_id = cursor.fetchone()
                
                if not subcategory_id:
                    messages.error(request, f"Subcategory '{selected_subcategory}' not found under '{selected_category}' category.")
                    return render(request, 'browse.html', {'products': []})
                
                print(f"CategoryID: {category_id[0]}, SubCategoryID: {subcategory_id[0]}")
                
                # Now that we have both CategoryID and SubCategoryID, get the products
                cursor.execute("""SELECT * FROM Products
                                WHERE CategoryID = %s AND SubCategoryID = %s""",
                            [category_id[0], subcategory_id[0]])  # category_id[0] and subcategory_id[0] are the values
                
                products = cursor.fetchall()  # Use fetchall() to get all rows
                
                print(f"Products found: {products}")
                
        except Exception as e:
            messages.error(request, f"An error occurred: {str(e)}")
            return render(request, 'browse.html', {'products': []})
    
    # Render the page with the list of products
    return render(request, 'browse.html', {
        'products': products,
        'selected_category': selected_category,
        'selected_subcategory': selected_subcategory
})


def login_view(request):
    if request.method == 'POST':
        username_try = request.POST.get('email')
        password_try = request.POST.get('password')
        
        
        try:
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT UserID, name, email, password, role, store_name 
                    FROM [USER] 
                    WHERE email = %s AND password = %s
                """, [username_try, password_try])
                row = cursor.fetchone()
                
            if row:
                UserID, name, email , password, role, store_name = row
                return redirect('browse_page')
            else:
                messages.error(request, "Invalid username or password. Please try again.")
        
        except Exception as e:
            messages.error(request, f"An error occurred: {str(e)}")
    
    return render(request, 'background_template.html')

def register_view(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        email = request.POST.get('email')
        store_name = request.POST.get('store_name')
        password = request.POST.get('password')
        cpassword = request.POST.get('confirm_password')
        if password != cpassword:
            messages.error(request, "Passwords do not match. Please try again.")
            return redirect('register_page')
        store_name = request.POST.get('store_name')
        role = request.POST.get('account_type')

        try:
            with connection.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO [USER] (name, email, password, role, store_name) 
                    VALUES (%s, %s, %s, %s, %s)
                """, [name, email, password, role, store_name])
            messages.success(request, "Registration successful!")
            return redirect('login_page')
        
        except IntegrityError:
            messages.error(request, "Email already exists. Please try again.")
        
        except Exception as e:
            messages.error(request, f"An error occurred: {str(e)}")
    
    return render(request, 'register.html')
