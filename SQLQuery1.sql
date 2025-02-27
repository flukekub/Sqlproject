select 
YEAR(order_date) as order_year,
MONTH(order_date) as order_month,
sum(sales_amount) as total_Sales
from gold.fact_sales
where order_date is not null
group by YEAR(order_date),MONTH(order_date)
order by YEAR(order_date),MONTH(order_date)

