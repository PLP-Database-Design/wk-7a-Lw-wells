--QUESTION ONE

CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255),
    PRIMARY KEY (OrderID, Product) -- Composite primary key for uniqueness
);

INSERT INTO ProductDetail (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, SUBSTRING_INDEX(Products, ',', 1)
FROM ProductDetail_Original
WHERE LOCATE(',', Products) = 0
UNION ALL
SELECT OrderID, CustomerName, SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)
FROM ProductDetail_Original
CROSS JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 -- Adjust the number based on the maximum expected products
) AS numbers
WHERE LOCATE(',', Products) > 0
AND n <= LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) + 1;

-- Optional: Drop the original table
-- DROP TABLE ProductDetail_Original;

-- Verify the result
SELECT * FROM ProductDetail;


--QUESTION TWO

-- Create Customers table
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert data into Customers table
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails_Original;

-- Create OrderProducts table
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

-- Insert data into OrderProducts table
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails_Original;

-- Verify the results
SELECT * FROM Customers;
SELECT * FROM OrderProducts;