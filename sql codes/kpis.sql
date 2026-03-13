---------------------- KPI 1 ----------------------

select sum(total_revenue) - (select * from vw_total_loss) total_revenue, sum(n_of_orders) [total number of orders] from vw_StoreSalesSummary

---------------------- KPI 2 ----------------------

select (sum(total_revenue) - (select * from vw_total_loss)) / (sum(n_of_orders)) [average order val.] from vw_StoreSalesSummary

---------------------- KPI 3 ----------------------
-- shows all products in low stock

select * from vw_InventoryStatus
order by quantity

---------------------- KPI 4 ----------------------

select * from vw_StoreSalesSummary order by total_revenue

select pb.brand_id, pb.brand_name, count(soi.product_id) [total number of orders] from Production.Brands pb
join Production.Products p on pb.brand_id = p.brand_id
join sales.order_items soi on soi.product_id = p.product_id
join sales.orders so on so.order_id = soi.order_id
group by pb.brand_id, pb.brand_name
order by count(soi.product_id) desc

---------------------- KPI 5 ----------------------

select * from vw_staffperformance


------------------------- KPI 6 --------------------------------------

-- vw_staffperformance-
-- late sent orders/unsent:\

--- 6.1----
select staff_id, store_id, o.order_id, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) < 0 or datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) is null

--6.2 we can see here that all orders have their their required date.
select * from sales.Orders o
join sales.Order_items oi on o.order_id = oi.order_id
where required_date = 'null'

---6.3 info with year ---
select staff_id, store_id, o.order_id, year(required_date), datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) < 0 or datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) is null

;with cte as (
select staff_id, store_id, o.order_id, year(required_date) year, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) < 0 or datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) is null)
select year, sum(revenue) rev, count(order_id) unsent_orders from cte
where [diff betw. req. and shipped date] is null -- NOTE
group by year

-------------------------------------------- KPI 7 ---------------------------------------------
-- see how many times each product was ordered and its list price.

;with cte1 as (
select *, year(TRY_CONVERT(date, shipped_date)) year from sales.orders), -- where year(TRY_CONVERT(date, shipped_date)) = 2016),
cte2 as (
select * from sales.order_items
)
select product_id, list_price, count(product_id) [ordered times] from cte1 
join cte2 on cte1.order_id = cte2.order_id
group by product_id, list_price
order by count(product_id) desc

------------------------------- KPI 8 -----------------------------
-- rev by year
select year(try_convert(date, shipped_date)) year, sum((list_price * (1 - discount)) * quantity) rev from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
group by year(try_convert(date, shipped_date))
order by sum((list_price * (1 - discount)) * quantity) desc






