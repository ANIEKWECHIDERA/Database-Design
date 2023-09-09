--Creating the Database
CREATE TABLE VENDOR_TABLE
(
VendorID int PRIMARY KEY IDENTITY (1,1),
Vendor_name nvarchar(50),
Contact_email nvarchar(100) UNIQUE,
Contact_phone int
);

CREATE TABLE PRODUCT_TABLE
(
ProductID int PRIMARY KEY IDENTITY (1,1),
Product_name nvarchar(50),
Category nvarchar(30),
Cost_Price float,
Selling_Price float,
VendorID nvarchar(50),
Quantity_in_stock int
FOREIGN KEY (VendorID) REFERENCES VENDOR_TABLE(VendorID)
);

CREATE TABLE SALES_TABLE
(
SaleID int PRIMARY KEY IDENTITY (1,1),
ProductID int,
Sale_Date Date,
Quantity_sold int,
Revenue float
FOREIGN KEY (ProductID) REFERENCES PRODUCT_TABLE(ProductID)
);

CREATE TABLE INVENTORY_TABLE
(
InventoryID INT PRIMARY KEY IDENTITY (1,1),
ProductID int,
Product_name nvarchar(50),
Stock_quantity int,
Reorder_threshold int
FOREIGN KEY (ProductID) REFERENCES PRODUCT_TABLE(ProductID)
);

--Populating the VENDOR_TABLE with dummy data
INSERT INTO VENDOR_TABLE VALUES
('VENDOR 1', 'WWW.VENDOR1@GMAIL.COM', 080600001),
('VENDOR 2', 'WWW.VENDOR2@GMAIL.COM', 080600002),
('VENDOR 3', 'WWW.VENDOR3@GMAIL.COM', 080600003),
('VENDOR 4', 'WWW.VENDOR4@GMAIL.COM', 080600004),
('VENDOR 5', 'WWW.VENDOR5@GMAIL.COM', 080600005),
('VENDOR 6', 'WWW.VENDOR6@GMAIL.COM', 080600006),
('VENDOR 7', 'WWW.VENDOR7@GMAIL.COM', 080600007);

--The remaining tables were populated using a python script.

--Previewing the database
SELECT *
FROM [dbo].[VENDOR_TABLE]
	JOIN [dbo].[PRODUCT_TABLE] ON VENDOR_TABLE.VendorID = PRODUCT_TABLE.VendorID
	JOIN [dbo].[INVENTORY_TABLE] ON PRODUCT_TABLE.ProductID = INVENTORY_TABLE.ProductID
	JOIN [dbo].[SALES_TABLE] ON INVENTORY_TABLE.ProductID = SALES_TABLE.ProductID
ORDER BY PRODUCT_TABLE.Product_name

--Correcting error in database
SELECT *
FROM [dbo].[VENDOR_TABLE]
	JOIN [dbo].[PRODUCT_TABLE] ON VENDOR_TABLE.VendorID = PRODUCT_TABLE.VendorID
	JOIN [dbo].[INVENTORY_TABLE] ON PRODUCT_TABLE.ProductID = INVENTORY_TABLE.ProductID
	JOIN [dbo].[SALES_TABLE] ON INVENTORY_TABLE.ProductID = SALES_TABLE.ProductID
WHERE PRODUCT_TABLE.ProductID IN (124, 116)
ORDER BY PRODUCT_TABLE.Product_name

--Using the update statement to replace duplicate product names
--UPDATING THE PRODUCT_TABLE
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

--UPDATING THE INVENTORY_TABLE
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


--Previewing the database
SELECT *
FROM [dbo].[VENDOR_TABLE]
	JOIN [dbo].[PRODUCT_TABLE] ON VENDOR_TABLE.VendorID = PRODUCT_TABLE.VendorID
	JOIN [dbo].[INVENTORY_TABLE] ON PRODUCT_TABLE.ProductID = INVENTORY_TABLE.ProductID
	JOIN [dbo].[SALES_TABLE] ON INVENTORY_TABLE.ProductID = SALES_TABLE.ProductID
ORDER BY VENDOR_NAME

--Creating a backup of the database
BACKUP DATABASE [LOFTY VENTURES ]
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Lofty_ventures.bak'
WITH FORMAT, NAME = 'Full Backup';


--Creating stored procedures for updating selling price
CREATE PROCEDURE UpdatesellingtPrice
    @ProductID INT
   ,@NewPrice FLOAT
AS
BEGIN
    UPDATE  PRODUCT_TABLE
    SET Selling_Price = @NewPrice
    WHERE ProductID = @ProductID;

    SELECT 'Selling_Price updated to' +' '+ CAST(@NewPrice AS NVARCHAR(20))+ '!' AS Result;
END;

--Creating stored procedures for updating inventory stat (Stock quantity)
CREATE PROCEDURE update_stocks_quantity
	 @ProductID INT
	,@NewQty INT
AS
BEGIN
	UPDATE INVENTORY_TABLE
	SET Stock_quantity = @NewQty
	WHERE ProductID = @ProductID;

	SELECT 'New stock Qty is now' +' '+ CAST(@NewQty AS NVARCHAR(20))+ '!' AS Result ;
END;

--Executing the Stored procedures
Exec UpdatesellingtPrice 
	@ProductID = 106
	,@NewPrice = 20.35

Exec update_stocks_quantity
	@NewQty = 80
	,@ProductID = 111;

--Creating views for sales reporting
CREATE VIEW SalesReport AS
SELECT
    Sales.SaleID
    ,PRDCT.ProductID
    ,PRDCT.Product_name
    ,PRDCT.Category
    ,SALES.Sale_Date
    ,SALES.Quantity_sold
    ,SALES.Revenue
    ,VNDR.Vendor_name
FROM SALES_TABLE AS Sales
INNER JOIN PRODUCT_TABLE AS PRDCT ON SALES.ProductID = PRDCT.ProductID
INNER JOIN VENDOR_TABLE AS VNDR ON PRDCT.VendorID = Vndr.VendorID;


SELECT *
FROM SalesReport


--Noticed duplicates in INVENTORY_TABLE
SELECT productID, COUNT(*) Duplicates
FROM [dbo].[INVENTORY_TABLE]
GROUP BY productID
HAVING COUNT(*) >1

--removing duplicates
WITH de_dupe AS
(
SELECT productID
,ROW_NUMBER() OVER(PARTITION BY productID ORDER BY (SELECT NULL)) ROWnum
FROM [dbo].[INVENTORY_TABLE]
)
DELETE
FROM de_dupe
WHERE ROWnum >1