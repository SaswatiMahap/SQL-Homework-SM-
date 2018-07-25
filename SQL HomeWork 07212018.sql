## Instructions

use sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT  first_name, last_name FROM sakila.actor;


##  1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select concat(first_name,'   ',last_name) as 'Actor Name' from sakila.actor;

## 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
	-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM sakila.actor WHERE first_name = 'Joe';


## 2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name, last_name FROM sakila.actor WHERE last_name LIKE '%GEN%';


## 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name FROM sakila.actor WHERE last_name LIKE '%LI%';

## 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
 SELECT COUNTRY_ID, COUNTRY
 FROM COUNTRY
 WHERE COUNTRY IN
(
'Afghanistan',
'Bangladesh',
'China'
 );

-- ########################################

## 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD middle_name character(13);

## 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor
ALTER COLUMN middle_name blobs;
-- Above code is giving me an error 

## 3c. Now delete the `middle_name` column.
ALTER TABLE ACTOR drop COLUMN middle_name; 

-- ########################################

## 4a. List the last names of actors, as well as how many actors have that last name.
SELECT LAST_NAME, COUNT(LAST_NAME) FROM ACTOR  group by LAST_NAME;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT LAST_NAME, COUNT(LAST_NAME) FROM ACTOR  group by LAST_NAME if COUNT(LAST_NAME);



-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. 
-- Write a query to fix the record.


-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all!
	-- In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
	-- Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. 
	-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)


-- ########################################


-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
-- Hint: <https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html>
describe sakila.address;

-- ########################################

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id=address.address_id;


-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT staff.first_name, staff.last_name, staff.staff_id, pay.totalamount
FROM staff 
INNER JOIN (
select staff_id, 
sum(amount) as totalamount
from payment
group by staff_id) pay
ON staff.staff_id=pay.staff_id;


-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
Select film.film_id, film.title, fa.number_of_actors
FROM film 
INNER JOIN (
select film_id, 
count(actor_id) as number_of_actors
from film_actor
group by film_id) fa
ON film.film_id=fa.film_id;


-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
Select film.film_id, film.title, inv.number_of_copies
FROM film 
INNER JOIN (
select film_id, 
count(inventory_id) as number_of_copies
from inventory
group by film_id) inv
ON film.film_id=inv.film_id where title like 'Hunchback Impossible';


-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
Select customer.customer_id, customer.first_name, customer.last_name, pay.total_paid
FROM customer
INNER JOIN (
select customer_id, 
sum(amount) as total_paid
from payment
group by customer_id) pay
ON customer.customer_id=pay.customer_id order by customer.last_name;


-- [Total amount paid](Images/total_payment.png)

-- ########################################


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` 
-- have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
Select film.title, language.name
FROM film 
INNER JOIN language
ON film.language_id=language.language_id where film.title like 'K%' or film.title like'Q%' and language.name like 'English';


-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

create table sakila.temp1
(film_id int(5), 
title varchar(255)
);

INSERT INTO temp1 (film_id, title)
SELECT film_id, title
FROM film
WHERE title like 'Alone Trip'; 


create table sakila.temp2
(film_id int(5), 
first_name varchar(45),
last_name varchar(45)
);

INSERT INTO temp2temp2 (film_id, first_name, last_name)
SELECT film_actor.film_id, actor.last_name, actor.first_name
from film_actor
INNER JOIN actor
ON film_actor.actor_id=actor.actor_id;

SELECT temp1.*, temp2.*
FROM temp1
INNER JOIN temp2 ON
temp1.film_id=temp2.film_id;



-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.


select country.* from country where country like 'Canada';
-- note the country code from above Canada = 20 

create table sakila.temp3
(city_id int(5), 
country_id int(5)
);

INSERT INTO temp3 (city_id, country_id)
SELECT city.city_id, city.country_id
from city where country_id=20;


create table sakila.cust_add
(address_id SMALLINT(5), 
address VARCHAR(50), 
district VARCHAR(20), 
city_id SMALLINT(5), 
postal_code VARCHAR(20), 
phone VARCHAR(20), 
customer_id SMALLINT(5), 
first_name VARCHAR(45), 
last_name VARCHAR(45), 
email VARCHAR(45), 
active tinyint(1))
; 

INSERT INTO sakila.cust_add (address_id, address, district, city_id, postal_code, phone, customer_id, first_name, last_name, email, active)
select address.address_id, address.address, address.district, address.city_id, address.postal_code, address.phone, customer.customer_id, customer.first_name,
customer.last_name, customer.email, customer.active

from address 
inner join customer on 
address.address_id=customer.address_id;


select cust_add.*, temp3.*
from cust_add inner join temp3 on 
cust_add.city_id=temp3.city_id;


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select category.* from category where name like 'family';


-- note the category_id for family movies = 8..

select film_category.*, film.*
from film_category inner join film on 
film_category.film_id=film.film_id where category_id=8;

-- 7e. Display the most frequently rented movies in descending order.

create table sakila.film_inv
(inventory_id int(5), 
film_id int(5),
title varchar(250)
);

INSERT INTO film_inv (inventory_id, film_id, title)
SELECT inventory.inventory_id, inventory.film_id, film.title
from inventory inner join film on inventory.film_id=film.film_id; 


create table sakila.film_inv2
(inventory_id int(5), 
film_id int(5),
title varchar(250),
rental_id int(5),
amount decimel (10)
);


INSERT INTO film_inv2 (inventory_id, film_id, title, rental_id)
SELECT film_inv.inventory_id, film_inv.film_id, film_inv.title, rental.rental_id
from film_inv inner join rental on film_inv.inventory_id=rental.inventory_id; 

select title, count(rental_id) from film_inv2 group by title
order by count(rental_id) desc; 




-- 7g. Write a query to display for each store its store ID, city, and country.


create table sakila.temp0
(store_id int(5),
address_id int(5),
city_id int(5)
);


INSERT INTO temp0 (store_id, address_id, city_id)
SELECT store.store_id, store.address_id, city.city_id
from store inner join city on store.address_id=city.city_id; 



create table sakila.temp01
(country_id int(5),
country varchar(50),
city_id int(5)
);


INSERT INTO temp01 (country_id, country, city_id)
SELECT country.country_id, country.country, city.city_id
from country inner join city on country.country_id=city.country_id; 




create table sakila.temp02
(store_id int(5),
address_id int(5),
city_id int(5),
country_id int(5),
country varchar(50)
);


INSERT INTO temp02 (store_id, address_id, city_id, country_id, country)
SELECT temp0.store_id, temp0.address_id, temp0.city_id, temp01.country_id, temp01.country
from temp0 inner join temp01 on temp0.city_id=temp01.city_id; 

-- 7f. Write a query to display how much business, in dollars, each store brought in.


create table sakila.temp11
(store_id int(5),
country_id int(5),
country varchar(50),
staff_id int(5)
);


INSERT INTO temp11 (store_id, country_id, country, staff_id)
SELECT temp02.store_id, temp02.country_id, temp02.country, staff.staff_id
from temp02 inner join staff on temp02.store_id=staff.store_id; 




create table sakila.temp12
(store_id int(5),
country_id int(5),
country varchar(50),
staff_id int(5),
amount int(10)
);


INSERT INTO temp12 (store_id, country_id, country, staff_id, amount)
SELECT temp11.store_id, temp11.country_id, temp11.country, temp11.staff_id, payment.amount
from temp11 inner join payment on temp11.staff_id=payment.staff_id; 


select store_id, country, sum(amount)  from temp12 group by store_id;


-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)


-- ########################################

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.


-- 8b. How would you display the view that you created in 8a?


-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
