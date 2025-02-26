SELECT * FROM df_orders

--Find top 10 highest revenue generating products
SELECT TOP 10 product_id, sub_category, sum(sale_price) as sales
FROM df_orders
GROUP BY product_id, sub_category
ORDER BY sales DESC

--Find top 5 highest selling products in each region
With cte as
(SELECT region, product_id, sub_category, sum(sale_price) as sales
FROM df_orders
GROUP BY region, product_id, sub_category
)

SELECT * FROM 
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY region ORDER BY sales DESC) as rn
From
cte
) as a
WHERE rn<=5

--Find MoM growth comparison for 2022 and 2023 sales eg: Jan 2022 vs Jan 2023

--For each category which month had highest sales
With cte as 
(
SELECT category, format(order_date, 'yyyyMM') as order_year_months, sum(sale_price) as sales
FROM df_orders
GROUP BY category,  format(order_date, 'yyyyMM') 
--ORDER BY category,  format(order_date, 'yyyyMM') 
)
select * from(
SELECT *, 
ROW_NUMBER() OVER (Partition by category order by sales desc) as rnk
FROM cte) as a
where rnk =1
