#how much reveune has each movie generated?
SELECT 
	f.title as "Film Title", count(r.rental_id) "Number of Rentals", f.rental_rate as "Rental Price", count(r.rental_id) * f.rental_rate as "Revenue"
FROM
	film f, inventory i, rental r
WHERE
	f.film_id = i.film_id
	AND r.inventory_id = i.film_id
GROUP BY 
	1
ORDER BY
	4 desc
;


#what customer has paid us the most money?
SELECT
	p.customer_id, SUM(p.amount) as "Total Paid"
FROM
	payment p, 
GROUP BY
	1
ORDER BY
	2 desc
;


#what store has brought in the most revenue?
SELECT
	s.store_id as "Store", SUM(p.amount) as "Revenue"
FROM
	rental r, store s, payment p, inventory i
WHERE
	r.rental_id = p.rental_id
	AND r.inventory_id = i.inventory_id
	AND i.store_id = s.store_id
GROUP BY
	1
ORDER BY
	2 desc
;

#how many rentals did we have each month?

SELECT
	left(r.rental_date, 7) as "Rental Month", count(r.rental_id)
FROM
	rental r
GROUP BY
	1
;

#when was a moviee first rented and last rented?
SELECT
	f.title as "Film Title", max(r.rental_date) as "Last Rental Date", min(r.rental_date) as "First Rental Date"
FROM
	rental r, inventory i, film f
WHERE
	r.inventory_id = i.inventory_id
	AND i.film_id = f.film_id
GROUP BY
	f.film_id
;

#find every customer's last rental Date
SELECT
	concat(c.first_name, " ", c.last_name) as "Name", c.email as "Email", max(r.rental_date) as "Last Rental"
FROM
	rental r, customer c
WHERE
	r.customer_id = c.customer_id
GROUP BY
	c.customer_id
;

#find revenue by each month
SELECT
	left(p.payment_date, 7) as "Month", SUM(p.amount) as "Revenue"
FROM
	payment p
GROUP BY
	1
ORDER BY
	2 desc
;

#DISTINCT
#how many distinct renters do we have per month?

SELECT
	left(r.rental_date, 7) as Month, count(r.rental_id) as Total_Rentals, count(distinct r.customer_id) as Unique_Renters, count(r.rental_id)/count(distinct r.customer_id) as Average_Rentals_Per_Customer
FROM
	rental r
GROUP BY
	1
;

#the number of distinct films that are rented each month
SELECT
	left(rental_date, 7) as "Month", count(distinct f.film_id) as "Number of films", count(r.rental_id)/count(distinct f.film_id) as "Rentals per Film"
FROM
	rental r, film f, inventory i
WHERE
	r.inventory_id = i.inventory_id
	AND i.film_id = f.film_id
GROUP BY
 1
;

#IN function
#Number of rentals in comedy, sports, and family

SELECT
	c.name as "Category", count(r.rental_id) as "Number of Rentals"
FROM
	rental r, inventory i, film f, film_category fc, category c
WHERE
	r.inventory_id = i.inventory_id
	AND i.film_id = f.film_id
	AND f.film_id = fc.film_id
	AND fc.category_id = c.category_id
	AND c.name in ("Comedy", "Sports", "Family")
GROUP BY
	1
;


SELECT
	c.name as "Category", count(r.rental_id) as "Number of Rentals"
FROM
	rental r, inventory i, film f, film_category fc, category c
WHERE
	r.inventory_id = i.inventory_id
	AND i.film_id = f.film_id
	AND f.film_id = fc.film_id
	AND fc.category_id = c.category_id
	AND c.name != "Comedy" #return all except comedy
GROUP BY
	1
;

# How many users have rented at least 3 times

SELECT
	r.customer_id as "Customer", count(r.rental_id) as "Number of Rentals"
FROM
	rental r
GROUP BY
	1
HAVING
	count(r.rental_id) >= 3
;

#how much revenue has store 1 made from moveies that are rated R or PG13?
# how much revenue has store 1 made per rental on movies that are R or PG13?
# how much revenue has store 1 made per movie on movies that are R or PG13?

SELECT
	i.store_id as "Store", f.rating as "Movie Rating", sum(p.amount) as "Store Revenue", sum(p.amount)/count(distinct r.rental_id) as "Revenue per Rental",  sum(p.amount)/count(distinct f.film_id) as "Revenue per Movie"
FROM 
	film f, payment p, inventory i, rental r
WHERE
	p.rental_id = r.rental_id
	AND r.inventory_id = i.inventory_id
	AND i.film_id = f.film_id
	AND i.store_id = 1
	AND f.rating in ('R', 'PG-13')
GROUP BY
	1, 2
ORDER BY
	3 desc
;