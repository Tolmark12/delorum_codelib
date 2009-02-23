DELIMITER //

-- CREATE PROCEDURE TO LOAD ALL ATTRIBUTE OPTIONS
DROP PROCEDURE IF EXISTS updateAttributeOptions//
CREATE PROCEDURE updateAttributeOptions()
BEGIN
	DECLARE done boolean DEFAULT 0;
	DECLARE i INT DEFAULT 0;
	DECLARE ii INT DEFAULT 0;
	DECLARE iii INT DEFAULT 0;
	DECLARE _optionId INT;

	DECLARE _colorDescription VARCHAR(20);
	DECLARE _sizeDescription VARCHAR(20);
	DECLARE _vendorDescription VARCHAR(100);

	DECLARE color_cursor CURSOR FOR (select color_description FROM atb_colors WHERE option_id IS NULL ORDER BY color_description);
	DECLARE size_cursor CURSOR FOR (select size_description FROM atb_sizes WHERE option_id IS NULL ORDER BY size_description);
	DECLARE vendor_cursor CURSOR FOR (select vendor_description FROM atb_vendors WHERE option_id IS NULL ORDER BY vendor_description);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN color_cursor;
		REPEAT
			FETCH color_cursor INTO _colorDescription;
			IF NOT done THEN
				SET i = i + 1;
				SET _optionId = updateAttributeOptionValue("color", _colorDescription, i);
				UPDATE atb_colors SET option_id = _optionId WHERE color_description = _colorDescription;
			END IF;
		UNTIL done
		END REPEAT;
	CLOSE color_cursor;
	
	SET done = 0;
	OPEN size_cursor;
		REPEAT
			FETCH size_cursor INTO _sizeDescription;
			IF NOT done THEN
				SET ii = ii + 1;
				SET _optionId = updateAttributeOptionValue("size", _sizeDescription, ii);
				UPDATE atb_sizes SET option_id = _optionId WHERE size_description = _sizeDescription;
			END IF;
		UNTIL done
		END REPEAT;
	CLOSE size_cursor;

	SET done = 0;
	OPEN vendor_cursor;
		REPEAT
			FETCH vendor_cursor INTO _vendorDescription;
			IF NOT done THEN
				SET iii = iii + 1;
				SET _optionId = updateAttributeOptionValue("manufacturer", _vendorDescription, iii);
				UPDATE atb_vendors SET option_id = _optionId WHERE vendor_description = _vendorDescription;
			END IF;
		UNTIL done
		END REPEAT;
	CLOSE vendor_cursor;


END//


--CREATE PROCEDURE TO LOOP THROUGH ATB_PRODUCTS
DROP PROCEDURE IF EXISTS updateMagentoCatalog//

CREATE PROCEDURE updateMagentoCatalog()
BEGIN

	DECLARE _productNumber		int(10);
	DECLARE _shortDescription	text;
	DECLARE _longDescription	text;
	DECLARE _category			int(3);
	DECLARE _subcategory		int(3);
	DECLARE _vendor				varchar(10);
	DECLARE _regularPrice		decimal(12,4);
	DECLARE _currentPrice		decimal(12,4);
	
	DECLARE done boolean DEFAULT 0;
	DECLARE product_cursor CURSOR FOR (SELECT * FROM atb_product);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN product_cursor;
		REPEAT
			FETCH product_cursor INTO _productNumber, _shortDescription, _longDescription, _category, _subcategory, _vendor, _regularPrice, _currentPrice;
			IF NOT done THEN
				CALL handleProductVariants(_productNumber, _shortDescription, _longDescription, _category, _subcategory, _vendor, _regularPrice, _currentPrice);
			END IF;
		UNTIL done
		END REPEAT;
	CLOSE product_cursor;
END//


--TODO
-- 1) Configurable options
-- 2) is_enabled
-- 3) view (nowhere, catalog)
-- 4) assign default category
-- 5) price
-- 5b) discount (current) price
-- 6) tax class

