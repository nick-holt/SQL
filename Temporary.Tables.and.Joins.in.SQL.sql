#Temporary Tables - Creates a table that you can query from

#rentals per user
DROP TABLE IF EXISTS
	rentals_per_customer
;

CREATE TEMPORARY TABLE rentals_per_customer
SELECT
	r.customer_id as customer_id, count(r.rental_id) as num_rentals, sum(p.amount) as customer_revenue
FROM
	rental r, payment p
WHERE
	p.rental_id = r.rental_id
GROUP BY 
	1
;

#rentals by users who rented x number of videos

SELECT
	rpc.num_rentals, sum(rpc.customer_revenue) as total_revenue, count(rpc.customer_id) as "Customer"
FROM
	rentals_per_customer rpc
GROUP BY
	1
;


#Find the revenue by actor/actress
#actor's name, revenue they produced

create temporary table rev_per_film
SELECT
	f.film_id as film_id, f.rental_rate*count(rental_id) as film_revenue
FROM 
	rental r, inventory i, film f
WHERE
	r.inventory_id = i.inventory_id
	AND i.film_id = f.film_id
GROUP BY
	1
;

SELECT
	a.actor_id, concat(a.first_name, " ", a.last_name) as actor, sum(rpf.film_revenue) as revenue
FROM
	rev_per_film rpf, actor a, film_actor fa
WHERE
	a.actor_id = fa.actor_id
	AND fa.film_id = rpf.film_id
GROUP BY
	1
ORDER BY
	3 desc
;

#LEFT JOIN
SELECT
	ac.customer_id,
	ac.fav_color
	rc.num_purchases
FROM
	active_customer actor_id
		LEFT JOIN reward_customer rc ON ac.customer_id = rc.customer_id
;

#LEFT JOIN pulls data from all active customers and all rewards customers and inserts NULL values for any missing values between them

-- Join temporary tables
all active customers(active = 1)

AND

phone number from the address table

create temporary table active_customer_contact
SELECT
	c.*, a.phone
FROM
	address a
		JOIN customer c ON a.address_id = c.address_id
WHERE
	c.active = 1
;

#only people who have made at least 30 rentals

create temporary table reward_users
SELECT
	r.customer_id, count(r.rental_id) as num_rentals, max(rental_date)
FROM
	rental r
GROUP BY
	1
HAVING
	num_rentals >= 30
;

#reward users who are also active users
#find customer_id, email, and first_name
create temporary table randa
SELECT
	acc.customer_id, acc.email, acc.first_name
FROM
	reward_users ru
		JOIN active_customer_contact acc ON ru.customer_id = acc.customer_id
GROUP BY
	1
;

#all reward users
#find customer_id, email, and first_name + if active, phone
create temporary table active_and_reward_users
SELECT
	r.customer_id, c.email, a.phone
FROM
	reward_users r
		JOIN customer c ON r.customer_id = c.customer_id
		LEFT JOIN active_customer_contact a ON a.customer_id = r.customer_id
GROUP BY
	1
;


