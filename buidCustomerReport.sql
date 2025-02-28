create view gold.report_customers as 
with base_query AS(
/*
1 Base Query: Retrieves core columns from tables
*/
select
f.order_number,
f.product_key,
f.order_date ,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
concat( c.first_name,' ' ,c.last_name ) as customer_name,
DATEDIFF(year, c.birthdate, GETDATE()) as customer_age
from gold.fact_sales f 
left join gold.dim_customers c 
on f.customer_key = c.customer_key
where f.order_date is not null
)
, customer_aggregation as(
/*
2 aggregation
*/
select 
customer_key,
customer_number,
customer_name,
customer_age,
count(distinct order_number )as total_orders,
sum(sales_amount)as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products,
Max(order_date) as last_order_date,
DATEDIFF(month , Max(order_date),getdate()) as lifespan
from base_query
group by
customer_key,
customer_number,
customer_name,
customer_age
)
select 
customer_key,
customer_number,
customer_name,
customer_age,
case 
	when customer_age <20 then 'Under 20'
	when customer_age between 20 and 29 then '20-29'
	when customer_age between 30 and 39 then '30-39'
	when customer_age between 40 and 49 then '40-49'
	Else '50 and above'
END AS age_group,
Case 
	when lifespan >= 12 and total_sales > 500 then 'VIP'
	when lifespan >= 12 and total_sales <= 500 then 'Regular'
	Else 'New'
End as customer_segment,
DateDIff(month,last_order_date,getdate()) as recency,
total_orders,
total_sales,
total_quantity ,
total_products,
lifespan,
-- Compuate average order value(AVO)
Case when total_orders = 0 then 0
	 else total_sales / total_orders
END as avg_order_value,
--compuate average monthly spend 
case when lifespan = 0 then total_sales
	 else total_sales / lifespan
end as avg_monthly_spend
from customer_aggregation

