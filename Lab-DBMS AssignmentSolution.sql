use order_directory;

create table if	not exists supplier
(supp_id int primary key,
supp_name varchar(50) not null,
supp_city varchar(50) not null,
supp_phone varchar(50) not null);

create table if	not exists customer
(cus_id int primary key,
cus_name varchar(20) not null,
cus_phone varchar(10) not null,
cus_city varchar(30) not null,
cus_gender char);

create table if not exists category
(cat_id int primary key,
cat_name varchar(20) not null);

create table if not exists product
(pro_id int primary key,
pro_name varchar(20) not null default "Dummy",
pro_desc varchar(60),
cat_id int,
foreign key (cat_id) references category(cat_id));

create table if not exists supplier_pricing
(pricing_id int primary key,
pro_id int,
supp_id int,
supp_price int default 0,
foreign key(pro_id) references product(pro_id),
foreign key(supp_id) references supplier(supp_id));

create table if not exists orders
(ord_id int primary key,
ord_amount int not null,
ord_date date not null,
cus_id int,
pricing_id int,
foreign key (cus_id) references customer(cus_id),
foreign key (pricing_id) references supplier_pricing(pricing_id));

create table if not exists rating
(rat_id int primary key,
ord_id int,
rat_ratstars int not null,
foreign key (ord_id) references orders(ord_id));

insert into supplier values 
(1, "Rajesh Retails", "Delhi", "1234567890"),
(2, "Appario Ltd.", "Mumbai", "2589631470"),
(3, "Knome products", "Banglore", "9785462315"),
(4, "Bansal Retails", "Kochi", "8975463285"),
(5, "Mittal Ltd", "Lucknow", "7898456532");

insert into customer values 
(1, "AAKASH", "9999999999", "DELHI","M"),
(2, "AMAN", "9785463215", "NOIDA","M"),
(3, "NEHA", "9999999999", "MUMBAI","F"),
(4, "MEGHA", "9994562399", "KOLKATA","F"),
(5, "PULKIT", "7895999999", "LUCKNOW","M");

insert into category values 
(1, "BOOKS"),
(2, "GAMES"),
(3, "GROCERIES"),
(4, "ELECTRONICS"),
(5, "CLOTHES");

insert into product values 
(1, "GTA V", "Windows 7 and above with i5 processor and 8GB RAM", 2),
(2, "TSHIRT", "Windows 7 and above with i5 processor and 8GB RAM", 5),
(3, "ROG LAPTOP", "Windows 7 and above with i5 processor and 8GB RAM", 4),
(4, "OATS", "Windows 7 and above with i5 processor and 8GB RAM", 3),
(5, "HARRY POTTER", "Windows 7 and above with i5 processor and 8GB RAM", 1),
(6, "HARRY POTTER", "Windows 7 and above with i5 processor and 8GB RAM", 3),
(7, "HARRY POTTER", "Windows 7 and above with i5 processor and 8GB RAM", 4),
(8, "HARRY POTTER", "Windows 7 and above with i5 processor and 8GB RAM", 5),
(9, "HARRY POTTER", "Windows 7 and above with i5 processor and 8GB RAM", 2),
(10, "HARRY POTTER", "Windows 7 and above with i5 processor and 8GB RAM", 5),
(11, "HARRY POTTER", "Windows 7 and above with i5 processor and 8GB RAM", 5),
(12, "HARRY POTTER", "Windows 7 and above with i5 processor and 8GB RAM", 1);

insert into supplier_pricing values 
(1, 1, 2, 1500),
(2, 3, 5, 30000),
(3, 5, 1, 3000),
(4, 2, 3, 2500),
(5, 4, 1, 1000);

insert into orders values 
(101, 1500, '2021-10-06', 2, 1),
(102, 1000, '2021-10-06', 3, 5),
(103, 30000, '2021-10-06', 5, 2),
(104, 1500, '2021-10-06', 1, 1),
(105, 3000, '2021-10-06', 4, 3),
(106, 1450, '2021-10-06', 1, 1),
(107, 789, '2021-10-06', 3, 2),
(108, 780, '2021-10-06', 5, 3),
(109, 3000, '2021-10-06', 5, 3),
(110, 2500, '2021-10-06', 2, 4),
(111, 1000, '2021-10-06', 4, 5),
(112, 789, '2021-10-06', 4, 1),
(113, 31000, '2021-10-06', 1, 2),
(114, 1000, '2021-10-06', 3, 5),
(115, 3000, '2021-10-06', 5, 3),
(116, 99, '2021-10-06', 2, 1);

insert into rating values 
(1, 101, 4),
(2, 102, 3),
(3, 103, 1),
(4, 104, 2),
(5, 105, 4),
(6, 106, 3),
(7, 107, 4),
(8, 108, 4),
(9, 109, 3),
(10, 110, 5),
(11, 111, 3),
(12, 112, 4),
(13, 113, 2),
(14, 114, 1),
(15, 115, 1),
(16, 116, 0);

select count(t2.cus_gender) as NoOfCustomers, t2.cus_gender from (select t1.cus_id, t1.cus_gender, t1.ord_amount,t1.cus_name from (select orders.*, cus_gender, cus_name from Orders inner join customer where orders.cus_id = customer.cus_id having orders.ord_amount>=3000) as t1 group by t1.cus_id) as t2 group by t2.cus_gender;


select product.pro_name, orders.* from orders, supplier_pricing, product where orders.cus_id=2 and orders.pricing_id=supplier_pricing.pricing_id and supplier_pricing.pro_id=product.pro_id;

select supplier.* from supplier where supplier.supp_id in (select supp_id from supplier_pricing group by supp_id having count(supp_id)>1 );

select category.cat_id, category.cat_name , min(t3.min_price) as Min_Price from category inner join (select product.cat_id, product.pro_name, t2.* from product inner join (select pro_id,min(supp_price) as Min_Price from supplier_pricing group by pro_id ) as t2 where t2.pro_id=product.pro_id) as t3 where t3.cat_id=category.cat_id group by t3.cat_id;

select product.pro_id, product.pro_name from orders inner join supplier_pricing on supplier_pricing.pricing_id=orders.Pricing_id inner join product on product.pro_id=supplier_pricing.pro_id where orders.ord_date>'2021-10-05';

select customer.cus_name, customer.cus_gender from customer where customer.cus_name like 'A%' or customer.cus_name like '%A';