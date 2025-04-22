-- Step 1: Disable foreign key constraints by dropping them
DECLARE @table_name NVARCHAR(255);
DECLARE @constraint_name NVARCHAR(255);

DECLARE constraints_cursor CURSOR FOR
SELECT t.name, fk.name
FROM sys.tables t
JOIN sys.foreign_keys fk ON fk.parent_object_id = t.object_id;

OPEN constraints_cursor;
FETCH NEXT FROM constraints_cursor INTO @table_name, @constraint_name;

-- Loop through and drop foreign key constraints
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('ALTER TABLE ' + @table_name + ' DROP CONSTRAINT ' + @constraint_name);
    FETCH NEXT FROM constraints_cursor INTO @table_name, @constraint_name;
END;

CLOSE constraints_cursor;
DEALLOCATE constraints_cursor;

-- Step 2: Drop all tables
EXEC sp_MSforeachtable "DROP TABLE ?";

CREATE TABLE [User] (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    role NVARCHAR(50) NOT NULL,
    store_name NVARCHAR(255) NULL
);

INSERT INTO [User] (name, email, password, role, store_name)
VALUES
('John Doe', 'john.doe@example.com', 'password123', 'user', 'John Store'),
('Jane Smith', 'jane.smith@example.com', 'securepass456', 'user', 'Janes Boutique'),
('Alice Brown', 'alice.brown@example.com', 'alicepassword789', 'user', 'Alices Shop'),
('Bob White', 'bob.white@example.com', 'bobpass101', 'seller', 'Bob Electronics')

-- Create Category Table
CREATE TABLE [Category] (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(255) NOT NULL
);

