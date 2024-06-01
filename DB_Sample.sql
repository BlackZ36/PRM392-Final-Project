-- Sử dụng cơ sở dữ liệu master
USE master;
GO

-- Kiểm tra và xóa cơ sở dữ liệu ZStore_Sample nếu tồn tại
DROP DATABASE IF EXISTS ZStore_Sample;    
GO

-- Tạo cơ sở dữ liệu ZStore_Sample mới
CREATE DATABASE ZStore_Sample;
GO

USE ZStore_Sample;
GO

-- Bảng Account
CREATE TABLE Account (
    account_id NVARCHAR(8) PRIMARY KEY,
    first_name NVARCHAR(255),
    last_name NVARCHAR(255),
    email NVARCHAR(255),
    password_hash NVARCHAR(MAX),
    mobile NVARCHAR(20),
	status INT,
    last_login DATETIME
);

-- Bảng Permission
CREATE TABLE [Permission] (
    permission_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(255),
    content NVARCHAR(MAX)
);

-- Bảng AccountPermission 
CREATE TABLE AccountPermission (
    account_permission_id INT IDENTITY PRIMARY KEY,
    account_id NVARCHAR(8),
    permission_id INT,
    FOREIGN KEY (account_id) REFERENCES Account(account_id),
    FOREIGN KEY (permission_id) REFERENCES Permission(permission_id)
);

-- Bảng Category
CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    category_name NVARCHAR(255),
    category_type NVARCHAR(50) -- Chỉ chứa 2 dạng: 'Instock' hoặc 'Order'
);

-- Bảng SubCategory
CREATE TABLE SubCategory (
    subcategory_id INT PRIMARY KEY,
    subcategory_name NVARCHAR(255)
);

-- Bảng Variant
CREATE TABLE Variant (
    variant_id INT PRIMARY KEY,
    variant_name NVARCHAR(255)
);

-- Bảng VariantValue
CREATE TABLE VariantValue (
    value_id INT PRIMARY KEY,
    variant_id INT,
    value_name NVARCHAR(255),
    value_code NVARCHAR(50),
    FOREIGN KEY (variant_id) REFERENCES Variant(variant_id)
);

-- Bảng Product
CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    category_id INT,
    subcategory_id INT,
    product_name NVARCHAR(255),
    description NVARCHAR(MAX),
    sku NVARCHAR(50),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Category FOREIGN KEY (category_id) REFERENCES Category(category_id),
    CONSTRAINT FK_SubCategory FOREIGN KEY (subcategory_id) REFERENCES SubCategory(subcategory_id)
);

-- Bảng ProductVariant
CREATE TABLE ProductVariant (
    product_variant_id INT PRIMARY KEY,
    product_id INT,
    variant_id INT,
    value_id INT,
    quantity INT,
    price DECIMAL(10,2),
    weight DECIMAL(10,2),
    discount DECIMAL(10,2),
    sku NVARCHAR(50),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (variant_id) REFERENCES Variant(variant_id),
    FOREIGN KEY (value_id) REFERENCES VariantValue(value_id)
);

-- Bảng Order
CREATE TABLE [Order] (
    order_id NVARCHAR(8) PRIMARY KEY,
    account_id NVARCHAR(8),
    session_id NVARCHAR(255),
    token_id NVARCHAR(255),
    status INT,
    sub_price DECIMAL(10,2),
    total_discount DECIMAL(10,2),
    shipping DECIMAL(10,2),
    total_price DECIMAL(10,2),
    voucher NVARCHAR(10),
    first_name NVARCHAR(255),
    last_name NVARCHAR(255),
    mobile NVARCHAR(20),
    email NVARCHAR(255),
    address NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    update_by NVARCHAR(255),
    content NVARCHAR(MAX),
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

-- Bảng OrderDetail
CREATE TABLE [OrderDetail] (
    order_detail_id NVARCHAR(8) PRIMARY KEY,
    product_variant_id INT,
    order_id NVARCHAR(8),
    price DECIMAL(10,2),
    discount DECIMAL(10,2),
    quantity INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    updated_by NVARCHAR(255),
    content NVARCHAR(MAX),
    FOREIGN KEY (product_variant_id) REFERENCES ProductVariant(product_variant_id),
    FOREIGN KEY (order_id) REFERENCES [Order](order_id)
);

-- Bảng Transaction
CREATE TABLE [Transaction] (
    transaction_id INT PRIMARY KEY,
    account_id NVARCHAR(8),
    order_id NVARCHAR(8),
    code NVARCHAR(255),
    type INT,
    mode INT,
    status INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    content NVARCHAR(MAX),
    FOREIGN KEY (account_id) REFERENCES Account(account_id),
    FOREIGN KEY (order_id) REFERENCES [Order](order_id)
);

-- Bảng Cart
CREATE TABLE Cart (
    cart_id INT PRIMARY KEY,
    account_id NVARCHAR(8),
    session_id NVARCHAR(255),
    token_id NVARCHAR(255),
    item_count INT,
    total_discount DECIMAL(10,2),
    total_price DECIMAL(10,2),
    total_weight DECIMAL(10,2),
    status INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    content NVARCHAR(MAX),
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

-- Bảng CartItem
CREATE TABLE CartItem (
    item_id INT PRIMARY KEY,
    cart_id INT,
    product_variant_id INT,
    quantity INT,
    price DECIMAL(10,2),
    discount DECIMAL(10,2),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    FOREIGN KEY (product_variant_id) REFERENCES ProductVariant(product_variant_id)
);
