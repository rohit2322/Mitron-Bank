-- 1. Demographic Classification
-- How many customers are there by gender?
select
	gender,
	count(*) as total_customer
from customers
group by gender;

-- What is the distribution of customers across different age groups?
select 
	age_group,
    count(*) as total_customer
from customers
group by age_group;

-- How many customers are there in each occupation category?
select 
	occupation,
    count(*) as total_customer
from customers
group by occupation;

-- What is the city-wise distribution of customers?
select 
	city,
    count(*) as total_customer
from customers
group by city;

-- What is the marital status distribution of the customers?
select 
	marital_status,
    count(*) as total_customer
from customers
group by marital_status;


-- 2. Average Income Utilisation %
-- What is the total spending for each customer?
select 
	customer_id,
    sum(avg_income) as total_spend
from customers
group by customer_id;

-- What is the average income utilisation percentage (avg_spends/avg_income) for each customer?
SELECT c.customer_id, 
       (SUM(f.spends) / c.avg_income) * 100 AS avg_income_utilisation_percentage
FROM customers c
JOIN fact_spends f ON c.customer_id = f.customer_id
GROUP BY c.customer_id, c.avg_income;

-- What is the average income utilisation percentage for each city?
SELECT city, 
       (SUM(f.spends) / SUM(c.avg_income)) * 100 AS avg_income_utilisation_percentage
FROM customers c
JOIN fact_spends f ON c.customer_id = f.customer_id
GROUP BY city;

-- How does the average income utilisation percentage vary by occupation?
SELECT occupation, 
       (SUM(f.spends) / SUM(c.avg_income)) * 100 AS avg_income_utilisation_percentage
FROM customers c
JOIN fact_spends f ON c.customer_id = f.customer_id
GROUP BY occupation;

-- What is the average income utilisation percentage by age group?
SELECT age_group, 
       (SUM(f.spends) / SUM(c.avg_income)) * 100 AS avg_income_utilisation_percentage
FROM customers c
JOIN fact_spends f ON c.customer_id = f.customer_id
GROUP BY age_group;

-- 3 Spending Insights
-- What is the total spending for each category (Entertainment, Apparel, etc.)?
select 
	category,
    sum(spends)
from fact_spends
group by category;

-- Which payment type (Credit Card, Debit Card, UPI, Net Banking) is most commonly used?
select
	payment_type,
    count(payment_type) as payment_type_repeat_count
from fact_spends
group by payment_type;

-- How does spending differ across different cities?
select
	c.city,
    sum(f.spends) as total_spend
from customers as c
join fact_spends as f on c.customer_id=f.customer_id
group by c.city;

-- How does spending vary by gender?
select 
	c.gender,
    sum(f.spends) as total_spend
from customers as c
join fact_spends as f on c.customer_id=f.customer_id
group by c.gender;

-- Which age group spends the most on average?
SELECT 
    c.age_group,
    AVG(f.spends) AS avg_spend
FROM customers AS c
JOIN fact_spends AS f ON c.customer_id = f.customer_id
GROUP BY c.age_group
ORDER BY avg_spend DESC;

-- What are the top spending categories for each occupation?
SELECT 
    c.occupation,
    f.category,
    SUM(f.spends) AS total_spend
FROM customers AS c
JOIN fact_spends AS f ON c.customer_id = f.customer_id
GROUP BY c.occupation, f.category
ORDER BY c.occupation, total_spend DESC;

-- Which month has the highest spending overall?
select 
	f.month,
    sum(spends) as total_spend
from fact_spends as f
group by f.month
order by sum(spends) desc
limit 1;

-- How do spending patterns vary across months by category?
select 
	month,
    category,
    sum(spends)
from fact_spends
group by month,category;

-- 4. Key Customer Segments
-- Which city has the highest proportion of high-spending customers?
SELECT 
    c.city, 
    COUNT(f.customer_id) AS high_spenders
FROM customers AS c
JOIN fact_spends AS f ON c.customer_id = f.customer_id
WHERE f.spends > (SELECT AVG(spends) FROM fact_spends)
GROUP BY c.city
ORDER BY COUNT(f.customer_id) DESC
LIMIT 1;

-- Which occupation group contributes the most to overall spending?
SELECT 
    c.occupation, 
    SUM(f.spends) AS total_spending
FROM customers AS c
JOIN fact_spends AS f ON c.customer_id = f.customer_id
GROUP BY c.occupation
ORDER BY SUM(f.spends) DESC
LIMIT 1;

-- What is the demographic profile of customers with the highest average income utilisation?
SELECT 
    c.age_group,
    c.gender,
    c.city,
    c.occupation,
    (SUM(f.spends) / AVG(c.average_income)) * 100 AS income_utilisation_percentage
FROM customers AS c
JOIN fact_spends AS f ON c.customer_id = f.customer_id
GROUP BY c.age_group, c.gender, c.city, c.occupation
ORDER BY income_utilisation_percentage DESC
LIMIT 1;

-- How does spending correlate with marital status?
SELECT 
    c.marital_status, 
    SUM(f.spends) AS total_spending
FROM customers AS c
JOIN fact_spends AS f ON c.customer_id = f.customer_id
GROUP BY c.marital_status;


-- 5. Credit Card Feature Recommendations
-- Based on spending patterns, which categories should be targeted for credit card rewards?
SELECT 
    f.category, 
    SUM(f.spends) AS total_spending
FROM fact_spends AS f
GROUP BY f.category
ORDER BY SUM(f.spends) DESC;

-- Which demographic groups should be prioritized for promotional offers?
SELECT 
    c.age_group,
    c.gender,
    c.city,
    SUM(f.spends) AS total_spending
FROM customers AS c
JOIN fact_spends AS f ON c.customer_id = f.customer_id
GROUP BY c.age_group, c.gender, c.city
ORDER BY SUM(f.spends) DESC;

-- What are the key features that customers in each occupation group might value most in a credit card?
SELECT 
    c.occupation,
    f.category,
    SUM(f.spends) AS total_spending
FROM customers AS c
JOIN fact_spends AS f ON c.customer_id = f.customer_id
GROUP BY c.occupation, f.category
ORDER BY c.occupation, SUM(f.spends) DESC;

-- What type of payment methods should the credit card incentivize to match customer preferences? give query and questions
SELECT 
    f.payment_type, 
    SUM(f.spends) AS total_spending
FROM fact_spends AS f
GROUP BY f.payment_type
ORDER BY SUM(f.spends) DESC;
