---------------------- 1 ------------------------------------------
create procedure sp_CalculateStoreKPI @id int as
begin
	select * from vw_StoreSalesSummary where store_id = @id
end

exec sp_CalculateStoreKPI @id = 1

---------------------- 2 ------------------------------------------
create procedure sp_GenerateRestockList as 
begin
	select store_id, product_id from vw_InventoryStatus

	select store_id, count(distinct product_id) [n. of diff. products] from vw_InventoryStatus group by store_id

end

exec sp_GenerateRestockList

---------------------- 3 ------------------------------------------
create procedure sp_CompareSalesYearOverYear @year1 int, @year2 int as
begin
	with year1 as(
	select year(try_convert(date, shipped_date)) year, sum(list_price * quantity * (1 - discount)) total_rev from sales.orders o
	join sales.order_items oi on o.order_id = oi.order_id
	where year(try_convert(date, shipped_date)) = @year1 and year(try_convert(date, shipped_date)) is not null
	group by year(try_convert(date, shipped_date))),
	year2 as (
	select year(try_convert(date, shipped_date)) year, sum(list_price * quantity * (1 - discount)) total_rev from sales.orders o
	join sales.order_items oi on o.order_id = oi.order_id
	where year(try_convert(date, shipped_date)) = @year2 and year(try_convert(date, shipped_date)) is not null
	group by year(try_convert(date, shipped_date))
	)
	select abs(year1.total_rev - year2.total_rev) from year1, year2
end

exec sp_CompareSalesYearOverYear @year1 = 2018, @year2 = 2016

---------------------- 4 ------------------------------------------

create procedure sp_GetCustomerProfile @id int as
begin
	select customer_id, count(oi.order_id) total_orders, sum(list_price * quantity * (1 - discount)) total_spent_m from sales.order_items oi
	join sales.orders o on oi.order_id = o.order_id
	where customer_id = @id
	group by customer_id

	select customer_id, p.product_id, p.product_name, oi.order_id from sales.order_items oi
	join sales.orders o on oi.order_id = o.order_id
	join Production.Products p on p.product_id = oi.product_id
	where customer_id = @id
end
go

exec sp_GetCustomerProfile @id = 1

---------------------------------- 5 ------------------------------

create procedure sp_store_info_basedony @year int, @store_id int as 
begin
	;with cte1 as (
	select *, year(TRY_CONVERT(date, shipped_date)) year from sales.orders where year(TRY_CONVERT(date, shipped_date)) = @year and store_id = @store_id),
	cte2 as (
	select * from sales.order_items
	)
	select year, store_id, sum(list_price * (1 - discount) * quantity) overall_rev, count(cte1.order_id) total_orders from cte1 
	join cte2 on cte1.order_id = cte2.order_id group by year, store_id
end


exec sp_store_info_basedony @year = 2017, @store_id = 2


------------------------------- AUTOMATION ---------------------------------
-- creating tables
create table Reports.StoreSalesSummary (store_id int, total_revenue decimal(10, 2), n_of_orders int, aov decimal(10, 2))

----------------- WEEKLY REPORTS----------------------------------:

create procedure sp_weekly_reports as

-------------------- v1 ------------------

begin
	select store_id, sum((list_price * quantity) * (1 - discount)) total_revenue, count(oi.order_id) n_of_orders, avg((list_price * quantity) * (1 - discount)) aov from sales.order_items oi
	join sales.Orders ord on ord.order_id = oi.order_id
	where datepart(week, order_date) = datepart(week, getdate()) and datepart(year, order_date) = datepart(year, getdate())
	group by store_id

-------------------- v2 ------------------

	select product_id, sum(quantity) sold_quant, rank() over(order by sum(quantity) desc) rank_by_quant from sales.order_items group by product_id



-------------------- v3 ------------------

	select * from Production.Stocks
	where quantity <= (select avg(quantity) from Production.stocks)


-------------------- v4 ------------------

	select staff_id, store_id, o.order_id, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
	join sales.order_items oi on o.order_id = oi.order_id
	where datepart(week, order_date) = datepart(week, getdate()) and datepart(year, order_date) = datepart(year, getdate())

