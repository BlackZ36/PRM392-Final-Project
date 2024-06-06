-- Sử dụng cơ sở dữ liệu master
USE master;
GO

-- Ngắt tất cả các kết nối đang sử dụng đến cơ sở dữ liệu ZStore_Sample
ALTER DATABASE ZStore_Sample SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Kiểm tra và xóa cơ sở dữ liệu ZStore_Sample nếu tồn tại
DROP DATABASE IF EXISTS ZStore_Sample;    
GO

-- Tạo cơ sở dữ liệu ZStore_Sample mới
CREATE DATABASE ZStore_Sample;
GO

USE ZStore_Sample;
GO

-- Table: Address
CREATE TABLE Address (
    address_id INT IDENTITY PRIMARY KEY, -- Primary key
    account_id INT, -- Foreign key to Account table
    country NVARCHAR(255), -- Country
    province NVARCHAR(255), -- Province
    district NVARCHAR(255), -- District
    ward NVARCHAR(255), -- Ward
    zip NVARCHAR(50), -- Zip code
    detail VARCHAR(255) -- Detailed address
);
-- Address table containing addresses related to accounts

-- Table: Account
CREATE TABLE Account (
    account_id INT IDENTITY PRIMARY KEY, -- Primary key
    first_name NVARCHAR(255), -- First name
    last_name NVARCHAR(255), -- Last name
    email NVARCHAR(255) UNIQUE, -- Email
    password_hash NVARCHAR(32), -- Password hash
    mobile NVARCHAR(20) UNIQUE, -- Mobile number
    status INT, -- Account status
    last_login DATETIME, -- Last login datetime
    registered_at DATETIME, -- Registration datetime
    default_address_id INT -- Foreign key to Address table
);
-- Account table containing user account details

-- Table: Permission
CREATE TABLE Permission (
    permission_id INT IDENTITY PRIMARY KEY, -- Primary key
    name NVARCHAR(255), -- Permission name
    description NVARCHAR(255), -- Description
    status INT, -- Status
    created_at DATETIME, -- Creation datetime
    updated_at DATETIME -- Last update datetime
);
-- Permission table containing permission details

-- Table: RolePermission
CREATE TABLE RolePermission (
    role_permission_id INT IDENTITY PRIMARY KEY, -- Primary key
    role_id INT, -- Foreign key to Role table
    permission_id INT -- Foreign key to Permission table
);
-- RolePermission table containing mappings between roles and permissions

-- Table: AccountRole
CREATE TABLE AccountRole (
    account_role_id INT IDENTITY PRIMARY KEY, -- Primary key
    account_id INT, -- Foreign key to Account table
    role_id INT -- Foreign key to Role table
);
-- AccountRole table containing mappings between accounts and roles

-- Table: Role
CREATE TABLE Role (
    role_id INT IDENTITY PRIMARY KEY, -- Primary key
    name NVARCHAR(255), -- Role name
    description NVARCHAR(255), -- Description
    status INT -- Status
);
-- Role table containing role details

-- Table: Category
CREATE TABLE category (
    category_id INT IDENTITY PRIMARY KEY, -- Primary key
    parent_category_id INT DEFAULT NULL, -- Foreign key to self
    title VARCHAR(255) DEFAULT 'Default Category Title', -- Title
    metaTitle VARCHAR(255) DEFAULT 'Default Category Meta Title', -- Meta title
    content TEXT DEFAULT 'Default Category Content', -- Content
    slug VARCHAR(255) DEFAULT '/default-category-slug', -- Slug
    sku VARCHAR(255) DEFAULT 'DEFAULTCATEGORY', -- SKU
    status INT DEFAULT 1,
	[order] int DEFAULT 0, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE()-- Last update datetime
);
-- Category table containing product categories

-- Table: ProductType
CREATE TABLE productType (
    product_type_id INT IDENTITY PRIMARY KEY, -- Primary key
    title VARCHAR(255), -- Title
    metaTitle VARCHAR(255), -- Meta title
    content TEXT, -- Content
    slug VARCHAR(255), -- Slug
    sku VARCHAR(255), -- SKU
    status INT, -- Status
    created_at DATETIME, -- Creation datetime
    updated_at DATETIME -- Last update datetime
);
-- ProductType table containing product types

-- Table: Vendor
CREATE TABLE vendor (
    vendor_id INT IDENTITY PRIMARY KEY, -- Primary key
    title VARCHAR(255), -- Title
    metaTitle VARCHAR(255), -- Meta title
    content TEXT, -- Content
    slug VARCHAR(255), -- Slug
    sku VARCHAR(255), -- SKU
    status INT, -- Status
    created_at TIMESTAMP, -- Creation timestamp
    updated_at DATETIME -- Last update datetime
);
-- Vendor table containing vendor details

