USE sakila;

# Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
FROM actor;

# Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT_WS(' ', first_name, last_name)
AS "actor_name"
FROM actor;

# Find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

# Find all actors whose last name contain the letters GEN.
SELECT first_name, last_name
FROM actor
WHERE last_name
LIKE ("%GEN%");

# Find all actors whose last names contain the letters LI; order the rows by last name and first name, in that order.
SELECT first_name, last_name
FROM actor
WHERE last_name
LIKE ("%LI%")
ORDER BY last_name, first_name;

# Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China.
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

# Create a column in the table actor named description and use the data type BLOB.
ALTER TABLE actor
ADD COLUMN description BLOB;

# Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

# List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

# List last names of actors and the number of actors who have that last name only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS name_count
FROM actor
GROUP BY last_name
HAVING name_count >1;

# The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

# In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

# You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

# Use JOIN to display the first and last names, as well as the address, of each staff member.
SELECT staff.first_name, staff.last_name, address.address, address.district, address.postal_code
FROM staff
JOIN address
ON staff.address_id = address.address_id;

# Use JOIN to display the total amount rung up by each staff member in August of 2005.
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
FROM payment
JOIN staff
ON payment.staff_id = staff.staff_id
GROUP BY staff_id;

# List each film and the number of actors who are listed for that film. Use tables film_actor and film.
SELECT film.title, COUNT(film_actor.actor_id) actors
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.title;

# How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory.film_id) copies
FROM inventory
JOIN film
ON inventory.film_id = film.film_id;

# Using the tables payment and customer and the JOIN command, list the total paid by each customer.
# List the customers alphabetically by last name
SELECT customer.first_name, customer.last_name, SUM(payment.amount) total
FROM customer
JOIN payment
ON payment.customer_id = customer.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;

# Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE title LIKE "K%" OR "Q%" IN
	(
    SELECT title
    FROM film
    WHERE language_id IN
		(
        SELECT language_id
        FROM language
        WHERE name = "English"
        )
	)
;

# Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
    SELECT actor_id
    FROM film_actor
    WHERE film_id IN
		(
        SELECT film_id
        FROM film
        WHERE title = "ALONE TRIP"
        )
	)
;

# Use joins to retrieve the names and email addresses of all Canadian customers
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address
ON customer.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id;

# Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN
	(
    SELECT film_id
    FROM film_category
    WHERE category_id IN
		(
        SELECT category_id
        FROM category
        WHERE name = "Family"
        )
	)
;

# Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.inventory_id) rentals
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY rentals DESC;

# Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(payment.amount) dollars
FROM payment
JOIN staff
ON payment.staff_id = staff.staff_id
JOIN store
ON staff.store_id = store.store_id
GROUP BY store.store_id;

# Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
FROM country
JOIN city
ON city.country_id = country.country_id
JOIN address
ON address.city_id = city.city_id
JOIN store
ON address.address_id = store.address_id
GROUP BY store.store_id;

# List the top five genres in gross revenue in descending order.
SELECT c.name AS genre, SUM(p.amount) AS gross
FROM category c
JOIN film_category f
ON c.category_id = f.category_id
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY genre
ORDER BY gross DESC
LIMIT 5;

# Use the solution from the problem above to create a view.
CREATE VIEW top_five_genres AS
SELECT c.name AS genre, SUM(p.amount) AS gross
FROM category c
JOIN film_category f
ON c.category_id = f.category_id
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY genre
ORDER BY gross DESC
LIMIT 5;

# How would you display the view that you created?
SELECT *
FROM top_five_genres;

# You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW IF EXISTS top_five_genres;