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
END//





--CREATE UPDATE PRODUCT INVENTORY PROCEDURE

DROP PROCEDURE IF EXISTS updateProductInventory//

CREATE PROCEDURE updateProductInventory
	(product_id		INT,
	qty				DECIMAL(12, 4),
	is_in_stock		tinyint)
BEGIN
END//





DELIMITER ;