-- Table: Product
CREATE TABLE product (
    product_id INT IDENTITY PRIMARY KEY, -- Primary key
    category_id INT, -- Foreign key to Category table
    type_id INT, -- Foreign key to ProductType table
    vendor_id INT, -- Foreign key to Vendor table
    title VARCHAR(255), -- Title
    metaTitle VARCHAR(255), -- Meta title
    content TEXT, -- Content
    slug VARCHAR(255), -- Slug
    sku VARCHAR(255), -- SKU
    status INT, -- Status
    created_at DATETIME, -- Creation datetime
    updated_at DATETIME -- Last update datetime
);
-- Product table containing product details

-- Table: Item
CREATE TABLE item (
    item_id INT IDENTITY PRIMARY KEY, -- Primary key
    product_id INT, -- Foreign key to Product table
    title VARCHAR(255), -- Title
    metaTitle VARCHAR(255), -- Meta title
    content TEXT, -- Content
    slug VARCHAR(255), -- Slug
    sku VARCHAR(255), -- SKU
    status INT, -- Status
    created_at DATETIME, -- Creation datetime
    updated_at DATETIME -- Last update datetime
);
-- Item table containing items related to products

-- Table: Variant
CREATE TABLE variant (
    variant_id INT IDENTITY PRIMARY KEY, -- Primary key
    title VARCHAR(255), -- Title
    content TEXT, -- Content
    status INT, -- Status
    created_at DATETIME, -- Creation datetime
    updated_at DATETIME -- Last update datetime
);
-- Variant table containing variant details

-- Table: VariantValue
CREATE TABLE variant_value (
    variant_value_id INT IDENTITY PRIMARY KEY, -- Primary key
    variant_id INT, -- Foreign key to Variant table
    item_id INT, -- Foreign key to Item table
    value VARCHAR(255), -- Value
    img_url_id INT -- Image URL ID
);
-- VariantValue table containing values for variants

-- Table: ItemVariant
CREATE TABLE item_variant (
    item_variant_id INT IDENTITY PRIMARY KEY, -- Primary key
    item_id INT, -- Foreign key to Item table
    variant_id INT -- Foreign key to Variant table
);
-- ItemVariant table containing mappings between items and variants

-- Table: ItemInventory
CREATE TABLE item_inventory (
    inventory_id INT IDENTITY PRIMARY KEY, -- Primary key
    item_id INT, -- Foreign key to Item table
    variant_combination VARCHAR(255), -- Variant combination
    quantity INT, -- Quantity
    discount INT, -- Discount
    price MONEY, -- Price
    status INT, -- Status
    created_at DATETIME, -- Creation datetime
    updated_at DATETIME -- Last update datetime
);
-- ItemInventory table containing inventory details for items

-- Table: RefreshToken
CREATE TABLE refresh_token (
    token_id INT IDENTITY PRIMARY KEY, -- Primary key
    account_id INT, -- Foreign key to Account table
    token UNIQUEIDENTIFIER, -- Token
    type_id INT, -- Foreign key to TokenType table
    created_at DATETIME, -- Creation datetime
    expires_at DATETIME, -- Expiration datetime
    status INT -- Status
);
-- RefreshToken table containing refresh tokens

-- Table: TokenType
CREATE TABLE token_type (
    token_type_id INT IDENTITY PRIMARY KEY, -- Primary key
    title NVARCHAR(50) -- Title
);
-- TokenType table containing token types

-- Table: AuditLog
CREATE TABLE audit_log (
    log_id INT IDENTITY PRIMARY KEY, -- Primary key
    account_id INT, -- Foreign key to Account table
    action VARCHAR(255), -- Action
    entity VARCHAR(255), -- Entity
    entity_id INT, -- Entity ID
    content TEXT, -- Content
    created_at DATETIME, -- Creation datetime
    ip_address VARCHAR(255), -- IP address
    user_agent VARCHAR(255) -- User agent
);
-- AuditLog table containing logs of actions

-- Table: Voucher
CREATE TABLE voucher (
    voucher_id INT IDENTITY PRIMARY KEY, -- Primary key
    code VARCHAR(255), -- Voucher code
    discount INT, -- Discount amount
    type VARCHAR(255), -- Voucher type
    created_at DATETIME, -- Creation datetime
    expires_at DATETIME, -- Expiration datetime
    status INT, -- Status
    usage_limit INT, -- Usage limit
    used_count INT -- Used count
);
-- Voucher table containing voucher details

