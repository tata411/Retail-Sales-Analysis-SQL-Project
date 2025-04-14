--Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022:
select *
from retail_sales_utf
where category = 'Clothing' and
	quantity >= 4 and
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	
-- calculate the total sales (total_sale) for each category:
select 
category,
sum(total_sale) as total_sale
from retail_sales_utf 
group by category
order by 2 desc;

--find the average age of customers who purchased items from the 'Beauty' category:
select
round(avg(age)) as avg_age
from retail_sales_utf 
where category = 'Beauty'
group by category;

--find all transactions where the total_sale is greater than 1000:
select *
from retail_sales_utf 
where total_sale > 1000;

--find the total number of transactions (transaction_id) made by each gender in each category:
select COUNT(transactions_id) as number_of_transactions,
category,
gender 
from retail_sales_utf rsu 
group by 2,3
order by 1 desc;

--calculate the average sale for each month. Find out best selling month in each year:
with subq1 as (select round(AVG(total_sale),2) as avg_sale,
extract(year from sale_date) as year,
extract (month from sale_date) as month,
rank() over(partition by extract (year from sale_date) order by AVG(total_sale)) as rank
from retail_sales_utf
group by 2,3)

select month,
year, avg_sale
from subq1 
where rank=1;

--find the top 5 customers based on the highest total sales:
with subq2 as(
select customer_id,
SUM(total_sale) as total_sale_per_customer,
RANK() OVER(order by sum(total_sale) desc) as rank
from retail_sales_utf rsu 
group by customer_id
)
select customer_id, total_sale_per_customer
from subq2 
where rank <=5

--find the number of unique customers who purchased items from each category:
select category,
COUNT(distinct customer_id) as cnt_unique_customers
from retail_sales_utf rsu 
group by category

--create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17
select count(distinct transactions_id) as cnt_orders,
case when sale_time < '12:00:00' then  'Morning' 
	when sale_time between '12:00:00' and '17:00:00' then 'Afternoon'
	else 'Evening'
	end as shift
from retail_sales_utf rsu 
group by shift



