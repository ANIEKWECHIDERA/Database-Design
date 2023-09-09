SELECT *
FROM [dbo].[VENDOR_TABLE]
	JOIN [dbo].[PRODUCT_TABLE] ON VENDOR_TABLE.VendorID = PRODUCT_TABLE.VendorID
	JOIN [dbo].[INVENTORY_TABLE] ON PRODUCT_TABLE.ProductID = INVENTORY_TABLE.ProductID
	JOIN [dbo].[SALES_TABLE] ON INVENTORY_TABLE.ProductID = SALES_TABLE.ProductID

WHERE PRODUCT_TABLE.ProductID IN (124, 116)
ORDER BY PRODUCT_TABLE.Product_name

UPDATE PRODUCT_TABLE
SET Product_name = 'Product D'
WHERE ProductID = 124;

UPDATE PRODUCT_TABLE
SET Product_name = 'Product B'
WHERE ProductID = 116;

UPDATE PRODUCT_TABLE
SET Product_name = 'Product V'
WHERE ProductID = 108;

UPDATE PRODUCT_TABLE
SET Product_name = 'Product G'
WHERE ProductID = 119;

UPDATE PRODUCT_TABLE
SET Product_name = 'Product I'
WHERE ProductID = 105;

SELECT *
FROM [dbo].[PRODUCT_TABLE]
ORDER BY Product_name;




UPDATE INVENTORY_TABLE
SET Product_name = 'Product D'
WHERE ProductID = 124;

UPDATE INVENTORY_TABLE
SET Product_name = 'Product B'
WHERE ProductID = 116;

UPDATE INVENTORY_TABLE
SET Product_name = 'Product V'
WHERE ProductID = 108;

UPDATE INVENTORY_TABLE
SET Product_name = 'Product G'
WHERE ProductID = 119;

UPDATE INVENTORY_TABLE
SET Product_name = 'Product I'
WHERE ProductID = 105;

UPDATE INVENTORY_TABLE
SET Product_name = 'Product O'
WHERE ProductID = 114;

SELECT *
FROM [dbo].[INVENTORY_TABLE]
ORDER BY Product_name;


SELECT *
FROM [dbo].[VENDOR_TABLE]
    FULL OUTER JOIN [dbo].[PRODUCT_TABLE] ON VENDOR_TABLE.VendorID = PRODUCT_TABLE.VendorID
    FULL OUTER JOIN [dbo].[INVENTORY_TABLE] ON PRODUCT_TABLE.ProductID = INVENTORY_TABLE.ProductID
    FULL OUTER JOIN [dbo].[SALES_TABLE] ON INVENTORY_TABLE.ProductID = SALES_TABLE.ProductID
ORDER BY PRODUCT_TABLE.PRODUCT_NAME

SELECT *
FROM  PRODUCT_TABLE




SELECT * 
FROM [dbo].[INVENTORY_TABLE]
--WHERE ProductID = 117


SELECT ProductID, COUNT(*) Duplicates
FROM PRODUCT_TABLE
GROUP BY ProductID
--HAVING COUNT(*) >1

WITH de_dupe AS
(
SELECT productID
,ROW_NUMBER() OVER(PARTITION BY productID ORDER BY (SELECT NULL)) ROWnum
FROM [dbo].[INVENTORY_TABLE]
)
DELETE
FROM de_dupe
WHERE ROWnum >1


SELECT *
FROM PRODUCT_TABLE AS PRDT
	LEFT JOIN INVENTORY_TABLE AS INVT ON PRDT.ProductID = INVT.ProductID

SET IDENTITY_INSERT INVENTORY_TABLE ON;
INSERT INTO INVENTORY_TABLE (InventoryID, ProductID, Product_name, Stock_quantity, Reorder_threshold) VALUES
	(1, 108, 'Product V', 86, 20)
,	(2, 109, 'Product T', 103, 40)
,	(3, 118, 'Product S', 84, 23)
,	(32, 123, 'Product U', 96, 24);
SET IDENTITY_INSERT INVENTORY_TABLE OFF;