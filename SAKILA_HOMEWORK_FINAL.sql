-- mySQL Homework
use sakila;
-- 1a Display the first and last names of all actors FROM the TABLE actor.
SELECT first_name, last_name 
FROM actor;

-- 1b Display the first and last name of each actor IN a sINgle column IN upper case letters. Name the column Actor Name.
SELECT concat(first_name, ' ', last_name) as full_name
FROM actor;

-- 2a You need to fINd the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtaIN this INformation?
SELECT actor_id, first_name, last_name 
FROM actor 
	WHERE first_name = 'Joe';

-- 2b FINd all actors whose last name contaIN the letters GEN.
SELECT first_name, last_name 
FROM actor 
	WHERE first_name LIKE '%gen%';
    
-- 2c FINd all actors whose last names contaIN the letters LI. This time, order the rows by last name and first name, IN that order.
SELECT last_name, first_name 
FROM actor 
	WHERE first_name LIKE '%gen%';

-- 2d UsINg IN, display the country_id and country columns of the followINg countries: Afghanistan, Bangladesh, and ChINa.
SELECT country, country_id 
FROM country 
	WHERE country IN ('Afghanistan', 'Bangladesh', 'ChINa');

-- 3a Add a middle_name column to the TABLE actor. Position it between first_name and last_name. HINt: you will need to specify the data type.
ALTER TABLE actor add middle_name varchar(30);
SELECT first_name, middle_name, last_name FROM actor;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor MODIFY middle_name blob;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor DROP middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name) 
FROM actor 
	GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, count(last_name) 
FROM actor 
	GROUP BY last_name 
	havINg count(last_name) >= 2;
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered IN the actor TABLE as GROUCHO WILLIAMS, the name of Harpo's second cousIN's husband's yoga teacher. Write a query to fix the record.
set sql_safe_updates = 0;
update actor set first_name = REPLACE(first_name, 'GROUCHO', 'HARPO');

SELECT actor_id, first_name, last_name 
FROM actor 
	WHERE last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty IN changINg GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! IN a sINgle query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (HINt: update the record usINg a unique identifier.)
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE actor_id = 172;

 -- 5a. You cannot locate the schema of the address TABLE. Which query would you use to re-create it?
describe address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the TABLEs staff and address:
SELECT staff.first_name, staff.last_name, address.address FROM staff
	INner joIN address on staff.address_id = address.address_id;
    
-- 6b. Use JOIN to display the total amount rung up by each staff member IN August of 2005. Use TABLEs staff and payment.
SELECT staff.first_name, staff.last_name, sum(payment.amount) 
FROM staff
	INner joIN payment on staff.staff_id = payment.staff_id
    GROUP BY staff.staff_id;    
    
-- 6c. List each film and the number of actors who are listed for that film. Use TABLEs film_actor and film. Use INner joIN.
SELECT film.title, count(film_actor.actor_id) 
FROM film
	INner JOIN film_actor on film.film_id = film_actor.film_id
    GROUP BY film.film_id; 
    
-- 6d. How many copies of the film Hunchback Impossible exist IN the INventory system?
SELECT film.title, count(INventory.film_id) 
FROM film
	INner joIN INventory on film.film_id = INventory.film_id
    GROUP BY film.film_id
    havINg film.title = 'Hunchback Impossible';
    
-- 6e. UsINg the TABLEs payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, sum(payment.amount) 
FROM customer
	INner joIN payment on customer.customer_id = payment.customer_id
    GROUP BY customer.customer_id
    order by customer.last_name;
    
-- 7a. The music of Queen and Kris Kristofferson have seen an unLIKEly resurgence. As an unINtended consequence, films startINg with the letters K and Q have also soared IN popularity. Use subqueries to display the titles of movies startINg with the letters K and Q whose language is English.
  SELECT title FROM film
	WHERE language_id IN
		(SELECT language_id FROM language
        WHERE name = 'English')
	and title LIKE 'Q%' or 'K%';
-- 7b. Use subqueries to display all actors who appear IN the film Alone Trip.
SELECT first_name, last_name FROM actor
	WHERE actor_id IN
		(SELECT actor_id FROM film_actor
		WHERE film_id IN
			(SELECT film_id FROM film
            WHERE title = 'Alone Trip'));
-- 7c. You want to run an email marketINg campaign IN Canada, for which you will need the names and email addresses of all Canadian customers. Use joINs to retrieve this INformation.
SELECT customer.first_name, customer.last_name, customer.email FROM customer
	INner joIN address on customer.address_id = address.address_id
	INner joIN country on address.address_id = country.country_id
    WHERE country.country = 'Canada'
    GROUP BY customer.first_name, customer.last_name, customer.email;
-- 7d. Sales have been laggINg among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT title FROM film
	WHERE film_id IN
	(SELECT film_id FROM film_category
		WHERE category_id IN
			(SELECT category_id FROM category 
				WHERE name = 'Family'));
-- 7e. Display the most frequently rented movies IN descendINg order.
SELECT title, count(rental.rental_id) FROM film
	INner joIN INventory on film.film_id = INventory.film_id
    INner joIN rental on INventory.INventory_id = rental.INventory_id
    GROUP BY title
    order by count(rental.rental_id) desc;
-- 7f. Write a query to display how much busINess, IN dollars, each store brought IN.
SELECT store.store_id, sum(payment.amount) FROM store
	INner joIN customer on store.store_id = customer.store_id
	INner joIN payment on customer.customer_id = payment.payment_id
    GROUP BY store.store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country FROM store
	INner joIN address on store.address_id = address.address_id
	INner joIN city on address.city_id = city.city_id
	INner joIN country on city.country_id = country.country_id
    GROUP BY store.store_id, city.city, country.country;
-- 7h. List the top five genres IN gross revenue IN descendINg order. (HINt: you may need to use the followINg TABLEs: category, film_category, INventory, payment, and rental.)
SELECT category.name, sum(payment.amount) FROM category
	INner joIN film_category on category.category_id = film_category.category_id
	INner joIN INventory on film_category.film_id = INventory.film_id
	INner joIN rental on INventory.INventory_id = rental.INventory_id
    INner joIN payment on rental.rental_id = payment.rental_id
    GROUP BY category.name
    order by sum(payment.amount) desc 
    limit 5;
-- 8a. IN your new role as an executive, you would LIKE to have an easy way of viewINg the Top five genres by gross revenue. Use the solution FROM the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view Top_5 as
	SELECT category.name as 'Genre', sum(payment.amount) as 'Gross Revenue' FROM category
		INner joIN film_category on category.category_id = film_category.category_id
		INner joIN INventory on film_category.film_id = INventory.film_id
		INner joIN rental on INventory.INventory_id = rental.INventory_id
		INner joIN payment on rental.rental_id = payment.rental_id
		GROUP BY category.name
		order by sum(payment.amount) desc 
		limit 5;
-- 8b. How would you display the view that you created IN 8a?
SELECT * FROM Top_5;
-- 8c. You fINd that you no longer need the view top_five_genres. Write a query to delete it.
DROP view Top_5;