-- Reseed id
DBCC CHECKIDENT ('Address', RESEED, 100000);
DBCC CHECKIDENT ('Account', RESEED, 100000);
DBCC CHECKIDENT ('Permission', RESEED, 100000);
DBCC CHECKIDENT ('RolePermission', RESEED, 100000);
DBCC CHECKIDENT ('AccountRole', RESEED, 100000);
DBCC CHECKIDENT ('Role', RESEED, 100000);
DBCC CHECKIDENT ('category', RESEED, 100000);
DBCC CHECKIDENT ('productType', RESEED, 100000);
DBCC CHECKIDENT ('vendor', RESEED, 100000);
DBCC CHECKIDENT ('product', RESEED, 100000);
DBCC CHECKIDENT ('item', RESEED, 100000);
DBCC CHECKIDENT ('variant', RESEED, 100000);
DBCC CHECKIDENT ('variant_value', RESEED, 100000);
DBCC CHECKIDENT ('item_variant', RESEED, 100000);
DBCC CHECKIDENT ('item_inventory', RESEED, 100000);
DBCC CHECKIDENT ('refresh_token', RESEED, 100000);
DBCC CHECKIDENT ('token_type', RESEED, 100000);
DBCC CHECKIDENT ('audit_log', RESEED, 100000);
DBCC CHECKIDENT ('voucher', RESEED, 100000);

-- Add foreign key constraints
ALTER TABLE Address
ADD CONSTRAINT FK_Address_Account FOREIGN KEY (account_id) REFERENCES Account(account_id);

ALTER TABLE Account
ADD CONSTRAINT FK_Account_Address FOREIGN KEY (default_address_id) REFERENCES Address(address_id);

ALTER TABLE RolePermission
ADD CONSTRAINT FK_RolePermission_Role FOREIGN KEY (role_id) REFERENCES Role(role_id);

ALTER TABLE RolePermission
ADD CONSTRAINT FK_RolePermission_Permission FOREIGN KEY (permission_id) REFERENCES Permission(permission_id);

ALTER TABLE AccountRole
ADD CONSTRAINT FK_AccountRole_Account FOREIGN KEY (account_id) REFERENCES Account(account_id);
ALTER TABLE AccountRole
ADD CONSTRAINT FK_AccountRole_Role FOREIGN KEY (role_id) REFERENCES Role(role_id);

ALTER TABLE category
ADD CONSTRAINT FK_Category_ParentCategory FOREIGN KEY (parent_category_id) REFERENCES category(category_id);

ALTER TABLE product
ADD CONSTRAINT FK_Product_Category FOREIGN KEY (category_id) REFERENCES category(category_id);
ALTER TABLE product
ADD CONSTRAINT FK_Product_ProductType FOREIGN KEY (type_id) REFERENCES productType(product_type_id);
ALTER TABLE product
ADD CONSTRAINT FK_Product_Vendor FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id);

ALTER TABLE item
ADD CONSTRAINT FK_Item_Product FOREIGN KEY (product_id) REFERENCES product(product_id);

ALTER TABLE variant_value
ADD CONSTRAINT FK_VariantValue_Variant FOREIGN KEY (variant_id) REFERENCES variant(variant_id);
ALTER TABLE variant_value
ADD CONSTRAINT FK_VariantValue_Item FOREIGN KEY (item_id) REFERENCES item(item_id);

ALTER TABLE item_variant
ADD CONSTRAINT FK_ItemVariant_Item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE item_variant
ADD CONSTRAINT FK_ItemVariant_Variant FOREIGN KEY (variant_id) REFERENCES variant(variant_id);

ALTER TABLE item_inventory
ADD CONSTRAINT FK_ItemInventory_Item FOREIGN KEY (item_id) REFERENCES item(item_id);

ALTER TABLE refresh_token
ADD CONSTRAINT FK_RefreshToken_Account FOREIGN KEY (account_id) REFERENCES Account(account_id);
ALTER TABLE refresh_token
ADD CONSTRAINT FK_RefreshToken_TokenType FOREIGN KEY (type_id) REFERENCES token_type(token_type_id);

ALTER TABLE audit_log
ADD CONSTRAINT FK_AuditLog_Account FOREIGN KEY (account_id) REFERENCES Account(account_id);



-- Thêm dữ liệu vào bảng
INSERT INTO category (title)
VALUES
    ('Category 1'),
    ('Category 2'),
    ('Category 3'),

