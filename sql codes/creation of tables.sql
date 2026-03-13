------------1-----------------------
create table Sales.Customers (
	customer_id int primary key,
	first_name varchar(100),
	last_name varchar(100),
	phone varchar(25),
	email varchar(100),
	street varchar(100), 
	city varchar(50),
	state varchar(5),
	zip_code varchar(10)
)

------------2-----------------------

create table Sales.Staffs (
	staff_id int primary key,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(100),
	phone varchar(25),
	active int,
	store_id int,
	manager_id int
)

------------3-----------------------

create table Sales.Orders (
	order_id int primary key,
	customer_id int,
	order_status int,
	order_date nvarchar(20),
	required_date nvarchar(20),
	shipped_date nvarchar(20),
	store_id int,
	staff_id int
)


------------4-----------------------

create table Sales.Stores (
	store_id int primary key,
	store_name varchar(50),
	phone varchar(20),
	email varchar(100),
	street varchar(50),
	city varchar(50),
	state varchar(5),
	zip_code varchar(15)
)

------------5-----------------------

create table Sales.order_items (
	order_id int,
	item_id int,
	product_id int,
	quantity int,
	list_price decimal(10, 2),
	discount decimal(5, 2)
)


------------6-----------------------

create schema Production

create table Production.Categories (
	category_id int primary key,
	category_name varchar(100)
)

------------7-----------------------

create table Production.Products (
	product_id int primary key,
	product_name varchar(100),
	brand_id int,
	category_id int,
	model_year int,
	list_price decimal(10, 2)
)


------------8-----------------------
select * from Production.Stocks

create table Production.Stocks (
	store_id int,
	product_id int,
	quantity int
)

------------9-----------------------

create table Production.Brands (
	brand_id int primary key,
	brand_name varchar(100)
)





