SELECT * FROM [dbo].[Movie Data]

--Question 1: 
-- Using the Movie Data, write a query to show the titles and movies released in 2017, 
-- whose vote count is more than 15 and runtime is more than 100.

SELECT original_title FROM [dbo].[Movie Data]
WHERE vote_count > 15 AND runtime > 100 AND release_date BETWEEN '2017-01-01' AND '2017-12-31'
GROUP BY original_title

SELECT original_title FROM [dbo].[Movie Data]
WHERE vote_count > 15 AND runtime > 100 AND release_date LIKE '%2017%'
GROUP BY original_title


--Question 2:
-- Using the Pizza Data, write a query to show how many pizzas were ordered.

SELECT COUNT([order_id]) AS total_pizzas_ordered
FROM [dbo].[customer_orders]


--Question 3:
-- Using the Pizza Data, write a query to show how many successful orders
-- were delivered by each runner.

SELECT [runner_id], COUNT([duration]) AS number_of_successful_orders
FROM [dbo].[runner_orders]
WHERE [duration] IS NOT NULL
GROUP BY [runner_id]

SELECT [runner_id], COUNT(*) AS number_of_successful_orders
FROM [dbo].[runner_orders]
WHERE [cancellation] IS NULL
GROUP BY [runner_id]


-- Question 4
-- Using the Movie Data, write a query to show the top 10 movie titles 
-- whose language is English and French and the budget is more than 1,000,000

SELECT * FROM [dbo].[Movie Data]

SELECT TOP 10 [title] FROM [dbo].[Movie Data]
WHERE [original_language] IN ('en','fr')
AND [budget]> 1000000
GROUP BY [title]


SELECT TOP 10 [title] FROM [dbo].[Movie Data]
WHERE [budget]> 1000000
GROUP BY [title]


SELECT TOP 10 [title] FROM [dbo].[Movie Data]
WHERE [budget]> 1000000
AND [original_language] IN ('en','fr')
GROUP BY [title]


-- Question 5
-- Using the Pizza Data, write a query to 
-- show the number of each type of pizza delivered.

SELECT [pizza_name], COUNT([duration]) AS pizza_delivered FROM [dbo].[pizza_names] PN
JOIN [dbo].[customer_orders] CO on PN.pizza_id = CO.pizza_id
JOIN [dbo].[runner_orders] RO on RO.order_id = CO.order_id
WHERE [duration] IS NOT NULL
GROUP BY [pizza_name];


-- *BONUS QUESTION*
-- The Briggs company wants to ship some of their products to customers
-- in selected cities but they want to know the average days it will take 
-- to deliver those items to DALLAS, LOS ANGELES, SEATTLE and MADISON.
-- Using the Sample Superstore data, write a query to show the average 
-- delivery days to those cities. Only show the city and average delivery
-- days columns in your output.

SELECT [City], AVG(DATEDIFF(DAY,[Order Date],[Ship Date])) AS Average_Delivery_Days
FROM [dbo].[SS_Orders]
WHERE [City] IN ('Dallas', 'Los Angeles', 'Seattle', 'Madison')
GROUP BY [City]


-- Question 6
-- It's getting to the end of the year and The Briggs Company wants to reward
-- the customer who made the highest sales ever. Using the Sample Superstore data,
-- write a query to help the commpany identify this customer and category of business
-- driving the sales. Let your output show the customer name, the category and the 
-- total sales. Round the total sales to the nearest whole number.


SELECT TOP 1 [Customer Name], [Category], ROUND(SUM([Sales]),0) AS Total_Sales
FROM [dbo].[SS_Orders]
GROUP BY [Customer Name], [Category]
ORDER BY Total_Sales DESC

SELECT [Customer Name], [Category], ROUND(SUM([Sales]),0) AS Total_Sales
FROM [dbo].[SS_Orders]
WHERE [Customer Name] = 'Sean Miller'
GROUP BY [Customer Name], [Category]
ORDER BY Total_Sales DESC

