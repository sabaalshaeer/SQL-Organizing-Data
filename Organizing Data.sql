select*
From Titles

--List the book titles along with thier sale prices and sort the list in descending order
-- of sale price and in ascending order of bokk title
SELECT bktitle, slprice
FROM Titles
ORDER BY slprice DESC, bktitle

--THe number of books that need to be sold to break the profit and loss even
SELECT bktitle, slprice, devcost, devcost/slprice AS breakeven_point
FROM Titles
WHERE devcost IS NOT NULL
ORDER BY devcost/slprice

--Ranking Data
--Use Ranking Functions to list the representives based on the quantity of books they sold in 2017
SELECT repid, qty, custnum
FROM Sales
WHERE DATEPART(YEAR, sldate) = 2017

--Add a custom Field based on the Rank Function
SELECT repid, qty, custnum
	, RANK() OVER(PARTITION BY repid ORDER BY qty DESC) AS 'Rank'
FROM Sales
WHERE DATEPART(YEAR, sldate) = 2017

--Add a custom Field based on the Dense_Rank Function
SELECT repid, qty, custnum
	, RANK() OVER(PARTITION BY repid ORDER BY qty DESC) AS 'Rank'
	, DENSE_RANK() OVER(PARTITION BY repid ORDER BY qty DESC) AS 'Dense Rank'
FROM Sales
WHERE DATEPART(YEAR, sldate) = 2017

--Divide the rows into 5 groups and add row numbers
--The NTILE() function assigns a bucket number representing the group to which the row belongs
SELECT repid, qty, custnum
	, RANK() OVER(PARTITION BY repid ORDER BY qty DESC) AS 'Rank'
	, DENSE_RANK() OVER(PARTITION BY repid ORDER BY qty DESC) AS 'Dense Rank'
	, NTILE(5) OVER(PARTITION BY repid ORDER BY qty DESC) AS 'Ntile'
	, ROW_NUMBER() OVER(PARTITION BY repid ORDER BY qty DESC) AS 'Row Number'
FROM Sales
WHERE DATEPART(YEAR, sldate) = 2017

--Summarize the total sales made by each representive in 2017
SELECT repid, qty, custnum
FROM Sales
WHERE DATEPART(YEAR, sldate) = 2017
Order BY repid

-- Add an aggregate function, (Group by clause goes with aggregate function)
SELECT repid, COUNT(DISTINCT custnum) AS #_Cust
FROM Sales
WHERE DATEPART(YEAR, sldate) = 2017
GROUP BY repid

-- Add a Having clause to show only representives who sold at least 2000 books
SELECT repid, COUNT(DISTINCT custnum) AS #_Cust
FROM Sales
WHERE DATEPART(YEAR, sldate) = 2017
GROUP BY repid
HAVING SUM(qty) >= 2000

--Summarize each sales representative's sales to each customer
--display the representative IDs and Total sales made by each representative
SELECT repid, custnum, SUM(qty) AS annual_total
FROM Sales
WHERE DATEPART(YEAR, sldate) = 2017
GROUP BY repid, custnum

--Add With Rollup 
SELECT repid, custnum, SUM(qty) AS annual_total
FROM Sales
WHERE DATEPART(YEAR, sldate) = 2017
GROUP BY repid, custnum WITH ROLLUP

--Looking for patterns of monthly sates by sales representatives over the period of January through June
--Summarize the quantities sold by each sales representative each month and pivot the data to display each month in a seperate column
SELECT LEFT(DATENAME(month, sldate), 3) AS mo, qty, repid
FROM Sales

SELECT * FROM (
	SELECT LEFT(DATENAME(month, sldate), 3) AS mo, qty, repid
	FROM Sales
) AS source

--pivot the query results
SELECT * FROM (
	SELECT LEFT(DATENAME(month, sldate), 3) AS mo, qty, repid
	FROM Sales
) AS source
PIVOT (SUM(qty) FOR mo IN (Jan,Feb,Mar,Apr,May,Jun)) AS pivoted


 









