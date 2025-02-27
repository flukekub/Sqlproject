




with nnn As (
select Year(f.order_date) as order_year ,
p.product_name,
sum(f.sales_amount) as current_sales
from gold.fact_sales f 
Left join gold .dim_products p
on f.product_key = p.product_key
where f.order_date is not null
group by Year(f.order_date ),
p.product_name
)
select order_year , 
product_name , 
current_sales , 
avg( current_sales) over( partition by product_name )  as avg_y,
current_sales -  avg( current_sales) over( partition by product_name ) as diff,
case when current_sales -  avg( current_sales) over( partition by order_year ) < 0 then 'bad'
	 when current_sales -  avg( current_sales) over( partition by order_year ) >= 0 then 'normal'
	 else 'avg'
end avg_change
from nnn 
order by product_name, order_year