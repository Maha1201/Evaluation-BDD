-- 1 - Liste des clients français :

SELECT CompanyName AS Société, ContactName AS Contact, ContactTitle AS Fonction, Fax AS Téléphone
FROM customers
WHERE Country = 'France';

-- 2 - Liste des produits vendus par le fournisseur 'Exotic Liquids' :

SELECT ProductName AS Produit, UnitPrice AS Prix
FROM products
WHERE SupplierID IN(
    SELECT SupplierID
    FROM suppliers
    WHERE CompanyName = 'Exotic Liquids'
);

-- 3 - Nombre de produits mis à disposition par les fournisseurs français (tri par nombre de produits décroissant) : 

SELECT suppliers.CompanyName, COUNT(ProductID) AS Produit
FROM suppliers
INNER JOIN products ON products.SupplierID = suppliers.SupplierID
WHERE Country = 'France'
GROUP BY suppliers.CompanyName
ORDER BY Produit DESC;

-- 4 - Liste des clients français ayant passé plus de 10 commandes : 

SELECT customers.CompanyName, COUNT(orders.OrderID)
FROM customers
INNER JOIN orders ON customers.CustomerID = orders.CustomerID
WHERE customers.Country = 'France'
GROUP BY customers.CompanyName
HAVING COUNT(orders.OrderID) > 10;

-- 5 - Liste des clients dont le montant cumulé de toutes les commandes passées est supérieur à 30000 € :
-- NB : chiffre daffaires (CA) = total des ventes

SELECT customers.CompanyName, SUM(UnitPrice * Quantity), customers.Country
FROM customers
INNER JOIN orders ON customers.CustomerID = orders.CustomerID
INNER JOIN `order details` ON `order details`.OrderID = orders.OrderID
GROUP BY customers.CompanyName
HAVING SUM(UnitPrice * Quantity) > 30000;

-- 6 - Liste des pays dans lesquels des produits fournis par 'Exotic Liquids' ont été livrés :

SELECT DISTINCT ShipCountry
FROM orders
INNER JOIN `order details` ON `order details`.OrderID = orders.OrderID
INNER JOIN products ON `order details`.ProductID = products.ProductID
INNER JOIN suppliers ON products.SupplierID = suppliers.SupplierID
WHERE CompanyName = 'Exotic Liquids'
ORDER BY ShipCountry ASC;

-- 7 - Chiffre daffaires global sur les ventes de 1997 :
-- NB : chiffre daffaires (CA) = total des ventes

SELECT SUM(UnitPrice * Quantity) AS 'Ventes 97'
FROM orders
INNER JOIN `order details` ON `order details`.OrderID = orders.OrderID
WHERE YEAR(OrderDate) = 1997;

-- 8 - Chiffre daffaires détaillé par mois, sur les ventes de 1997 :

SELECT MONTH(OrderDate) AS Mois_97, SUM(UnitPrice * Quantity) AS Montant_Ventes
FROM `order details` 
JOIN orders ON orders.OrderID = `order details`.OrderID
WHERE YEAR(OrderDate) = 1997 
GROUP BY MONTH(OrderDate);

-- 9 - A quand remonte la dernière commande du client nommé "Du monde entier" ? :

SELECT MAX(OrderDate) 
FROM orders
INNER JOIN customers ON customers.CustomerID = orders.CustomerID 
WHERE CompanyName = 'Du monde entier';

-- 10 - Quel est le délai moyen de livraison en jours ? :

SELECT ROUND(AVG(DATEDIFF(ShippedDate, OrderDate)))
FROM orders;