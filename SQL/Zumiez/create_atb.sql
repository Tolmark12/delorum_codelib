DROP TABLE IF EXISTS atb_product;
CREATE TABLE atb_product 
	(	item_number 		int(10)		NOT NULL
	, 	short_description	text
	,	long_description	text
	,	category			int(3)
	,	subcategory			int(3)
	,	vendor				varchar(10)
	,	regular_price		decimal(12,4)
	,	current_price		decimal(12,4)
	,	CONSTRAINT pk_atb_product PRIMARY KEY (item_number));

DROP TABLE IF EXISTS atb_product_variant;	
CREATE TABLE atb_product_variant 
	(	variant_id 	int(10)			NOT NULL	AUTO_INCREMENT
	,	item_number	int(10)			NOT NULL
	,	style		varchar(20)
	,	upc_code	varchar(10)
	,	size		varchar(10)
	,	color		varchar(10)
	,	weight		decimal(12,4)
	,	qty			int(10)
	,	CONSTRAINT	pk_atb_product_variant PRIMARY KEY (variant_id)
	,	CONSTRAINT 	uq_atb_product_variant UNIQUE (item_number, size, color));
	
DROP TABLE IF EXISTS atb_colors;
CREATE TABLE atb_colors 
	(	color_id			int(10)		NOT NULL
	,	color_code			varchar(4)	NOT NULL
	,	color_description	varchar(20)	NOT NULL
	,	option_id			int(10)
	,	CONSTRAINT pk_atb_colors	PRIMARY KEY (color_id)
	,	CONSTRAINT uq_atb_colors	UNIQUE (color_id, color_code));
	
DROP TABLE IF EXISTS atb_sizes;
CREATE TABLE atb_sizes 
	(	size_id				int(10)		NOT NULL
	,	size_code			varchar(4)	NOT NULL
	,	size_description	varchar(20)	NOT NULL
	,	option_id			int(10)
	,	CONSTRAINT pk_atb_sizes PRIMARY KEY (size_id)
	,	CONSTRAINT uq_atb_sizes UNIQUE (size_id, size_code));
	
DROP TABLE IF EXISTS atb_vendors;
CREATE TABLE atb_vendors 
	(	vendor_id			int(10)			NOT NULL	AUTO_INCREMENT
	, 	atb_vendor_id		varchar(10)		NOT NULL
	,	vendor_code			varchar(10)		NOT NULL
	,	vendor_description	varchar(100)	NOT NULL
	,	option_id			int(10)
	,	CONSTRAINT pk_atb_vendors	PRIMARY KEY (vendor_id)
	,	CONSTRAINT uq_atb_vendors	UNIQUE	(atb_vendor_id, vendor_code));