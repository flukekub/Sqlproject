
with category_sales as(
select 
category,
sum(sales_amount) total_sales
from gold.fact_sales f
left join gold.dim_products p
on p.product_key = f.product_key
group by category
)
select category ,
total_sales,
sum(total_sales) over() as overall_sales,
ConCat(round((Cast (total_sales as float )/sum(total_sales)over ())*100,2),'%') as percentage
from category_sales
order by overall_sales desc