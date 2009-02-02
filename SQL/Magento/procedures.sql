DELIMITER //

--CREATE VARCHAR PROCEDURE

DROP PROCEDURE IF EXISTS updateProductAttributeVarchar//

CREATE PROCEDURE updateProductAttributeVarchar
	(productID		INT,
 	 attributeCode		VARCHAR(255),
 	 attributeValue		VARCHAR(255))
BEGIN
	DECLARE attributeID INT;
	DECLARE rowCount INT;
	
	IF attributeValue IS NOT NULL THEN
	
		SELECT attribute_id into attributeID 
		FROM eav_attribute 
		WHERE attribute_code = attributeCode AND entity_type_id = 4;
	
		select count(*) into rowCount
		from catalog_product_entity_varchar
		where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
	
		IF rowCount > 0 THEN
			UPDATE catalog_product_entity_varchar set value = attributeValue
				where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
		ELSE
			INSERT INTO catalog_product_entity_varchar
			VALUES (NULL
				,4
				,attributeID
				,0
				,productID
				,attributeValue);
		END IF;
	END IF;
END//

--CREATE TEXT PROCEDURE
DROP PROCEDURE IF EXISTS updateProductAttributeText//
CREATE PROCEDURE updateProductAttributeText
	(productID		INT,
 	 attributeCode		VARCHAR(255),
 	 attributeValue		TEXT)
BEGIN
	DECLARE attributeID INT;
	DECLARE rowCount INT;
	
	IF attributeValue IS NOT NULL THEN
	
		SELECT attribute_id into attributeID 
		FROM eav_attribute 
		WHERE attribute_code = attributeCode AND entity_type_id = 4;
	
		select count(*) into rowCount
		from catalog_product_entity_text
		where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
	
		IF rowCount > 0 THEN
			UPDATE catalog_product_entity_text set value = attributeValue
				where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
		ELSE
			INSERT INTO catalog_product_entity_text
			VALUES (NULL
				,4
				,attributeID
				,0
				,productID
				,attributeValue);
		END IF;
	END IF;
END//

--CREATE DECIMAL PROCEDURE
DROP PROCEDURE IF EXISTS updateProductAttributeDecimal//
CREATE PROCEDURE updateProductAttributeDecimal
	(productID		INT,
 	 attributeCode		VARCHAR(255),
 	 attributeValue		DECIMAL)
BEGIN
	DECLARE attributeID INT;
	DECLARE rowCount INT;
	
	IF attributeValue IS NOT NULL THEN
	
		SELECT attribute_id into attributeID 
		FROM eav_attribute 
		WHERE attribute_code = attributeCode AND entity_type_id = 4;
	
		select count(*) into rowCount
		from catalog_product_entity_decimal
		where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
	
		IF rowCount > 0 THEN
			UPDATE catalog_product_entity_decimal set value = attributeValue
				where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
		ELSE
			INSERT INTO catalog_product_entity_decimal
			VALUES (NULL
				,4
				,attributeID
				,0
				,productID
				,attributeValue);
		END IF;
	END IF;
END//

--CREATE INT PROCEDURE
DROP PROCEDURE IF EXISTS updateProductAttributeInt//
CREATE PROCEDURE updateProductAttributeInt
	(productID		INT,
 	 attributeCode		VARCHAR(255),
 	 attributeValue		INT)
BEGIN
	DECLARE attributeID INT;
	DECLARE rowCount INT;
	
	IF attributeValue IS NOT NULL THEN
	
		SELECT attribute_id into attributeID 
		FROM eav_attribute 
		WHERE attribute_code = attributeCode AND entity_type_id = 4;
	
		select count(*) into rowCount
		from catalog_product_entity_int
		where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
	
		IF rowCount > 0 THEN
			UPDATE catalog_product_entity_int set value = attributeValue
				where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
		ELSE
			INSERT INTO catalog_product_entity_int
			VALUES (NULL
				,4
				,attributeID
				,0
				,productID
				,attributeValue);
		END IF;
	END IF;
END//

--CREATE DATETIME PROCEDURE
DROP PROCEDURE IF EXISTS updateProductAttributeDatetime//
CREATE PROCEDURE updateProductAttributeDatetime
	(productID		INT,
 	 attributeCode		VARCHAR(255),
 	 attributeValue		DATETIME)
BEGIN
	DECLARE attributeID INT;
	DECLARE rowCount INT;
	
	IF attributeValue IS NOT NULL THEN
	
		SELECT attribute_id into attributeID 
		FROM eav_attribute 
		WHERE attribute_code = attributeCode AND entity_type_id = 4;
	
		select count(*) into rowCount
		from catalog_product_entity_datetime
		where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
	
		IF rowCount > 0 THEN
			UPDATE catalog_product_entity_datetime set value = attributeValue
				where entity_id = productID and
				store_id = 0 and
				attribute_id = attributeID;
		ELSE
			INSERT INTO catalog_product_entity_datetime
			VALUES (NULL
				,4
				,attributeID
				,0
				,productID
				,attributeValue);
		END IF;
	END IF;
END//

