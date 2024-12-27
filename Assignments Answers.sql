use classicmodels;

-- Question 1 a
select employeenumber,firstname, lastname
from employees
where jobtitle = "sales rep" and reportsto = 1102;

-- Question 1 b
select *from products;
select distinct productline from products
where productline like "%cars";

-- Question 2
select customernumber, customername, 
case 
when country in("usa", "canada") then "North America"
when country in("usa", "france", "germany") then "Europe"
else "Other" 
end as `Customer Segment`
from customers;

-- Question 3a
select productcode, sum(quantityordered) as total_ordered from orderdetails
group by productcode
order by total_ordered desc
limit 10;

-- Question 3b
select monthname(paymentdate) as payment_month, count(customernumber) as num_payment from payments
group by payment_month
having num_payment > 20
order by num_payment desc;

-- Question 4 a
create database if not exists Customers_Orders;
use Customers_Orders;
create table if not exists customers(
customer_id int primary key auto_increment,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(255) unique,
phone_number varchar(20)
);

-- Question 4 b
create table if not exists Orders(
order_id int primary key auto_increment,
customer_id int,
order_date date,
total_amount decimal(10,2) check(total_amount>0),
foreign key(customer_id) references customers(customer_id)
);

-- Question 5
select country , count(ordernumber) `Order Count`
from customers c inner join orders o on c.customernumber = o.customernumber
group by country
order by `Order Count` desc
limit 5;

-- Question 6
create database project_table;
use project_table;

create table project (
EmployeeID int primary key auto_increment,
FullName varchar(50) not null,
Gender char(6) check(Gender in("Male","Female")),
ManagerID int
);
insert into project(FullName, Gender, ManagerID) values
("Pranaya","Male",3),
("Priyanka","Female",1),
("Preety","Female",Null),
("Anurag","Male",1),
("Sambit","Male",1),
("Rajesh","Male",3),
("Hina","Female",3);

select p1.fullname `Manager Name`,
p2.fullname `Emp Name`
from project p1 left join project p2 on p1.employeeid = p2.managerid
where p2.fullname is not null
order by `Manager Name`; 

-- Question 7
create database Question7;
use Question7;

create table facility(
Facility_ID int,
Name varchar(100),
state varchar(100),
country varchar(100)
);
-- 7 (i)
Alter table facility 
modify Facility_ID int primary key auto_increment;

-- 7 (ii)
alter table facility
add column City varchar(100) not null after Name;
select * from customers;

-- Question 8(a)
create view product_category_sales as
select productline, sum(quantityordered * priceeach)  `Total Sales`, count(distinct o.ordernumber) number_of_orders
from products p left join orderdetails od on p.productCode=od.productCode
left join orders o on od.orderNumber = o.orderNumber
group by productLine;

-- Question 9
delimiter $$
create procedure Get_country_payments(in input_year int,in input_country varchar(100))
begin
select year(paymentdate) Year, country, 
concat(round(sum(amount)/1000),"K")
from customers c left join payments p on c.customernumber = p.customernumber
where year(paymentdate) = input_year and
country = input_country
group by year, country; 
end $$
delimiter ;

call Get_Country_Payments(2003,"france");

-- Question 10(a)
select *, dense_rank() over(order by order_count desc) order_frequency_rank from
(select customername, count(ordernumber) order_count
from customers c left join orders o on c.customerNumber=o.customerNumber
group by customername
) T1;
select * from orders;

-- Question 10(b)
select *, 
concat(round((`Total Orders` - lag(`Total Orders`,1) over())/lag(`Total Orders`,1) over()  * 100),"%") `% YOY Change` from
(select year(orderdate) year, monthname(orderdate) month, count(ordernumber) `Total Orders`
from orders
group by year, month) t1;

-- Question 11
select productline, count(productline) Total
from products
where buyprice>(select avg(buyprice) from products)
group by productline
order by total desc;

-- Question 12
create table Emp_EH(
EmpID int primary key,
EmpName varchar(100),
EmailAddress varchar(100)
);

delimiter //
CREATE  PROCEDURE `Emp_EH2`()
BEGIN
declare continue handler for sqlexception
begin
select "Error Occured" ;
end;
select * from Emp_EH2;
END //
delimiter ;

call emp_eh2();

-- Question 13
create table Emp_BIT (
Name varchar(100),
Occupation varchar(100),
Working_date date,
Working_hours int
);
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

delimiter //
create trigger before_insert_trigger
before insert on emp_bit
for each row
begin
if new.Working_hours < 0
then set new.Working_hours = new.Working_hours * (-1);
end if;
end //
delimiter ;




