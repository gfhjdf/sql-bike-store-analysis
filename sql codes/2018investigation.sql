select product_id, count(product_id) from sales.Orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, order_date)) = 2018 and shipped_date = 'null'
group by product_id


-- overall, there're 879; 292 distinct orders - 138 of them weren't sent (revenue from these orders could bring 871736.3887); 


exec sp_store_info_basedony @year = 2016, @store_id = 3

select * from vw_StoreSalesSummary

-- year	store_id	overall_rev		total_orders
-- 2018	1			166,635.5073		77

-- year	store_id	overall_rev		total_orders
-- 2018	2			690,847.3167		332

-- year	store_id	overall_rev		total_orders
-- 2018	3			94,033.2992		54


select sum(list_price * quantity * (1 - discount)) from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, shipped_date)) = 2018 and year(try_convert(date, shipped_date)) is not null
-- group by year(try_convert(date, shipped_date))




-- year(try_convert(date, shipped_date)) year, sum(list_price * quantity * (1 - discount)) total_rev


-- how much money we could get from orders if they were sent(year by year): (2018 - 871,736.3887)
;with cte as (
select staff_id, store_id, o.order_id, year(required_date) year, datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) [diff betw. req. and shipped date], (list_price * quantity) * (1 - discount) revenue from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) < 0 or datediff(day, try_convert(date, required_date), try_convert(date, shipped_date)) is null)
select year, sum(revenue) from cte
where [diff betw. req. and shipped date] is null
group by year


---- these products were out of stock when they were ordered in 2018; the code returns how much money could be gained if they were available. (66,385.3499)
;with cte1 as (
select product_id, list_price, discount, sum(quantity) n from sales.Orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, order_date)) = 2018 and shipped_date = 'null'
group by product_id, list_price, discount),
cte2 as(
select * from vw_InventoryStatus
)
select sum(list_price * n * (1 - discount)) from cte1
join cte2 on cte1.product_id = cte2.product_id
where quantity = 0


;with cte1 as (
select product_id, count(product_id) n from sales.Orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, order_date)) = 2018 and shipped_date = 'null'
group by product_id),
cte2 as(
select * from vw_InventoryStatus
)
select * from cte1
join cte2 on cte1.product_id = cte2.product_id
where quantity = 0

-------------------------------------------------------------------------------------------------------------------------
-- OVERALL IF ALL ORDERS WERE SENT IN 2018, WE COULD GAIN this amount of money: (1,814,529.7875)
select sum(quantity * list_price * (1 - discount)) from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, order_date)) = 2018

-- CURRENT(actual) GAINED AMOUNT OF MONEY in 2018: (951,516.1232)
select sum(quantity * list_price * (1 - discount)) from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, shipped_date)) = 2018

select * from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, order_date)) = 2018


------------------ 2016 / STORE 2 --------------------------------------------------------------------

select sum(quantity * list_price * (1 - discount)) from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, shipped_date)) = 2016



exec sp_store_info_basedony @year = 2018, @store_id = 2


-- year	store_id	overall_rev		total_orders
-- 2016	2			1,585,135.6873	1202

-- year	store_id	overall_rev	total_orders
-- 2017	2	2,425,226.5623	1431

-- year	store_id	overall_rev	total_orders
-- 2018	2	690,847.3167	332


----------------------- CHECKING THE DIFF BETWEEN REQUIRED DATE AND SHIPPED DATE -------------------------------------------------------------

-- seeing all lately sent orders: -- 305,551.0681 / for 2nd store -> 247,278.8648 (37 orders) (182 products)
select sum(list_price * quantity * (1 - discount)) from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, order_date)) = 2018 and DATEDIFF(day, try_convert(date, shipped_date), try_convert(date, required_date)) < 0 and store_id = 2

select sum(list_price * quantity * (1 - discount)) from sales.orders o -- 463,339.4088(half of the overall lost for 2018) for 2nd store; (66 orders); (322 products)
join sales.order_items oi on o.order_id = oi.order_id
where year(try_convert(date, order_date)) = 2018 and DATEDIFF(day, try_convert(date, shipped_date), try_convert(date, required_date)) is null and store_id = 2


--------------------------- CHECKING DISCOUNTS -----------------------------------------
select year(try_converT(date, shipped_date)), avg(discount) from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
group by year(try_converT(date, shipped_date))