SELECT [Customer Name], [Category], ROUND([Sales],0) AS Sales
FROM [dbo].[SS_Orders]
WHERE [Customer Name] = 'Sean Miller'
GROUP BY [Customer Name], [Category], [Sales]
ORDER BY [Sales] DESC


-- Question 7
-- The Briggs Company has 3 categories of business generating revenue for the company.
-- They want to know which of them is driving the business.
-- Write a query to show the total sales and percentage contribution 
-- by each category. Show CATEGORY, TOTAL SALES and PERCENTAGE in your
-- output.

SELECT DISTINCT([Category]), ROUND(SUM([Sales]),0) AS Total_Sales,  
ROUND(SUM([Sales]) * 100 / (SELECT SUM([Sales]) FROM [dbo].[SS_Orders]),0) AS Percentage_Contribution
FROM [dbo].[SS_Orders]
GROUP BY [Category]
ORDER BY Percentage_Contribution DESC


-- Question 8
-- After seeing the Sales by Category, the Briggs Company became curious and wanted
-- to dig deeper to see which subcategory is selling the most. They need the help of an analyst. 
-- Please help the company to write a query to show the SUBCATEGORY and the TOTAL SALES
-- of each subcategory. Let your query dispaly only the subcategory and the Total Sales Columns
-- to see which product sells the most.

SELECT DISTINCT([Sub-Category]), ROUND(SUM([Sales]),0) AS Total_Sales
FROM [dbo].[SS_Orders]
GROUP BY [Sub-Category]
ORDER BY Total_Sales DESC


-- Question 9
-- Now that you've identified phones as the business driver in terms of revenue,
-- the company wants to know the total "phones sales" by year to understand how
-- "each year" performed. As the Analyst, please help them to show the breakdown
-- of the total sales by year in descending order. Let your output show only
-- TOTAL SALES and SALES YEAR Column.

SELECT YEAR([Order Date]) AS 'Sales Year', ROUND(SUM([Sales]),0) AS 'Total Sales'
FROM [dbo].[SS_Orders]
WHERE [Sub-Category] = 'Phones'
GROUP BY YEAR ([Order Date])
ORDER BY 'Total Sales' DESC


-- Question 10
-- The Director of Analytics has requested a detailed analysis of the Briggs Company.
-- To fulfil this request, he needs you to generate a table that displays the 
-- PROFIT MARGIN of EACH SEGMENT. 
-- The table should include the segments, total sales, total profit and the profit margin.
-- To ensure accuracy, the profit margin should be arranged in descending order.

SELECT [Segment],
ROUND(SUM([Sales]),0) AS 'Total Sales',
ROUND(SUM([Profit]),0) AS 'Total Profit',
ROUND((ROUND(SUM([Profit]),0)/ROUND(SUM([Sales]),0)*100),0) AS 'Profit Margin (%)'
FROM [dbo].[SS_Orders]
GROUP BY [Segment]
ORDER BY 'Profit Margin (%)' DESC


--Question 11
-- Your company  started consulting for Micro Bank who needs to analyze their marketing data
-- to understand their customers better. This will help them plan their next marketing campaign.
-- You are brought on board as the analyst for this job. They have an offer for customers who 
-- are DIVORCED but they need data to back up the campaign.
-- Using the marketing data, write a query to show the percentage of customers who are 
-- DIVORCED and have BALANCES greater than 2000.

SELECT [marital],
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM [dbo].[Marketing data]),0) AS 'Customer % with Bal>2000'
FROM [dbo].[Marketing data]
WHERE [marital] = 'divorced' AND [balance] > 2000
GROUP BY [marital]


--Question 12
-- Micro Bank wants to be sure they have enough data for this campaign and would like to see 
-- the total count of each job as contained in the dataset. Using the Marketing Data, write 
-- a query to show the count of each job, arrange the total count in DESC order.

SELECT [job], COUNT([job]) AS 'Total #'
FROM [dbo].[Marketing data]
GROUP BY [job]
ORDER BY 'Total #' DESC


--Question 13
-- Just for clarity purposes, your company wants to see which education level got the management
-- job the most. Using the Marketing Data, write a query to show the education level that gets 
-- the management position the most. Let your output show the EDUCATION, JOB and the COUNT OF
-- JOBS columns.