-- Create SubCategory Table
CREATE TABLE [SubCategory] (
    SubCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    SubCategoryName NVARCHAR(255) NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- Create Product Table
CREATE TABLE [Products] (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    SellerID INT,
    CategoryID INT,
    SubCategoryID INT,
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(255) NOT NULL,
    Price INT NOT NULL,
	Image NVARCHAR(500) NOT NULL,
    FOREIGN KEY (SellerID) REFERENCES [User](UserID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (SubCategoryID) REFERENCES SubCategory(SubCategoryID)
);


-- Insert into Category
INSERT INTO Category (CategoryName)
VALUES ('Fashion');

-- Insert Subcategories for Fashion (SubCategoryID starts from 1 for 'Shoes')
INSERT INTO SubCategory (SubCategoryName, CategoryID)
VALUES 
    ('Shoes', 1),        -- SubCategoryID = 1
    ('Clothes', 1),      -- SubCategoryID = 2
    ('Accessories', 1),  -- SubCategoryID = 3
    ('Bags', 1);         -- SubCategoryID = 4

-- Insert Dummy Products for Fashion Category
INSERT INTO Products (SellerID, CategoryID, SubCategoryID, Name, Description, Price, Image)
VALUES
    (1, 1, 1, 'Nike Running Shoes', 'Comfortable shoes for running', 120, 'nike_shoes.png'),
    (2, 1, 2, 'Leather Jacket', 'Stylish leather jacket for winter', 150, 'jacket.png'),
    (3, 1, 3, 'Sunglasses', 'Stylish sunglasses for summer', 30, 'sunglass.png'),
    (4, 1, 4, 'Designer Handbag', 'Elegant handbag for casual use', 200, 'handbag.png');

-- Insert into Category for Electronics
INSERT INTO Category (CategoryName)
VALUES ('Electronics');

-- Insert Subcategories for Electronics (SubCategoryID starts from 5 for 'Phones')
INSERT INTO SubCategory (SubCategoryName, CategoryID)
VALUES 
    ('Phones', 2),        -- SubCategoryID = 5
    ('Laptops', 2),       -- SubCategoryID = 6
    ('Audio', 2),         -- SubCategoryID = 7
    ('Accessories', 2);   -- SubCategoryID = 8

-- Insert Dummy Products for Electronics Category
INSERT INTO Products (SellerID, CategoryID, SubCategoryID, Name, Description, Price, Image)
VALUES
    (1, 2, 5, 'iPhone 13', 'Latest model of iPhone with 128GB storage', 999, 'iphone.png'),
    (2, 2, 6, 'Dell XPS 13', 'High performance laptop with 16GB RAM', 1200, 'dell.png'),
    (3, 2, 7, 'Sony Headphones', 'Noise-cancelling headphones for music lovers', 150, 'sony.png'),
    (4, 2, 8, 'Phone Case', 'Protective phone case for iPhone 13', 30, 'case.png');

-- Insert into Category for Home & Living
INSERT INTO Category (CategoryName)
VALUES ('Home');

-- Insert Subcategories for Home & Living (SubCategoryID starts from 9 for 'Furniture')
INSERT INTO SubCategory (SubCategoryName, CategoryID)
VALUES 
    ('Furniture', 3),      -- SubCategoryID = 9
    ('Decor', 3),          -- SubCategoryID = 10
    ('Bedding', 3),        -- SubCategoryID = 11
    ('Lighting', 3);       -- SubCategoryID = 12

-- Insert Dummy Products for Home & Living Category
INSERT INTO Products (SellerID, CategoryID, SubCategoryID, Name, Description, Price, Image)
VALUES
    (1, 3, 9, 'Sofa Set', 'Elegant sofa set for living room', 500, 'sofa.png'),
    (2, 3, 10, 'Wall Art', 'Beautiful decor piece for the living room wall', 120, 'art.png'),
    (3, 3, 11, 'Comforter Set', 'Luxurious bedding set for your bedroom', 80, 'comfort.png'),
    (4, 3, 12, 'LED Lamp', 'Modern LED lamp with adjustable brightness', 40, 'led.png');

-- Insert into Category for Kitchen
INSERT INTO Category (CategoryName)
VALUES ('Kitchen');

-- Insert Subcategories for Kitchen (SubCategoryID starts from 13 for 'Appliances')
INSERT INTO SubCategory (SubCategoryName, CategoryID)
VALUES 
    ('Appliances', 4),     -- SubCategoryID = 13
    ('Cookware', 4),       -- SubCategoryID = 14
    ('Tableware', 4),      -- SubCategoryID = 15
    ('Utensils', 4);       -- SubCategoryID = 16

-- Insert Dummy Products for Kitchen Category
INSERT INTO Products (SellerID, CategoryID, SubCategoryID, Name, Description, Price, Image)
VALUES
    (1, 4, 13, 'Blender', 'High-speed blender for smoothies', 60, 'blend.png'),
    (2, 4, 14, 'Cookware Set', 'Complete cookware set for everyday cooking', 150, 'cookset.png'),
    (3, 4, 15, 'Dinner Plates', 'Elegant dinner plates for family meals', 30, 'plates.png'),
    (4, 4, 16, 'Cooking Utensils Set', 'Set of premium cooking utensils for your kitchen', 25, 'uten.png');

CREATE TABLE coupons (
    coupon_id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL,
    valid_from DATETIME NOT NULL,
    valid_to DATETIME NOT NULL,
    is_active BIT NOT NULL
);

CREATE TABLE discount_offers (
    discount_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    discount_percentage DECIMAL(5,2) NOT NULL,
    valid_from DATETIME NOT NULL,
    valid_to DATETIME NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(ProductID)
);

CREATE TABLE product_images (
    image_id INT IDENTITY (1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(ProductID)
);

CREATE TABLE payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(45) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);



CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    coupon_id INT,
    order_status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    shipping_city VARCHAR(100) NOT NULL,
    shipping_state VARCHAR(100) NOT NULL,
    shipping_zip VARCHAR(20) NOT NULL,
    shipping_country VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES [User](UserID),
    FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id)
);


CREATE TABLE reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT NOT NULL,
    review_text TEXT,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(ProductID),
    FOREIGN KEY (customer_id) REFERENCES [User](UserID)
);