-------------------- v5 ------------------

	select city, state, sum((list_price * quantity) * (1 - discount)) total_revenue from sales.Stores s
	join sales.Orders o on s.store_id = o.store_id
	join Sales.order_items oi on o.order_id = oi.order_id
	where datepart(week, order_date) = datepart(week, getdate()) and datepart(year, order_date) = datepart(year, getdate())
	group by city, state

-------------------- v6 ------------------


	select * from Production.Categories c
	join Production.Products p on p.category_id = c.category_id
	join sales.order_items oi on p.product_id = oi.product_id

-------------------- v7 ------------------

select * from sales.Orders where order_status != 4




end




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


exec sp_weekly_reports




----------------- MONTHLY REPORTS----------------------------------:

create procedure sp_monthly_reports as

-------------------- v1 ------------------

begin
	select store_id, sum((list_price * quantity) * (1 - discount)) total_revenue, count(oi.order_id) n_of_orders, avg((list_price * quantity) * (1 - discount)) aov from sales.order_items oi
	join sales.Orders ord on ord.order_id = oi.order_id
	where order_date >= datefromparts(year(getdate()), month(getdate()), 1) and order_date < dateadd(month, 1, datefromparts(year(getdate()), month(getdate()), 1))
	group by store_id

-------------------- v2 ------------------

	select product_id, sum(quantity) sold_quant, rank() over(order by sum(quantity) desc) rank_by_quant from sales.order_items group by product_id



-------------------- v3 ------------------

	select * from Production.Stocks
	where quantity <= (select avg(quantity) from Production.stocks)


-------------------- v4 ------------------

	select staff_id, store_id, o.order_id, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
	join sales.order_items oi on o.order_id = oi.order_id
	where order_date >= datefromparts(year(getdate()), month(getdate()), 1) and order_date < dateadd(month, 1, datefromparts(year(getdate()), month(getdate()), 1))

-------------------- v5 ------------------

	select city, state, sum((list_price * quantity) * (1 - discount)) total_revenue from sales.Stores s
	join sales.Orders o on s.store_id = o.store_id
	join Sales.order_items oi on o.order_id = oi.order_id
	where order_date >= datefromparts(year(getdate()), month(getdate()), 1) and order_date < dateadd(month, 1, datefromparts(year(getdate()), month(getdate()), 1))
	group by city, state

-------------------- v6 ------------------


	select * from Production.Categories c
	join Production.Products p on p.category_id = c.category_id
	join sales.order_items oi on p.product_id = oi.product_id

-------------------- v7 ------------------

select * from sales.Orders where order_status != 4




end



----------------- YEARLY REPORTS----------------------------------:

create procedure sp_yearly_reports as

-------------------- v1 ------------------

begin
	select store_id, sum((list_price * quantity) * (1 - discount)) total_revenue, count(oi.order_id) n_of_orders, avg((list_price * quantity) * (1 - discount)) aov from sales.order_items oi
	join sales.Orders ord on ord.order_id = oi.order_id
	where year(order_date) = year(GETDATE()) 
	group by store_id

-------------------- v2 ------------------

	select product_id, sum(quantity) sold_quant, rank() over(order by sum(quantity) desc) rank_by_quant from sales.order_items group by product_id



-------------------- v3 ------------------

	select * from Production.Stocks
	where quantity <= (select avg(quantity) from Production.stocks)


-------------------- v4 ------------------

	select staff_id, store_id, o.order_id, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
	join sales.order_items oi on o.order_id = oi.order_id
	where year(order_date) = year(GETDATE()) 

-------------------- v5 ------------------

	select city, state, sum((list_price * quantity) * (1 - discount)) total_revenue from sales.Stores s
	join sales.Orders o on s.store_id = o.store_id
	join Sales.order_items oi on o.order_id = oi.order_id
	where year(order_date) = year(GETDATE()) 
	group by city, state

-------------------- v6 ------------------


	select * from Production.Categories c
	join Production.Products p on p.category_id = c.category_id
	join sales.order_items oi on p.product_id = oi.product_id

-------------------- v7 ------------------

select * from sales.Orders where order_status != 4




end