SELECT TOP 1 [education], [job], COUNT([job]) AS 'Count of Jobs'
FROM [dbo].[Marketing data]
WHERE [Job] = 'management'
GROUP BY [Education], [job]
ORDER BY 'Count of Jobs' DESC


--Question 14
-- Write a query to show the average duration of customers employment in 
-- management positions. The duration should be calculated in years.

SELECT * FROM [dbo].[Marketing data]

SELECT CONVERT(int, AVG([duration]) / 52) AS 'Average Duration (Years)'
FROM [dbo].[Marketing data]
WHERE [job] = 'management'


--Question 15
-- What's the total number of customers that have housing, loan and are single?

SELECT [housing], [loan], [marital], COUNT([marital]) AS 'Total #'
FROM [dbo].[Marketing data]
WHERE [Housing] = 'yes' AND [loan] = 'yes' AND [marital] = 'single'
GROUP BY [Housing], [loan], [marital];

----------------------

SELECT [housing], [loan], [marital], COUNT([marital]) AS 'Total #'
FROM [dbo].[Marketing data]
WHERE [Housing] IN ('yes','no') AND [loan] IN ('yes','no')
GROUP BY [Housing], [loan], [marital];

SELECT [housing], [loan], [marital], COUNT([marital]) AS 'Total #'
FROM [dbo].[Marketing data]
WHERE [Housing] IN ('yes','no') AND [loan] IN ('yes','no') AND [marital] = 'single'
GROUP BY [Housing], [loan], [marital];

SELECT COUNT([marital]) AS 'Total #'
FROM [dbo].[Marketing data]
WHERE [marital] = 'single'

SELECT [housing], [loan], [marital], COUNT([marital]) AS 'Total #'
FROM [dbo].[Marketing data]
WHERE [Housing] IN ('yes','no') AND [loan] IN ('yes','no') AND [marital] = 'married'
GROUP BY [Housing], [loan], [marital];

SELECT COUNT([marital]) AS 'Total #'
FROM [dbo].[Marketing data]
WHERE [marital] = 'married'


--Bonus Question
-- Using the Movie Data, write a query to show the movie title with runtime
-- of at least 250. Show the title and runtime columns in your output.

SELECT [title], [runtime] FROM [dbo].[Movie Data]
WHERE [runtime] >= 250
GROUP BY [title], [runtime]


--Question 16
-- Using the Employee Table Dataset, write a query to show all the employees
-- first name, last name and their respective salaries. Also show the overall average 
-- salary of the company and calculate the difference between each employee's
-- salary and the company average salary.

SELECT [first_name], [last_name], [salary],
    (SELECT AVG([salary]) FROM [dbo].[Employees]) AS 'Company Avg Salary',
    ([salary] - (SELECT AVG([salary]) FROM [dbo].[Employees])) AS 'Salary Difference'
FROM [dbo].[Employees];

-- OR

SELECT 
	e.[first_name], 
	e.[last_name], 
	e.[salary],
	a.[Company Avg Salary],
	e.[salary] - a.[Company Avg Salary] AS 'Salary Difference'
FROM [dbo].[Employees] e
CROSS JOIN 
	(SELECT AVG([salary]) AS 'Company Avg Salary'
	FROM [dbo].[Employees]) a;



--Question 17
-- Using the Share Price dataset, write a query to show a table that displays 
-- the highest daily decrease and the highest daily increase in share price.

WITH DailyPriceChange AS 
		(SELECT [date], [open], [close], ROUND(([close] - [open]),2) AS 'Daily Change'
		FROM  [dbo].[SharePrice])
SELECT 
MAX([Daily Change]) AS 'Highest Daily Increase',
MIN([Daily Change]) AS 'Highest Daily Decrease'
FROM  DailyPriceChange

--OR

SELECT 
MAX(ROUND(([close] - [open]),2)) AS 'Highest Daily Increase',
MIN(ROUND(([close] - [open]),2)) AS 'Highest Daily Decrease'
FROM  [dbo].[SharePrice]


