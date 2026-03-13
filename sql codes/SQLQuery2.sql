-- revenue year by year
select year(try_convert(date, shipped_date)) year, sum((list_price * (1 - discount)) * quantity) rev from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
group by year(try_convert(date, shipped_date))
order by sum((list_price * (1 - discount)) * quantity) desc


------------------------------------------------------------------------------------------------------------

select * from sales.orders
select * from sales.order_items

;with cte1 as (
select *, year(TRY_CONVERT(date, shipped_date)) year from sales.orders where year(TRY_CONVERT(date, shipped_date)) = 2017),
cte2 as (
select * from sales.order_items
)
select product_name, p.list_price, sum(quantity) [sold quant] from cte1 
join cte2 on cte1.order_id = cte2.order_id
join Production.Products p on cte2.product_id = p.product_id
join Production.brands b on b.brand_id = p.brand_id
group by product_name, p.list_price
order by sum(quantity) desc

-- 2018(3) -> 1340.897592 [77] -> (2) 1543.089698 [332] -> (1) 1701.990389 [54] ---> 1545.934146 (0.10)
-- 2017(3) -> 1220.818981 [216] -> (2) 1270.589944 [1431] -> (1) 1095.667580 [216] ---> 1233.035884 (0.10)
-- 2016(3) -> 1083.705838 [161] -> (2) 990.123851 [1202] -> (1) 1084.045799 [369] ---> 1018.832800 (0.10)


-- 2017	3338249.9247 (yillik foydalar)
-- 2016	2372849.1962
-- NULL	1026501.3135
-- 2018	951516.1232





