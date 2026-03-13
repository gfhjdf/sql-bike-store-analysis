-----------------1--------------------------
bulk insert Sales.Customers from 'D:\bike stores\data\customers.csv' with (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '\n'
)

select * from sales.Customers


-----------------2--------------------------


select * from sales.Orders

bulk insert Sales.orders from 'D:\bike stores\data\orders.csv' with (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '0x0a'
)

-----------------3--------------------------

select * from Production.Products

bulk insert Production.Products from 'D:\bike stores\data\products.csv' with (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '0x0a'
)

-----------------4--------------------------

select * from sales.Stores

bulk insert sales.Stores from 'D:\bike stores\data\stores.csv' with (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '0x0a'
)


-----------------5--------------------------

select * from sales.Staffs

bulk insert sales.Staffs from 'D:\bike stores\data\staffs.csv' with (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '0x0a'
)

insert into sales.staffs values (1,'Fabiola','Jackson','fabiola.jackson@bikes.shop','(831) 555-5554',1,1,NULL)
-----------------6--------------------------

select * from Production.Stocks

bulk insert Production.stocks from 'D:\bike stores\data\stocks.csv' with (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '0x0a'
)


-----------------7--------------------------

select * from Production.Categories

bulk insert Production.Categories from 'D:\bike stores\data\categories.csv' with (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '0x0a'
)


-----------------8--------------------------

select * from Production.Brands

bulk insert Production.Brands from 'D:\bike stores\data\brands.csv' with (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '0x0a'
)

-----------------9--------------------------
select * from Sales.order_items

bulk insert sales.order_items from 'D:\bike stores\data\order_items.csv' with (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '0x0a'
)


----------------adding constraints-----------------------------------

alter table sales.orders
add constraint fk_orders_cust foreign key (customer_id) references sales.customers(customer_id)

alter table sales.orders
add constraint fk_orders_staffs foreign key (staff_id) references sales.staffs(staff_id)

alter table sales.orders
add constraint fk_orders_stores foreign key (store_id) references sales.stores(store_id)

alter table sales.order_items
add constraint fk_orders_items_ord foreign key (order_id) references sales.orders(order_id)
----------------------

alter table production.stocks
add constraint fk_stores_stocks foreign key (store_id) references sales.stores(store_id)

alter table sales.order_items
add constraint fk_order_items_prod foreign key (product_id) references production.products(product_id)

alter table production.products
add constraint fk_prod_cats foreign key (category_id) references production.categories(category_id)

alter table production.products
add constraint fk_prod_brands foreign key (brand_id) references production.brands(brand_id)




