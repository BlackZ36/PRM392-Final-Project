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
CREATE TABLE [Address] (
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
CREATE TABLE [Account] (
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
CREATE TABLE [Permission] (
    permission_id INT IDENTITY PRIMARY KEY, -- Primary key
    name NVARCHAR(255), -- Permission name
    description NVARCHAR(255), -- Description
    status INT, -- Status
    created_at DATETIME, -- Creation datetime
    updated_at DATETIME -- Last update datetime
);
-- Permission table containing permission details

-- Table: RolePermission
CREATE TABLE [RolePermission] (
    role_permission_id INT IDENTITY PRIMARY KEY, -- Primary key
    role_id INT, -- Foreign key to Role table
    permission_id INT -- Foreign key to Permission table
);
-- RolePermission table containing mappings between roles and permissions

-- Table: AccountRole
CREATE TABLE [AccountRole] (
    account_role_id INT IDENTITY PRIMARY KEY, -- Primary key
    account_id INT, -- Foreign key to Account table
    role_id INT -- Foreign key to Role table
);
-- AccountRole table containing mappings between accounts and roles

-- Table: Role
CREATE TABLE [Role] (
    role_id INT IDENTITY PRIMARY KEY, -- Primary key
    title NVARCHAR(255), -- Role name
    content NVARCHAR(255), -- Description
    status INT -- Status
);
-- Role table containing role details

-- Table: Category
CREATE TABLE [category] (
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
CREATE TABLE [productType] (
    product_type_id INT IDENTITY PRIMARY KEY, -- Primary key
    title VARCHAR(255) DEFAULT 'Default Product Type Title', -- Title
    metaTitle VARCHAR(255) DEFAULT 'Default Product Type Meta Title', -- Meta title
    content TEXT DEFAULT 'Default Product Type Description', -- Content
    slug VARCHAR(255) DEFAULT '/type/default-product-type', -- Slug
    sku VARCHAR(255) DEFAULT 'PT', -- SKU
	[order] int DEFAULT NULL,
    status INT DEFAULT 1, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE() -- Last update datetime
);
-- ProductType table containing product types

-- Table: Vendor
CREATE TABLE [vendor] (
    vendor_id INT IDENTITY PRIMARY KEY, -- Primary key
    title VARCHAR(255) DEFAULT 'Default Vendor Title', -- Title
    content TEXT DEFAULT 'Default Vendor Description', -- Content
    sku VARCHAR(255) DEFAULT 'VD', -- SKU
	[order] int DEFAULT NULL, --order sort of vendor
    status INT DEFAULT 1, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation timestamp
    updated_at DATETIME DEFAULT GETDATE() -- Last update datetime
);
-- Vendor table containing vendor details

-- Table: Product
CREATE TABLE [product] (
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
CREATE TABLE [Item] (
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
CREATE TABLE [variant] (
    variant_id INT IDENTITY PRIMARY KEY, -- Primary key
    title VARCHAR(255) DEFAULT 'Default Variant Title', -- Title
    content TEXT DEFAULT 'Default Variant Content', -- Content
    status INT DEFAULT 1, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE()-- Last update datetime
);
-- Variant table containing variant details

-- Table: VariantValue
CREATE TABLE [variantValue] (
    variant_value_id INT IDENTITY PRIMARY KEY, -- Primary key
    variant_id INT, -- Foreign key to Variant table
    item_id INT, -- Foreign key to Item table
    value VARCHAR(255), -- Value
    img_url_id INT -- Image URL ID
);
-- VariantValue table containing values for variants

-- Table: ItemVariant
CREATE TABLE [ItemVariant] (
    item_variant_id INT IDENTITY PRIMARY KEY, -- Primary key
    item_id INT, -- Foreign key to Item table
    variant_id INT -- Foreign key to Variant table
);
-- ItemVariant table containing mappings between items and variants

-- Table: ItemInventory
CREATE TABLE [itemInventory] (
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
CREATE TABLE [refreshToken] (
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
CREATE TABLE [tokenType] (
    token_type_id INT IDENTITY PRIMARY KEY, -- Primary key
    title NVARCHAR(50) -- Title
);
-- TokenType table containing token types

-- Table: AuditLog
CREATE TABLE [auditLog] (
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
CREATE TABLE [voucher] (
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
DBCC CHECKIDENT ('Address', RESEED, 100001);
DBCC CHECKIDENT ('Account', RESEED, 100001);
DBCC CHECKIDENT ('Permission', RESEED, 100001);
DBCC CHECKIDENT ('RolePermission', RESEED, 100001);
DBCC CHECKIDENT ('AccountRole', RESEED, 100001);
DBCC CHECKIDENT ('Role', RESEED, 100001);
DBCC CHECKIDENT ('category', RESEED, 100001);
DBCC CHECKIDENT ('productType', RESEED, 100001);
DBCC CHECKIDENT ('vendor', RESEED, 100001);
DBCC CHECKIDENT ('product', RESEED, 100001);
DBCC CHECKIDENT ('item', RESEED, 100001);
DBCC CHECKIDENT ('variant', RESEED, 100001);
DBCC CHECKIDENT ('variantValue', RESEED, 100001);
DBCC CHECKIDENT ('itemVariant', RESEED, 100001);
DBCC CHECKIDENT ('itemInventory', RESEED, 100001);
DBCC CHECKIDENT ('refreshToken', RESEED, 100001);
DBCC CHECKIDENT ('tokenType', RESEED, 100001);
DBCC CHECKIDENT ('auditLog', RESEED, 100001);
DBCC CHECKIDENT ('voucher', RESEED, 100001);

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

ALTER TABLE variantValue
ADD CONSTRAINT FK_VariantValue_Variant FOREIGN KEY (variant_id) REFERENCES variant(variant_id);
ALTER TABLE variantValue
ADD CONSTRAINT FK_VariantValue_Item FOREIGN KEY (item_id) REFERENCES item(item_id);

ALTER TABLE itemVariant
ADD CONSTRAINT FK_ItemVariant_Item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE itemVariant
ADD CONSTRAINT FK_ItemVariant_Variant FOREIGN KEY (variant_id) REFERENCES variant(variant_id);

ALTER TABLE itemInventory
ADD CONSTRAINT FK_ItemInventory_Item FOREIGN KEY (item_id) REFERENCES item(item_id);

ALTER TABLE refreshToken
ADD CONSTRAINT FK_RefreshToken_Account FOREIGN KEY (account_id) REFERENCES Account(account_id);
ALTER TABLE refreshToken
ADD CONSTRAINT FK_RefreshToken_TokenType FOREIGN KEY (type_id) REFERENCES tokenType(token_type_id);

ALTER TABLE auditLog
ADD CONSTRAINT FK_AuditLog_Account FOREIGN KEY (account_id) REFERENCES Account(account_id);



-- Thêm dữ liệu vào bảng category
INSERT INTO category (parent_category_id, title, metaTitle, content, slug, sku, [order])
VALUES
    (NULL,'Keyboard','Keyboard','Keyboard Category Description','/keyboard','KB',1),
	(NULL,'Keycap','Keycap','Keycap Category Description','/keycap','KC',2),
	(NULL,'Switch','Switch','Switch Category Description','/switch','SW',3),
	(NULL,'Stabilizer','Stabilizer','Stabilizer Category Description','/stab','ST',4),
	(NULL,'Accessory','Accessory','Accessory Category Description','/accessory','AC',5),

	--keyboard parent category
	(100001,'40%','40% Keyboard Layout','40% Keyboard Layout Desciption','/keyboard/40%','40', 1),
	(100001,'60%','60% Keyboard Layout','60% Keyboard Layout Desciption','/keyboard/60%','60', 2),
	(100001,'65%','65% Keyboard Layout','65% Keyboard Layout Desciption','/keyboard/65%','65', 3),
	(100001,'75%','75% Keyboard Layout','75% Keyboard Layout Desciption','/keyboard/75%','75', 4),
	(100001,'TKL','TKL Keyboard Layout','TKL Keyboard Layout Desciption','/keyboard/tkl','80', 5),
	(100001,'ALICE','Alice Keyboard Layout','Alice Keyboard Layout Desciption','/keyboard/alice','AL', 6),

	--keycap parent category
	(100002,'ABS','ABS Keycap','ABS Keycap Desciption','/keycap/abs','ABS', 1),
	(100002,'PBT','PBT Keycap','PBT Keyca Desciption','/keycap/pbt','PBT', 2);

-- thêm dữ liệu vào bảng product type
INSERT INTO productType (title, metaTitle, content, slug, sku, [order])
VALUES
    ('In Stock', 'In Stock - Meta Title', 'Products in stock and available for purchase', '/type/in-stock', 'IS', 1),
    ('Order', 'Order - Meta Title', 'Products available for order but not in stock', '/type/order', 'OD', 2);


-- Thêm dữ liệu vào bảng vendor
INSERT INTO vendor (title, content, sku, [order])
VALUES
    ('GMK', 'Description for Vendor GMK', 'GMK', 1),
	('QK', 'Description for Vendor QK', 'QK', 2),
	('NEO', 'Description for Vendor NEO', 'NEO', 3),
	('WUQUE', 'Description for Vendor Wuque', 'WUQUE', 4);


-- Thêm dữ liệu vào bảng variant
INSERT INTO variant (title, content)
VALUES
    ('Color', 'Content for Variant Color'),
	('Material', 'Content for Variant Material'),
	('Mode', 'Content for Variant Mode'),
	('Type', 'Content for Variant Type');


-- Thêm dữ liệu vào bảng variant value