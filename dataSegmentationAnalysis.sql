/*Group customers into threee segments based on their spending behavior:
	- VIP : Customers with at least 12 months of history and spending more than 5,000.
	- Regular: Customers with at least 12 months of history byt spending 5000 or less.
	- New : Customers with a lifespan less than 12 months.
	And find the total number of customers by each group
	*/
	
	with cus_spend as (
	select 
	c.customer_key,
	sum(sales_amount)as total_spending , 
	
	 min(order_date)  as first_order,
	 max(order_date) as last_order,
	 datediff(month,min(order_date), max(order_date)) as lifespan
	from gold.fact_sales f
	left join gold.dim_customers c 
	on f.customer_key = c.customer_key
	group by c.customer_key
	)
	select tier,
	count(customer_key) as total
	from (
	select 
	customer_key,
	case when lifespan >= 12 and total_spending > 5000 then 'VIP'
		 when lifespan >= 12 and total_spending <= 5000 then 'Regular'
		 Else  'new'
	end tier
	
	from cus_spend
	) t
	group by tier
	order by count(customer_key)