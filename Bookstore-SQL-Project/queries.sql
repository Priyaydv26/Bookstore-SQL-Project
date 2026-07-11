CREATE TABLE Books (
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10,2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(50)
);

create table Orders(
    Order_ID serial primary key,
    Customer_ID int REFERENCES Customers(Customer_ID),
	Book_ID int REFERENCES Books(Book_ID),
	Order_Date Date,
	Quantity Int,
	Total_Amount numeric(10,2)
);

Select * from Books;
select * from Customers;
Select * from Orders;

--creation done

-- 1) Retrieve all books in the "Fiction" genre:

select * from books
where genre = 'Fiction';


--2) Find books published after the year 1950:

select * from books 
where published_year >1950;


--3) List all customers from the Canada:

select * from customers 
where country = 'Canada';

--4) Show orders placed in November 2023:

select * from orders
where order_date between '2023-11-01' and '2023-11-30';


--5) Retrieve the total stock of books available:

select Sum(stock) as Total_stock from books;


--6) FInd the details of the most expensive book:

select * from books order by Price DESC limit 1;


--7) Show all customers who ordered more than 1 quantity of a book:

select * from orders 
where quantity > 1

--8) Retrieve all orders where the total amount exceeds $20:

select * from orders
where total_amount > 20;


--9) List all the genres avaialble in the Books table:


select distinct genre from books;


--10) FInd the books with the lowest stock:

select * from books
order by stock ASC
LImit 1;

--11) Calculate the total revenue generated from all orders:

select sum(total_amount) as Revenue from Orders;

-- ADVANCED QUERIES 

--1) Retrieve the total number of books sold for each genre.

select b.genre, sum(o.quantity) as Total_Books_sold
from orders o 
join books b on o.book_ID = b.book_ID
group by b.genre;


--2) Find the average price of books in the "Fantasy" genre.

select AVG(price) as Avg_price from books 
where genre = 'Fantasy'
Group by genre;


--3) List customers who have placed at least 2 orders.

select customer_ID, count(order_ID) as Order_count
from orders
group by customer_ID 
having Count(order_ID)>=2;

--4) Find the most frequently ordered book.

SELECT o.book_id, b.title, COUNT(o.order_id) AS order_counts
FROM orders o
JOIN books b
ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
ORDER BY order_counts DESC
LIMIT 1;


--5) Show the top 3 most expensive books of the 'Fantasy' genre.

select * from books
where genre = 'Fantasy'
order BY Price DESC Limit 3;


--6) Retrieve the total quantity of books sold by each author.


select b.author, Sum(o.quantity) as total_quantity
from books b
join orders o
on b.book_id = o.book_id
group by b.author;


--7) List the cities where customers who spent over $30 are located.


select distinct(c.city), o.total_amount
from orders o 
join customers c
on o.customer_id = c.customer_id
where o.total_amount > 30;


--8) Find the customer who spent the most on orders.

select c.customer_id, c.name, sum(o.total_amount) as total_spent
from orders o 
join customers c
on o.customer_id = c.customer_id
group by c.customer_id, c.name
order by total_spent DESC limit 1;

 
 --9) Calculate the stock remaining after fulfilling all orders.

select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaining_quauntity
from books b
left join orders o on b.book_id = o.book_id
group by b.book_id
order by b.book_id;

--10) JOIN of All Three Tables

SELECT
    o.order_id,
    c.customer_id,
    c.name,
    c.city,
    c.country,
    b.book_id,
    b.title,
    b.author,
    b.genre,
    b.price,
    o.quantity,
    o.order_date,
    (o.quantity * b.price) AS total_amount
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN books b
    ON o.book_id = b.book_id
ORDER BY o.order_id;