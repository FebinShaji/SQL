/*
This is the template SQL file for the queries for cousework2 (SQL). 
Please write all your SQL codes in this file and submit this file to Minerva
*/

/* ==============================================
   WARNNIG: DO NOT REMOVE THE CODES BELOW 
   Dropping existing tables and views if exists
   ==============================================
*/
DROP TABLE IF EXISTS TopImport;
DROP VIEW IF EXISTS vSales;
DROP VIEW IF EXISTS vLoyalCustomer;
DROP VIEW IF EXISTS vCustomerMissingDetails;
DROP VIEW IF EXISTS vTopRegionCustomer;
DROP VIEW IF EXISTS vTop10Products;

/*
======================
Question 1
======================
Question 1(a)
*/
CREATE TABLE TopImport(Id INTEGER PRIMARY KEY, Country VARCHAR(100), TotalImport REAL, ProductCategory INTEGER, CategoryName VARCHAR(100));

/*
Question 1(b)
*/
INSERT INTO TopImport VALUES(1, 'Germany', 18224.6, 1, 'Beverages');
INSERT INTO TopImport VALUES(2, 'Germany', 1082.885, 2, 'Condiments');
INSERT INTO TopImport VALUES(3, 'Germany', 19596.3825, 3, NULL);

/*
Question 1(c)
*/
UPDATE TopImport SET CategoryName = 'Confections' WHERE Id = 3;

/*
Question 1(d)
*/
DELETE FROM TopImport WHERE Id = 2;

/*
======================
Question 2
======================
Question 2(a)
*/
SELECT CategoryName,
CASE
WHEN CategoryName = 'Beverages' THEN 1
WHEN CategoryName = 'Condiments' THEN 2
WHEN CategoryName = 'Confections' THEN 3
WHEN CategoryName = 'Dairy Products' THEN 4
WHEN CategoryName = 'Grains/Cereals' THEN 5
WHEN CategoryName = 'Meat/Poultry' THEN 6
WHEN CategoryName = 'Produce' THEN 7
WHEN CategoryName = 'Seaood' THEN 8
END AS MyPreferenceRank
FROM Category;

/*
Question 2(b)
*/
SELECT DISTINCT SupplierID FROM Product WHERE CategoryId = 5;

/*
======================
Question 3
======================
Question 3(a)
*/
CREATE VIEW vSales AS
SELECT o.ProductID, p.ProductName, s.CompanyName, SUM(o.Quantity) AS TotalSales, p.UnitPrice FROM
Product p INNER JOIN OrderDetail o ON p.ID = o.ProductID
INNER JOIN Supplier s ON p.SupplierID = s.ID
GROUP BY o.ProductID, p.ProductName, s.CompanyName, p.UnitPrice;

/*
Question 3(b)
*/
CREATE VIEW vTop10Products AS
SELECT * FROM vSales
ORDER BY TotalSales DESC
LIMIT 10;

/*
======================
Question 4
======================
Question 4(a)
*/
CREATE VIEW vLoyalCustomer AS
SELECT COUNT(CustomerID) AS TotalOrder, o.CustomerID, cu.CompanyName, cu.Region FROM
"Order" o INNER JOIN Customer cu ON cu.ID = o.CustomerID
GROUP BY CompanyName;

/*
Question 4(b)
*/
CREATE VIEW vCustomerMissingDetails AS
SELECT CustomerID
FROM "Order" o
WHERE NOT EXISTS
(SELECT * FROM Customer cu
WHERE cu.ID = o.CustomerID)
GROUP BY CustomerID;

/*
Question 4(c)
*/
CREATE VIEW vTopRegionCustomer AS
SELECT TotalOrder, CustomerID, CompanyName, Region FROM
(SELECT TotalOrder, CustomerID, CompanyName, Region,
RANK() OVER(PARTITION BY Region ORDER BY TotalOrder DESC) rank
FROM vLoyalCustomer)
WHERE rank = 1;
