select order_month, sales_month, sum( sales_month) over (order by order_month) as trend
from(
select Datetrunc(month,order_date) as order_month, sum(sales_amount) as sales_month
from gold.fact_sales 
where Datetrunc(month,order_date) is not null
group by Datetrunc(month,order_date) 

)t