--CREATE PROCEDURE TO HANDLE PRODUCT VARIANTS
DROP PROCEDURE IF EXISTS handleProductVariants//

CREATE PROCEDURE handleProductVariants
	(_productNumber		int(10)
	,_shortDescription	text
	,_longDescription	text
 	,category			int(3)
	,_subcategory		int(3)
	,_vendor			varchar(10)
	,_regularPrice		decimal(12,4)
	,_currentPrice		decimal(12,4))
BEGIN
	
	DECLARE _simpleProductId		int(10);
	DECLARE _configurableProductId	int(10);
	DECLARE _sku					varchar(64);
	DECLARE _style					varchar(20);
	DECLARE _upc					varchar(10);
	DECLARE _size					varchar(10);
	DECLARE _color					varchar(10);
	DECLARE _weight					decimal(12,4);
	DECLARE _qty					int(10);

	DECLARE done boolean DEFAULT 0;
	DECLARE variant_cursor CURSOR FOR (SELECT style, upc_code, size, color, weight, qty FROM atb_product_variant WHERE item_number=_productNumber);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN variant_cursor;
		REPEAT
			FETCH variant_cursor INTO _style, _upc, _size, _color, _weight, _qty;
			IF NOT done THEN
				SET _sku					= CONCAT(_productNumber, _style, _color, _size);
				SET _simpleProductId 		= getProductIdBySku(_sku, "simple");
				SET _configurableProductId 	= getProductIdBySku(_productNumber, "configurable"); 
				
				CALL updateProductAttributeVarchar(_configurableProductId, "name", _shortDescription);
				CALL updateProductAttributeText(_configurableProductId, "short_description", _shortDescription);
				CALL updateProductAttributeText(_configurableProductId, "description", _longDescription);
				CALL updateProductAttributeInt(_configurableProductId, "status", 1);
				CALL updateProductAttributeInt(_configurableProductId, "visibility", 4);
				CALL updateProductAttributeDecimal(_configurableProductId, "price", _regularPrice);
				CALL updateProductAttributeInt(_configurableProductId, "tax_class_id", 2);

				CALL updateProductAttributeVarchar(_simpleProductId, "name", _shortDescription);
				CALL updateProductAttributeText(_simpleProductId, "short_description", _shortDescription);
				CALL updateProductAttributeText(_simpleProductId, "description", _longDescription);
				CALL updateProductAttributeInt(_simpleProductId, "size", getAttributeOptionIdByValue("size", (SELECT size_description FROM atb_sizes WHERE size_code=_size LIMIT 1)));
				CALL updateProductAttributeInt(_simpleProductId, "color", getAttributeOptionIdByValue("color", (SELECT color_description FROM atb_colors WHERE color_code=_color LIMIT 1)));
				CALL updateProductAttributeInt(_simpleProductId, "manufacturer", getAttributeOptionIdByValue("manufacturer", (SELECT vendor_description FROM atb_vendors WHERE vendor_code=_vendor LIMIT 1)));
				CALL updateProductAttributeDecimal(_simpleProductId, "weight", _weight);
				CALL updateProductAttributeDecimal(_simpleProductId, "price", _regularPrice);
				CALL updateProductAttributeInt(_simpleProductId, "tax_class_id", 2);
				CALL updateProductInventory(_simpleProductId, _qty);
				CALL updateProductAttributeInt(_simpleProductId, "status", 1);
				CALL updateProductAttributeInt(_simpleProductId, "visibility", 1);

				CALL assignSimpleToConfigurable(_simpleProductId, _configurableProductId);
				CALL addSuperAttribute(_configurableProductId, "color");
				CALL addSuperAttribute(_configurableProductId, "size");

			END IF;
		UNTIL done
		END REPEAT;
	CLOSE variant_cursor;
	
END//

DELIMITER ;