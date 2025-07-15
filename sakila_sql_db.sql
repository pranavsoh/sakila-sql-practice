use sakila;
-- 1 to 5
-- List all film titles.
select title from film;
-- Show the first and last name of all actors.
select first_name,last_name from actor;
-- List all categories.    
select * from category;
-- Display the first 10 customers.
select * from customer
ORDER BY customer_id
limit 10 ;
-- Show all unique ratings available in the film table.
select DISTINCT rating from film; 
   
--  6 to 10  
-- Find all films with a rental rate greater than $2.
select title, rental_rate from film 
where rental_rate >2
order by film_id;
-- List films released in the year 2006.
select  title, release_year  from film 
where release_year = 2006; 
-- List all films with length between 90 and 120 minutes.
SELECT title, length,film_id
FROM film
WHERE length  BETWEEN 90 AND 120
ORDER BY film_id;
-- Find all customers whose last name starts with ‘S’.
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'S%';
-- Show customers living in the city 'Dallas'.
SELECT c.customer_id, c.first_name, c.last_name, ct.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
WHERE ct.city = 'Dallas';

-- 11 to 15
-- Show the titles of films and their category names.
SELECT c.category_id, c.name AS category_name, f.film_id, f.title
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id;
-- List all payments along with the customer’s first and last name.
select p.payment_id
,p.amount
as amount_pay ,
c.first_name,
c.last_name
from payment p 
JOIN customer c on c.customer_id =p.customer_id;
-- Display staff names and the stores they work in.
select st.staff_id,
st.first_name,
st.last_name,
st.active as staff_details
,s.store_id
,s.manager_staff_id
from staff st
join store s on st.store_id = s.store_id;
-- List film titles and the language they’re in.
select 
fi.film_id,
fi.title,
las.name,
las.language_id,
las.name AS language_name
from film fi
join language las on fi.language_id = las.language_id;
-- Find rental date and return date for each rental, along with customer name.
select 
r.rental_id,
r.rental_date,
r.return_date,
c.customer_id,
c.first_name,
c.last_name 
from rental r
join customer c on c.customer_id = r.customer_id;

-- 16 to 20
-- Count the number of films in each category.
SELECT c.name AS category_name, COUNT(fc.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;
-- Find the average rental rate of films in each category.
select c.name AS category_name,round(avg(f.rental_rate),2) as avg_rental_rate
from category c 
join film_category fc on c.category_id =fc.category_id
join film f on fc.film_id =f.film_id
group by c.name; 
-- List the number of rentals per customer.
select c.customer_id, concat(c.first_name, ' ',c.last_name) as customer_name
, COUNT(r.rental_id) AS rental_count
from customer c
join rental r on c.customer_id = r.customer_id
group by c.customer_id,c.first_name,c.last_name;
-- Find the highest payment amount made by any customer.
select * from payment;
select customer_id ,max(amount) as highest_payment
from payment
group by customer_id;
-- Show total revenue (sum of amount) per store.
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;


-- 21 to 25 
-- List top 5 longest films.
select film_id ,title,length 
from film 
order by length  DESC
limit 5 ;
-- Show top 10 customers who spent the most.
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;
-- Find top 3 most rented films.
SELECT f.title, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 3;
-- Display actors sorted by last name in descending order.
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY last_name DESC;
-- List films sorted by length (shortest to longest).
SELECT film_id, title, length
FROM film
ORDER BY length ASC;

-- 26 to 30 
-- Find films whose rental rate is above the average rental rate.
SELECT title, rental_rate
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate) FROM film
);
-- Find customers who have made more payments than the average number of payments.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(p.payment_id) AS num_payments
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(p.payment_id) > (
    SELECT AVG(payment_count) 
    FROM (
        SELECT COUNT(*) AS payment_count
        FROM payment
        GROUP BY customer_id
    ) AS sub
);
-- Find films that are not rented by anyone.
SELECT film_id, title
FROM film
WHERE film_id NOT IN (
    SELECT DISTINCT i.film_id
    FROM inventory i
    JOIN rental r ON i.inventory_id = r.inventory_id
);
-- Show actors who acted in more than 10 films.
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;
-- Find customers who rented ‘ACADEMY DINOSAUR’.
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR';


-- 31 to 35 
-- Use a CTE to find the number of films per category, then show only categories with more than 60 films.
WITH film_count AS (
    SELECT c.name AS category_name, COUNT(f.film_id) AS num_films
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    GROUP BY c.name
)
SELECT *
FROM film_count
WHERE num_films > 60;
-- Write a recursive CTE to list numbers 1 to 10.
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT n FROM numbers;
-- Use a CTE to get the top 5 most rented films and then list their titles and rental counts.
WITH rental_counts AS (
    SELECT f.film_id, f.title, COUNT(*) AS rental_count
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id, f.title
    ORDER BY rental_count DESC
    LIMIT 5
)
SELECT * FROM rental_counts;
-- Use a CTE to find the total payments per customer and list only those over $100.
WITH customer_payments AS (
    SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           SUM(p.amount) AS total_payment
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT * FROM customer_payments
WHERE total_payment > 100;
-- Create a CTE that lists actors and the number of films they acted in.
WITH actor_films AS (
    SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT * FROM actor_films;


-- 34 to 40 
-- Write a statement to add a new column email_verified (BOOLEAN) to the customer table.
ALTER TABLE customer ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;

-- Create a table called movie_awards with film_id, award_name, and award_year.
CREATE TABLE movie_awards (
    award_id INT AUTO_INCREMENT PRIMARY KEY,
    film_id SMALLINT UNSIGNED NOT NULL,
    award_name VARCHAR(100),
    award_year YEAR,
    FOREIGN KEY (film_id) REFERENCES film(film_id)
) ENGINE=InnoDB;
-- Alter the staff table to add a constraint making email unique.
alter table staff add constraint unique_email unique (email);
-- Drop the actor table (don’t actually do this on live!).
ALTER TABLE film_actor DROP FOREIGN KEY fk_film_actor_actor;
DROP TABLE actor;
-- Rename column last_update in film table to last_modified.
ALTER TABLE film CHANGE last_update last_modified TIMESTAMP;
-- 41 to 45 
-- Insert a new category named ‘Documentary’.
INSERT INTO category (name, last_update) VALUES ('Documentary', NOW());
-- Update all films with rating ‘NC-17’ to have rental_rate = 4.99.
UPDATE film SET rental_rate = 4.99 WHERE rating = 'NC-17';
-- Delete all customers from city 'Seattle'.
DELETE c
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
WHERE ci.city = 'Seattle';
-- Insert a new customer into the customer table.
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
VALUES (1, 'John', 'Doe', 'john.doe@example.com', 1, 1, NOW());
-- Increase the rental_rate of all films by 10%.
UPDATE film SET rental_rate = rental_rate * 1.10;
-- 46 to 50
-- Create a view that shows customer name and total payments.
CREATE VIEW customer_total_payments AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;
-- Create a view listing film titles and their category.
CREATE VIEW film_with_category AS
SELECT f.film_id, f.title, c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;
-- Use the ROUND function to show payment amounts rounded to the nearest dollar.
SELECT payment_id, amount, ROUND(amount, 0) AS rounded_amount
FROM payment;
-- Use CONCAT to show full customer name (first + last).
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name
FROM customer;
-- Create a view showing top 5 customers by total amount spent.
CREATE VIEW top5_customers AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_payment DESC
LIMIT 5;
