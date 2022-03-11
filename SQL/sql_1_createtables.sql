---------------------------------------------------------------------
-- GLOVO INTERVIEW
-- DATA ANALYST
-- Problem: Logistics DA Assignment SQL
-- Author: Rocio Soledad Radulescu
---------------------------------------------------------------------

-- set schema path
set search_path = 'public';

-- First: create table orders and bundled_orders from csv
-- DROP table orders
CREATE TABLE orders 
(
	order_id character varying(20),
	city_code char(3),
	store_id character varying(20),
	creation_time timestamp,
	pickup_time timestamp,
	enters_delivery timestamp,
	pd_dist int,
	final_status character varying(20) 
);
COPY orders FROM '../tables/orders.csv' DELIMITER ';' CSV HEADER;


CREATE TABLE bundled_orders 
(
	order_id character varying(20) ,
	bundle_id character varying(20) ,
	is_bundled boolean,
	is_unbundled boolean
);

COPY bundled_orders FROM '../tables/bundled_orders.csv' DELIMITER ';' CSV HEADER;