--CREATE UPDATE PRODUCT INVENTORY PROCEDURE
DROP PROCEDURE IF EXISTS updateProductInventory//
CREATE PROCEDURE updateProductInventory
	(productId		INT,
	quantity		DECIMAL(12, 4))
BEGIN
	DECLARE isInStock TINYINT(1);
	IF quantity > 0 THEN
		SET isInStock = 1;
	ELSE
		SET isInStock = 0;
	END IF;
	
	INSERT INTO cataloginventory_stock_item 
		(	item_id
		,	product_id
		,	stock_id
		,	qty
		,	is_in_stock)
	VALUES
		(	NULL
		,	productId
		,	1
		,	quantity
		,	isInStock)
	ON DUPLICATE KEY UPDATE qty=quantity
		,	is_in_stock=isInStock;
	
END//

-- CREATE FUNCTION TO RETURN PRODUCT ID BY SKU
DROP FUNCTION IF EXISTS getProductIdBySku//
CREATE FUNCTION getProductIdBySku(_sku VARCHAR(64), _type VARCHAR(12)) returns INT
BEGIN

	IF NOT (SELECT count(*) FROM catalog_product_entity WHERE sku=_sku) > 0 THEN
		INSERT INTO  catalog_product_entity VALUES
			(	NULL
			,	4
			,	4
			,	_type
			,	_sku
			,	NULL
			,	NOW()
			,	NOW()
			,	0);
	END IF;
	
	RETURN (SELECT entity_id FROM catalog_product_entity WHERE sku=_sku);	
END//

-- CREATE FUNCTION TO UPDATE AN ATTRIBUTE OPTION VALUE
DROP FUNCTION IF EXISTS updateAttributeOptionValue//
CREATE FUNCTION updateAttributeOptionValue(_attributeCode VARCHAR(255), _optionValue VARCHAR(255), _sortOrder SMALLINT(5)) RETURNS INT
BEGIN
	DECLARE _attributeId SMALLINT(5) DEFAULT (SELECT attribute_id FROM eav_attribute WHERE entity_type_id=4 AND attribute_code=_attributeCode);
	IF (SELECT count(*)
		FROM eav_attribute_option_value v
			INNER JOIN eav_attribute_option o
				ON v.option_id = o.option_id
			INNER JOIN eav_attribute a
				ON o.attribute_id = a.attribute_id
		WHERE a.attribute_code = _attributeCode
		AND v.store_id = 0
		AND v.value = _optionValue) = 0 
	THEN

		INSERT INTO eav_attribute_option VALUES
			(	NULL
			,	_attributeId
			,	_sortOrder);

		INSERT INTO eav_attribute_option_value VALUES
			(	NULL
			,	LAST_INSERT_ID()
			,	0
			,	_optionValue);

	END IF;

	RETURN (getAttributeOptionIdByValue(_attributeCode, _optionValue));

END//

-- CREATE FUNCTION TO RETURN ATTRIBUTE OPTION ID BY VALUE
DROP FUNCTION IF EXISTS getAttributeOptionIdByValue//
CREATE FUNCTION getAttributeOptionIdByValue(_attributeCode VARCHAR(255), _optionValue VARCHAR(255)) RETURNS INT
BEGIN
	RETURN (SELECT v.value_id
		FROM eav_attribute_option_value v
			INNER JOIN eav_attribute_option o
				ON v.option_id = o.option_id
			INNER JOIN eav_attribute a
				ON o.attribute_id = a.attribute_id
		WHERE a.attribute_code = _attributeCode
		AND v.store_id = 0
		AND v.value = _optionValue);
END//

-- CREATE PROCEDURE TO ADD SIMPLE PRODUCT TO CONFIGURABLE
DROP PROCEDURE IF EXISTS assignSimpleToConfigurable//
CREATE PROCEDURE assignSimpleToConfigurable(_productId INT(10), _parentId INT(10))
BEGIN
	IF (SELECT count(*) FROM catalog_product_super_link WHERE product_id = _productId AND parent_id = _parentId) = 0 THEN
		INSERT INTO catalog_product_super_link VALUES(NULL, _productId, _parentId);
	END IF;
END//

-- CREATE PROCEDURE TO ADD PRODUCT SUPER ATTRIBUTE
DROP PROCEDURE IF EXISTS addSuperAttribute//
CREATE PROCEDURE addSuperAttribute(_parentId INT(10), _attributeCode VARCHAR(255))
BEGIN
	DECLARE _attributeLabel VARCHAR(255) DEFAULT (SELECT frontend_label FROM eav_attribute WHERE entity_type_id=4 AND attribute_code=_attributeCode);
	DECLARE _attributeId SMALLINT(5) DEFAULT (SELECT attribute_id FROM eav_attribute WHERE entity_type_id=4 AND attribute_code=_attributeCode);

	IF (SELECT count(*) FROM catalog_product_super_attribute WHERE product_id = _parentId AND attribute_id = _attributeId) = 0 THEN
		INSERT INTO catalog_product_super_attribute VALUES(NULL, _parentId, _attributeId, 0);
		INSERT INTO catalog_product_super_attribute_label VALUES(NULL, LAST_INSERT_ID(), 0, _attributeLabel);
	END IF;
END//

-- TODO

-- 4) orderAttributeOptionValue 

DELIMITER ;