SELECT * FROM sales_data_walmart.`walmartsalesdata.csv`;

SELECT * FROM wm_sales;


-- -----------------------------------------------------------------------------------------------------------
-- ------------------------------------------- Feature Engineering -------------------------------------------

SELECT 

	time, (CASE 
			WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
            WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
            ELSE "Evening" END) AS Time_Of_Day 
FROM wm_sales;


-- -----------------------------------------------------------------------------------------------------------
-- ----------------------------------------- ADD TIME_OF_DAY -------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------
ALTER TABLE wm_sales ADD COLUMN Time_Of_Day VARCHAR(30);

UPDATE wm_sales
SET Time_Of_Day= (
CASE 
			WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
            WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
            ELSE "Evening" END
);
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------


-- --------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- ADD DAY_NAME --------------------------------------------------

SELECT 
	date,
    DAYNAME(date) AS Day_Name
FROM wm_sales;

ALTER TABLE wm_sales ADD COLUMN Day_Name VARCHAR(15);

UPDATE wm_sales
SET Day_Name = DAYNAME(date);


-- ----------------------------------------------------------------
-- ----------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------- ADD MONTH NAME --------------------------------------------------

SELECT 
	DATE,
    MONTHNAME(DATE)
FROM wm_sales;


ALTER TABLE wm_sales ADD COLUMN Month_Name VARCHAR(10);

UPDATE wm_sales
SET Month_Name = MONTHNAME(DATE);

-- ---------------------------------------------------------------
-- ---------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------------
-- -------------------------------------------- GENERIC QUESTIONS ---------------------------------------------

-- How many unique cities does the data have?

SELECT DISTINCT City FROM wm_sales;


-- How many unique Branch does the data have?

SELECT DISTINCT Branch, City FROM wm_sales;


-- ------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------- PRODUCT QUESTIONS ------------------------------------------------

-- How many unique product lines does the data have?

SELECT COUNT(DISTINCT product_line) FROM wm_sales;

-- --------------------------------------------------

-- What is the most common payment method?

SELECT Payment,
	COUNT(Payment) AS Count
FROM wm_sales
GROUP BY Payment
ORDER BY Count DESC;

-- --------------------------------------------------

-- --------------------------------------------------
-- What is the most selling product line?

SELECT Product_line,
		COUNT(Product_line) Count 
FROM wm_sales
GROUP BY Product_line
ORDER BY Count DESC;
-- ----------------------------------------------------

-- What is the total revenue by month?

SELECT 
	Month_Name AS Month,
    SUM(Total) AS Total_Revenue
FROM wm_sales
GROUP BY Month_Name
ORDER BY SUM(Total);

-- ----------------------------------------------------

-- What month had the largest COGS?

SELECT Month_Name AS Month,
		SUM(cogs) AS Cogs
FROM wm_sales
GROUP BY Month_Name
ORDER BY cogs DESC;

-- ------------------------------------------------

-- What product line had the largest revenue?
SELECT Product_line AS Products,
		SUM(Total) AS Revenue
FROM wm_sales
GROUP BY Product_line
ORDER BY  Revenue DESC;

-- ------------------------------------------------
-- What is the city with the largest revenue?

SELECT City AS city,
	SUM(Total) AS Revenue
FROM wm_sales
GROUP BY City
ORDER BY Revenue DESC;

-- -----------------------------------------------
-- What product line had the largest VAT?

SELECT Product_line AS P_Line,
	AVG(VAT_TAX) AS VAT
FROM wm_sales
GROUP BY Product_line
ORDER BY VAT DESC;
-- -----------------------------------------------------
-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT product_line,
	AVG(total) AS avg_sales
FROM wm_sales
GROUP BY product_line
ORDER BY avg_sales DESC;





-- ----------------------------------------------------
-- Which branch sold more products than average product sold?

SELECT branch,
	SUM(quantity) AS QTY
FROM wm_sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM wm_sales);
-- ------------------------------------------------------------------

-- What is the most common product line by gender?

SELECT gender, product_line,
		COUNT(gender) as gender_cnt
FROM wm_sales
GROUP BY gender, product_line
ORDER BY gender_cnt DESC;
-- ----------------------------------------------------

-- What is the average rating of each product line?

select avg(rating) from wm_sales;

select product_line,
	round(avg(rating),2) as Product_Rating
from wm_sales 
group by product_line
order by Product_Rating desc;
-- ---------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------- Sales -------------------------------------------------------
-- Number of sales made in each time of the day per weekday

select time_of_day,
		count(*) as sales_count
from wm_sales
group by time_of_day
order by sales_count desc;
-- ------------------------------------------------------ 

-- Which of the customer types brings the most revenue?

select customer_type,
	round(sum(total),2) as total_revenue
from wm_sales
group by customer_type
order by total_revenue desc;
-- ----------------------------------------------------------

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,
	round(sum(vat_tax),2) as tax_percent
from wm_sales
group by city
order by tax_percent DESC;

select city,
	round(avg(vat_tax),2) as tax_percent
from wm_sales
group by city
order by tax_percent DESC;
-- -----------------------------------------------------------------

-- Which customer type pays the most in VAT?
select customer_type,
	round(sum(vat_tax),2) as paid_tax
from wm_sales
group by customer_type
order by paid_tax DESC;

select customer_type,
	round(avg(vat_tax),2) as paid_tax
from wm_sales
group by customer_type
order by paid_tax DESC;

select customer_type,
	round(count(vat_tax),2) as paid_tax
from wm_sales
group by customer_type
order by paid_tax DESC;

-- -------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------- Customer --------------------------------------------------------------

-- How many unique customer types does the data have?
select distinct customer_type from wm_sales;

-- --------------------------------------------------------------
-- How many unique payment methods does the data have?
select distinct payment from wm_sales;

-- ---------------------------------------------------------------

-- What is the most common customer type?
select customer_type,
	count(*) as count
from wm_sales
group by customer_type
order by count desc;
-- --------------------------------------------------------

-- Which customer type buys the most?
select customer_type,
	count(quantity) as quantity
from wm_sales
group by customer_type
order by quantity desc;
-- ------------------------------------------------------------

-- What is the gender of most of the customers?
select gender,
	count(*) as count
from wm_sales
group by gender
order by count desc;
-- ---------------------------------------------------------------------------------------------
-- What is the gender distribution per branch?
select distinct gender, branch,
	count(*) as count
from wm_sales
group by gender, branch
order by count desc;
-- -----------------------------------------------------------------------------------------------
-- Which time of the day do customers give most ratings?
select time_of_day,
	count(rating) as ratings
from wm_sales
group by time_of_day
order by ratings desc;

select time_of_day,
	round(avg(rating),1) as ratings
from wm_sales
group by time_of_day
order by ratings desc;
-- -------------------------------------------------------------------------------------------------------
-- Which time of the day do customers give most ratings per branch?
select time_of_day as Time, branch as Branch,
	round(avg(rating),1) as Branch_Rating
from wm_sales
group by time_of_day, branch
order by branch, branch_rating;
-- --------------------------------------------------------------------------------------------------------

-- Which day of the week has the best avg ratings?

select day_name,
	round(avg(rating),1) as avg_rating
from wm_sales
group by day_name
order by avg_rating desc;
-- ----------------------------------------------------------------------------------------------

-- Which day of the week has the best average ratings per branch?
select day_name, branch,
	round(avg(rating),1) as avg_rating
from wm_sales
group by day_name, branch
order by avg_rating desc;






select round((unit_price*quantity),1) as cogs
from wm_sales;


select * from wm_sales;
