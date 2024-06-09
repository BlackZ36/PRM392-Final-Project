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
CREATE TABLE [address] (
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
CREATE TABLE [account] (
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
CREATE TABLE [permission] (
    permission_id INT IDENTITY PRIMARY KEY, -- Primary key
    name NVARCHAR(255), -- Permission name
    description NVARCHAR(255), -- Description
    status INT, -- Status
    created_at DATETIME, -- Creation datetime
    updated_at DATETIME -- Last update datetime
);
-- Permission table containing permission details

-- Table: RolePermission
CREATE TABLE [rolePermission] (
    role_permission_id INT IDENTITY PRIMARY KEY, -- Primary key
    role_id INT, -- Foreign key to Role table
    permission_id INT -- Foreign key to Permission table
);
-- RolePermission table containing mappings between roles and permissions

-- Table: AccountRole
CREATE TABLE [accountRole] (
    account_role_id INT IDENTITY PRIMARY KEY, -- Primary key
    account_id INT, -- Foreign key to Account table
    role_id INT -- Foreign key to Role table
);
-- AccountRole table containing mappings between accounts and roles

-- Table: Role
CREATE TABLE [role] (
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
    title NVARCHAR(255) DEFAULT N'Default Category Title', -- Title
    metaTitle NVARCHAR(255) DEFAULT N'Default Category Meta Title', -- Meta title
    content NTEXT DEFAULT N'Default Category Content', -- Content
    slug NVARCHAR(255) DEFAULT N'/default-category-slug', -- Slug
    sku NVARCHAR(255) DEFAULT N'DEFAULTCATEGORY', -- SKU
    status INT DEFAULT 1,
	[order] INT DEFAULT 0, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE()-- Last update datetime
);
-- Category table containing product categories

-- Table: ProductType
CREATE TABLE [productType] (
    product_type_id INT IDENTITY PRIMARY KEY, -- Primary key
    title NVARCHAR(255) DEFAULT N'Default Product Type Title', -- Title
    metaTitle NVARCHAR(255) DEFAULT N'Default Product Type Meta Title', -- Meta title
    content NTEXT DEFAULT N'Default Product Type Description', -- Content
    slug NVARCHAR(255) DEFAULT N'/type/default-product-type', -- Slug
    sku NVARCHAR(255) DEFAULT N'PT', -- SKU
	[order] INT DEFAULT NULL,
    status INT DEFAULT 1, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE() -- Last update datetime
);
-- ProductType table containing product types

-- Table: Vendor
CREATE TABLE [vendor] (
    vendor_id INT IDENTITY PRIMARY KEY, -- Primary key
    title NVARCHAR(255) DEFAULT N'Default Vendor Title', -- Title
    content NTEXT DEFAULT N'Default Vendor Description', -- Content
    sku NVARCHAR(255) DEFAULT N'VD', -- SKU
	[order] INT DEFAULT NULL, --order sort of vendor
    status INT DEFAULT 1, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation timestamp
    updated_at DATETIME DEFAULT GETDATE() -- Last update datetime
);
-- Vendor table containing vendor details

-- Table: Product
CREATE TABLE [product] (
    product_id INT IDENTITY PRIMARY KEY, -- Primary key
    category_id INT DEFAULT NULL, -- Foreign key to Category table
    type_id INT DEFAULT NULL, -- Foreign key to ProductType table
    vendor_id INT DEFAULT NULL, -- Foreign key to Vendor table
    title NVARCHAR(255) DEFAULT N'Default Product Title', -- Title
    metaTitle NVARCHAR(255) DEFAULT N'Default Product Meta Title', -- Meta title
    content NTEXT DEFAULT N'Default Product Description', -- Content
    slug NVARCHAR(255) DEFAULT N'/product/product', -- Slug
    sku NVARCHAR(255) DEFAULT N'PRD', -- SKU
	item_count INT DEFAULT 0, --
	view_time INT DEFAULT 0, -- product view time count
    status INT DEFAULT 1, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE() -- Last update datetime
);
-- Product table containing product details

-- Table: Item
CREATE TABLE [item] (
    item_id INT IDENTITY PRIMARY KEY, -- Primary key
    product_id INT DEFAULT NULL, -- Foreign key to Product table
    title NVARCHAR(255) DEFAULT N'Default Product Item Title', -- Title
    metaTitle NVARCHAR(255) DEFAULT N'Default Product Item Meta Title', -- Meta title
    content NTEXT DEFAULT N'Default Product Item Description', -- Content
    slug NVARCHAR(255) DEFAULT N'/product/product-item', -- Slug
    sku NVARCHAR(255) DEFAULT N'ITEM', -- SKU
    status INT DEFAULT 1, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE()-- Last update datetime
);
-- Item table containing items related to products


-- Table: itemImage
CREATE TABLE itemImage (
    image_id INT IDENTITY PRIMARY KEY, -- Primary key
    item_id INT NOT NULL, -- Foreign key to Item table
    img_url NVARCHAR(255) NOT NULL, -- Image URL
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE(), -- Last update datetime
    FOREIGN KEY (item_id) REFERENCES item(item_id) -- Foreign key constraint
);
-- itemImage table containing items related to item


-- Table: Variant
CREATE TABLE [variant] (
    variant_id INT IDENTITY PRIMARY KEY, -- Primary key
    title NVARCHAR(255) DEFAULT N'Default Variant Title', -- Title
    content NTEXT DEFAULT N'Default Variant Content', -- Content
    status INT DEFAULT 1, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE()-- Last update datetime
);
-- Variant table containing variant details

-- Table: VariantValue
CREATE TABLE [variantValue] (
    variant_value_id INT IDENTITY PRIMARY KEY, -- Primary key
    variant_id INT DEFAULT NULL, -- Foreign key to Variant table
    item_id INT DEFAULT NULL, -- Foreign key to Item table
    value NVARCHAR(255) DEFAULT 'Default Variant Value', -- Value
    img_url NVARCHAR(255) DEFAULT 'https://example.com/product-variant-image.png' -- Image URL ID
);
-- VariantValue table containing values for variants

-- Table: ItemVariant
CREATE TABLE [ItemVariant] (
    item_variant_id INT IDENTITY PRIMARY KEY, -- Primary key
    item_id INT DEFAULT NULL, -- Foreign key to Item table
    variant_id INT DEFAULT NULL, -- Foreign key to Variant table
	status INT DEFAULT 1, --
	created_date DATETIME DEFAULT GETDATE(), --
	updated_date DATETIME DEFAULT GETDATE() --
);
-- ItemVariant table containing mappings between items and variants

-- Table: ItemInventory
CREATE TABLE [itemInventory] (
    inventory_id INT IDENTITY PRIMARY KEY, -- Primary key
    item_id INT DEFAULT NULL, -- Foreign key to Item table
    variant_combination NVARCHAR(255) DEFAULT N'0-0', -- Variant combination
    quantity INT DEFAULT 0, -- Quantity
    discount INT DEFAULT 0, -- Discount
    price MONEY DEFAULT 0, -- Price
    status INT DEFAULT 1, -- Status
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    updated_at DATETIME DEFAULT GETDATE()-- Last update datetime
);
-- ItemInventory table containing inventory details for items

-- Table: RefreshToken
CREATE TABLE [refreshToken] (
    token_id INT IDENTITY PRIMARY KEY, -- Primary key
    account_id INT DEFAULT NULL, -- Foreign key to Account table
    token UNIQUEIDENTIFIER DEFAULT NULL, -- Token
    type_id INT DEFAULT NULL, -- Foreign key to TokenType table
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    expires_at DATETIME DEFAULT GETDATE(), -- Expiration datetime
    status INT -- Status
);
-- RefreshToken table containing refresh tokens

-- Table: TokenType
CREATE TABLE [tokenType] (
    token_type_id INT IDENTITY PRIMARY KEY, -- Primary key
    title NVARCHAR(50) DEFAULT N'Default Token Type Name' -- Title
);
-- TokenType table containing token types

-- Table: AuditLog
CREATE TABLE [auditLog] (
    log_id INT IDENTITY PRIMARY KEY, -- Primary key
    account_id INT DEFAULT NULL, -- Foreign key to Account table
    action NVARCHAR(255) DEFAULT N'Default Action', -- Action
    entity NVARCHAR(255) DEFAULT N'Default Entity', -- Entity
    entity_id INT DEFAULT NULL, -- Entity ID
    content NTEXT DEFAULT N'Default Audit Log Content', -- Content
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    ip_address NVARCHAR(255) DEFAULT N'0.0.0.0', -- IP address
    user_agent NVARCHAR(255) DEFAULT N'Default Browser'-- User agent
);
-- AuditLog table containing logs of actions

-- Table: Voucher
CREATE TABLE [voucher] (
    voucher_id INT IDENTITY PRIMARY KEY, -- Primary key
    code NVARCHAR(20) DEFAULT N'VOUCHER-DEFAULT', -- Voucher code
    discount INT DEFAULT 0, -- Discount amount
    type NVARCHAR(255) DEFAULT NULL, -- Voucher type
    created_at DATETIME DEFAULT GETDATE(), -- Creation datetime
    expires_at DATETIME DEFAULT GETDATE(), -- Expiration datetime
    status INT DEFAULT 1, -- Status
    usage_limit INT DEFAULT 0, -- Usage limit
    used_count INT DEFAULT 0 -- Used count
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
DBCC CHECKIDENT ('itemImage', RESEED, 100001);
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

--Trigger Zone Begin
GO

--Trigger update product_item
CREATE TRIGGER trg_UpdateItemCount
ON [item]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.item_count = (SELECT COUNT(*) 
                        FROM [item] i 
                        WHERE i.product_id = p.product_id)
    FROM [product] p
    INNER JOIN inserted ins ON p.product_id = ins.product_id;
END;
GO

--Trigger Zone End

-- Thêm dữ liệu vào bảng category
INSERT INTO category (parent_category_id, title, metaTitle, content, slug, sku, [order])
VALUES
    (NULL,N'Keyboard',N'Keyboard',N'Keyboard Category Description','/keyboard','KB',1),
	(NULL,N'Keycap',N'Keycap',N'Keycap Category Description','/keycap','KC',2),
	(NULL,N'Switch',N'Switch',N'Switch Category Description','/switch','SW',3),
	(NULL,N'Stabilizer',N'Stabilizer',N'Stabilizer Category Description','/stab','ST',4),
	(NULL,N'Accessory',N'Accessory',N'Accessory Category Description','/accessory','AC',5),

	--keyboard parent category
	(100001,N'40%',N'40% Keyboard Layout',N'40% Keyboard Layout Desciption','/keyboard/40%','40', 1),
	(100001,N'60%',N'60% Keyboard Layout',N'60% Keyboard Layout Desciption','/keyboard/60%','60', 2),
	(100001,N'65%',N'65% Keyboard Layout',N'65% Keyboard Layout Desciption','/keyboard/65%','65', 3),
	(100001,N'75%',N'75% Keyboard Layout',N'75% Keyboard Layout Desciption','/keyboard/75%','75', 4),
	(100001,N'TKL',N'TKL Keyboard Layout',N'TKL Keyboard Layout Desciption','/keyboard/tkl','80', 5),
	(100001,N'ALICE',N'Alice Keyboard Layout',N'Alice Keyboard Layout Desciption','/keyboard/alice','AL', 6),

	--keycap parent category
	(100002,N'ABS',N'ABS Keycap',N'ABS Keycap Desciption','/keycap/abs','ABS', 1),
	(100002,N'PBT',N'PBT Keycap',N'PBT Keyca Desciption','/keycap/pbt','PBT', 2);

-- thêm dữ liệu vào bảng product type
INSERT INTO productType (title, metaTitle, content, slug, sku, [order])
VALUES
    (N'In Stock', N'In Stock - Meta Title', N'Products in stock and available for purchase', '/type/in-stock', 'IS', 1),
    (N'Order', N'Order - Meta Title', N'Products available for order but not in stock', '/type/order', 'OD', 2);


-- Thêm dữ liệu vào bảng vendor
INSERT INTO vendor (title, content, sku, [order])
VALUES
    (N'GMK', N'Description for Vendor GMK', 'GMK', 1),
	(N'QK', N'Description for Vendor QK', 'QK', 2),
	(N'NEO', N'Description for Vendor NEO', 'NEO', 3),
	(N'WUQUE', N'Description for Vendor Wuque', 'WUQUE', 4);


-- Thêm dữ liệu vào bảng variant
INSERT INTO variant (title, content)
VALUES
    (N'Color', N'Content for Variant Color'),
	(N'Material', N'Content for Variant Material'),
	(N'Mode', N'Content for Variant Mode'),
	(N'Type', N'Content for Variant Type'),
	(N'Mode', N'Content for Variant Mode'),
	(N'Case', N'Content for Variant Case'),
	(N'PCB', N'Content for Variant PCB'),
	(N'Plate', N'Content for Variant Plate'),
	(N'Add-ons', N'Content for Variant Add-ons'),
	(N'Weight', N'Content for Variant Weight'),
	(N'Switch', N'Content for Variant Switch');


-- Thêm dữ liệu vào bảng product
INSERT INTO [product] (category_id, type_id, vendor_id, title, metaTitle, content, slug, sku)
VALUES
    (100008, 100001, 100003, N'Neo65', N'Bàn phím cơ Neo65', N'Sản phẩm bàn phím cơ Neo65 đến từ Neo Studio', '/collections/neo65', 'NEO65'),
    (100008, 100001, 100002, N'QK65', N'Bàn phím cơ QK65', N'Sản phẩm bàn phím cơ QK65 đến từ QK Studio', '/collections/qk65', 'QK65');


-- Thêm dữ liệu vào bảng Item cho sản phẩm với product_id 100001
INSERT INTO [Item] (product_id, title, metaTitle, content, slug, sku)
VALUES
    (100001, N'[Case] NEO65', N'Meta Title for [Case] NEO65', N'Description for [Case] NEO65', '/product/neo65-case', 'CASE'),
    (100001, N'[PCB] NEO65', N'Meta Title for [PCB] NEO65', N'Description for [PCB] NEO65', '/product/neo65-pcb', 'PCB'),
    (100001, N'[Plate] NEO65', N'Meta Title for [Plate] NEO65', N'Description for [Plate] NEO65', '/product/neo65-plate', 'PLATE'),
    (100001, N'[Weight] NEO65', N'Meta Title for [Weight] NEO65', N'Description for [Weight] NEO65', '/product/neo65-weight', 'WEIGHT'),
    (100001, N'[Add-ons] NEO65', N'Meta Title for [Add-ons] NEO65', N'Description for [Add-ons] NEO65', '/product/neo65-add-ons', 'ADDONS');


-- Bảng variant_value
INSERT INTO variantValue (variant_id, item_id, value, img_url)
VALUES
    -- Case values
    (100006, 100001, N'Black', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100006, 100001, N'Green', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100006, 100001, N'Milky White', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100006, 100001, N'Navy', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100006, 100001, N'Purple', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100006, 100001, N'Red', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100006, 100001, N'Silver', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100006, 100001, N'White', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100006, 100001, N'Yellow', 'https://dummyimage.com/1280x720/cccccc/000'),

	-- PCB values
	(100007, 100002, N'3 Mode - Hotswap', 'https://dummyimage.com/1280x720/cccccc/000'),
	(100007, 100002, N'1 Mode - Hotswap', 'https://dummyimage.com/1280x720/cccccc/000'),
	(100007, 100002, N'1 Mode - Solder', 'https://dummyimage.com/1280x720/cccccc/000'),

	-- Plate values
	(100008, 100003, N'Alu', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100008, 100003, N'FR4', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100008, 100003, N'PC', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100008, 100003, N'POM', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100008, 100003, N'Carbon Fiber', 'https://dummyimage.com/1280x720/cccccc/000'),

	-- Weight values
    (100010, 100004, N'Brass', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100010, 100004, N'Copper', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100010, 100004, N'Mirror Golden', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100010, 100004, N'Mirror Dusk', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100010, 100004, N'Mirror Chroma', 'https://dummyimage.com/1280x720/cccccc/000'),

	-- Add-ons values
    (100009, 100005, N'Daughter-board + Cable', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100009, 100005, N'O-ring', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100009, 100005, N'Rubber Feet', 'https://dummyimage.com/1280x720/cccccc/000'),
    (100009, 100005, N'Gaskets', 'https://dummyimage.com/1280x720/cccccc/000');



-- Bảng item_variant
INSERT INTO ItemVariant (item_id, variant_id)
VALUES
    (100001, 100006),
    (100002, 100007),
    (100003, 100008),
    (100004, 100009),
    (100005, 100010);