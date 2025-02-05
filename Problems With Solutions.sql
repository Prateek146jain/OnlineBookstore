-- 1) Retrieve all books in the "Fiction" genre:
		
select * from books where genre="Fiction";

-- 2) Find books published after the year 1950:

Select * from books where Published_Year>1950 order by Published_Year;

-- 3) List all customers from the Canada:

Select * from customers where Country="Canada";

-- 4) Show orders placed in November 2023:
Select * from orders where month(Order_date)=11 AND year(order_date)=2023;
-- Alternative way
Select * from orders where Order_Date between '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available: 

select sum(Stock) as total_stocks from books;

-- 6) Find the details of the most expensive book:
	
select * from books order by Price desc limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

select * from orders where Quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:

select * from orders where Total_Amount>20;

-- 9) List all genres available in the Books table:

SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:

Select * from Books order by Stock limit 1;

-- 11) Calculate the total revenue generated from all orders:

Select sum(Total_Amount) as total_revenue from orders;


-- Advance Questions : 
select * from orders;
-- 1) Retrieve the total number of books sold for each genre:
Select b.genre, sum(o.Quantity) from Orders as o
join 
books as b
on o.Book_ID = b.Book_ID group by b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
Select avg(price) from books where Genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:


Select o.Customer_ID, C.name,Count(O.Quantity) as total_placed_order from orders as O
join Customers as C 
on O.Customer_ID=C.Customer_ID group by C.name,o.Customer_ID having count(*)>=2;
;

SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;


-- 4) Find the most frequently ordered book:

Select b.book_id,b.title,b.genre,count(o.Quantity)
from books as b
join orders as o
on 
b.Book_ID=o.Book_ID
group by b.book_id,b.title,b.genre order by count(o.Quantity) desc limit 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
Select * from books where Genre='Fantasy' order by price desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:

Select b.Author,sum(o.Quantity) from books as b 
join orders as o
on b.book_id=o.book_id group by b.Author;

-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30 order by total_amount;


-- 8) Find the customer who spent the most on orders:

Select C.Customer_id,C.Name,C.Email, sum(O.Total_Amount)
from Customers as C
join Orders as O
on C.Customer_id = O.Customer_id
group by C.Customer_id,C.Name,C.Email order by sum(O.Total_Amount) desc;

-- 9) Calculate the stock remaining after fulfilling all orders:

with cte as (
Select b.Book_ID,b.title,b.Stock,coalesce(sum(Quantity),0) as a from books as b
left join Orders as o on
b.Book_ID=o.Book_ID 
group by b.Book_ID)
Select *, stock-a from cte;

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;