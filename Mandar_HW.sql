use sakila;

-- Question 1a: Display the first and last names of all actors from the table `actor`.
Select first_name, last_name from actor;

-- Question 1b: Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
Select concat(first_name, ' ', last_name) as 'actor_name' from actor;

-- Question 2a: You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
Select actor_id, first_name, last_name from actor where first_name = 'Joe';

-- Question 2b: Find all actors whose last name contain the letters `GEN`
select first_name, last_name from actor where last_name like "%GEN%";

-- Question 2c: Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select last_name, first_name from actor where last_name like "%LI%";

-- Question 2d: Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- Question 3a: You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB`
ALTER TABLE actor
ADD description blob AFTER last_name;

-- Question 3b: Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
alter table actor
drop description;

-- Question 4a: List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as last_name_count
from actor
group by last_name;

-- Question 4b: List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) as last_name_count
from actor
group by last_name
having last_name_count>1;

-- Question 4c: The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- Question 4d: Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO' and last_name = 'WILLIAMS';

-- Question 5a: You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- Question 6a: Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT first_name, last_name, address
FROM staff INNER JOIN address on staff.address_id = address.address_id;

-- Question 6B: Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT staff.staff_id, first_name, last_name, SUM(amount) 
FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment_date >= '2005-08-01' AND payment_date <= '2005-08-31'
GROUP BY staff.staff_id; 

-- Question 6c: List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT title AS "Film" , COUNT(actor_id) AS "Number of Actors" 
FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY title; 

-- Question 6D: How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title AS "Film", COUNT(inventory_id) AS "Number of Copies" 
FROM inventory INNER JOIN film ON inventory.film_id = film.film_id 
WHERE title = "Hunchback Impossible"; 

-- Question 6e: Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount)
FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name; 

-- Question 7a: The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title 
FROM film 
WHERE (title LIKE "K%" OR title LIKE "Q%") AND language_id in
(
	SELECT language_id
    FROM language
    WHERE name = "English"
);

-- Question 7B: Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM actor
WHERE actor_id IN
(
	SELECT actor_id 
    FROM film_actor 
    WHERE film_id IN
    (
		SELECT film_id 
        FROM film
        WHERE title = "Alone Trip"
	)
);

-- Question 7c: You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT CONCAT(first_name, ' ', last_name) AS 'Customer Name', 
email AS 'Email Address'
FROM customer INNER JOIN address ON 
customer.address_id = address.address_id INNER JOIN city ON
address.city_id = city.city_id INNER JOIN country ON
city.country_id = country.country_id 
WHERE country.country = 'Canada';

-- Question 7D: Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT film.title
FROM film INNER JOIN film_category ON film.film_id = film_category.film_id 
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- Question 7e: Display the most frequently rented movies in descending order.
SELECT film.title 'Title', COUNT(film.title) '# Rentals'
FROM film INNER JOIN inventory ON film.film_id = inventory.film_id 
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(film.title) DESC;

-- Question 7f: Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id 'Store', SUM(payment.amount) 'Revenue ($)'
FROM  payment INNER JOIN staff ON payment.staff_id = staff.staff_id 
INNER JOIN store ON staff.store_id = store.store_id
GROUP BY store.store_id; 

-- Question 7G: Write a query to display for each store its store ID, city, and country.
SELECT store.store_id 'Store', city.city 'City', country.country 'Country'
FROM store INNER JOIN address ON store.address_id = address.address_id 
INNER JOIN city ON address.city_id = city.city_id 
INNER JOIN country ON city.country_id = country.country_id; 

-- Question 7h: 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Revenue'
FROM category INNER JOIN film_category ON 
category.category_id = film_category.category_id INNER JOIN  inventory ON 
film_category.film_id = inventory.film_id INNER JOIN rental ON 
inventory.inventory_id = rental.inventory_id INNER JOIN payment ON 
rental.rental_id = payment.rental_id 
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- Question 8a: In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres as 
(
		SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Revenue'
		FROM category INNER JOIN film_category ON 
		category.category_id = film_category.category_id INNER JOIN  inventory ON 
		film_category.film_id = inventory.film_id INNER JOIN rental ON 
		inventory.inventory_id = rental.inventory_id INNER JOIN payment ON 
		rental.rental_id = payment.rental_id 
		GROUP BY category.name
		ORDER BY SUM(payment.amount) DESC
		LIMIT 5
); 

-- Question 8B: How would you display the view that you created in 8a?
SELECT *
FROM top_five_genres;

-- Question 8C: You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW sakila.top_five_genres;