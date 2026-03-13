-------------------------- 1 ------------------

create view vw_StoreSalesSummary as
select store_id, sum((list_price * quantity) * (1 - discount)) total_revenue, count(oi.order_id) n_of_orders, avg((list_price * quantity) * (1 - discount)) aov from sales.order_items oi
join sales.Orders ord on ord.order_id = oi.order_id
group by store_id
go

select * from vw_StoreSalesSummary

-------------------------- 2 ------------------
create view vw_TopSellingProducts as
select product_id, sum(quantity) sold_quant, rank() over(order by sum(quantity) desc) rank_by_quant from sales.order_items group by product_id
go

-------------------------- 3 ------------------
create view vw_InventoryStatus as
select * from Production.Stocks
where quantity <= (select avg(quantity) from Production.stocks)
go

select * from vw_InventoryStatus

-------------------------- 4 ------------------
create view vw_StaffPerformance as
select staff_id, store_id, o.order_id, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
go

select * from vw_StaffPerformance

-------------------------- 5 ------------------

create view vw_RegionalTrends as
select city, state, sum((list_price * quantity) * (1 - discount)) total_revenue from sales.Stores s
join sales.Orders o on s.store_id = o.store_id
join Sales.order_items oi on o.order_id = oi.order_id
group by city, state
go

select * from vw_RegionalTrends

-------------------------- 6 ------------------
select * from Production.Products
select * from sales.order_items
select * from Production.Categories

select * from Production.Categories c
join Production.Products p on p.category_id = c.category_id
join sales.order_items oi on p.product_id = oi.product_id

------------------------- 7 --------------------------------------

-- vw_staffperformance-
-- late sent orders/unsent:
select staff_id, store_id, o.order_id, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) < 0 or datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) is null

-- we can see here that all orders have their their required date.
select * from sales.Orders o
join sales.Order_items oi on o.order_id = oi.order_id

select staff_id, store_id, o.order_id, year(required_date), datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) < 0 or datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) is null

;with cte as (
select staff_id, store_id, o.order_id, year(required_date) year, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) < 0 or datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) is null)
select year, sum(revenue) from cte
where [diff betw. req. and shipped date] is null
group by year

-------------------------------- 8 ------------------------------
-- listing all unsent orders:
create view vw_unsentOrders as
select * from sales.Orders where order_status != 4


------------------------- 9-------------------------------------------
---------------- returning total loss overall based on UNSENT orders. 
create view vw_total_loss as
with cte as (
select staff_id, store_id, o.order_id, year(required_date) year, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) < 0 or datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) is null)
select sum(revenue) quant from cte
where [diff betw. req. and shipped date] is null












