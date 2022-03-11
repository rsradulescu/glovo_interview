---------------------------------------------------------------------
-- GLOVO INTERVIEW
-- DATA ANALYST
-- Problem: Logistics DA Assignment SQL
-- Author: Rocio Soledad Radulescu
---------------------------------------------------------------------

-- set schema path
set search_path = 'public';

/* 
---------------------------------------------------------------------
A. Given the two tables above, you are interested in comparing the percentage of
orders that were bundled together in Glovalia (city code GLV) against Playa
City (PLY) on November 1st, 2021. Unbundled orders should not be counted as
bundled.
--------------------------------------------------------------------- 
*/


-- Resource 1) VIEW get bundle of cities in bundled_orders (with unbundled false)
--DROP VIEW  vw_orders_bundled
CREATE OR REPLACE VIEW vw_orders_bundled AS
	SELECT 
		o.city_code, COUNT(*) 
		OVER(
			PARTITION BY (bundle_id) 
			rows between unbounded preceding and current row
		) count_boun_city
	FROM 
		orders AS o 
		RIGHT JOIN bundled_orders AS bo ON o.order_id = bo.order_id
	WHERE
		bo.is_unbundled = 'FALSE';
	
-- Resource 2)  VIEW get count orders by cities and dates
-- DROP VIEW vw_count_orders_by_day
CREATE VIEW vw_count_orders_by_day AS
	SELECT
		city_code, DATE(creation_time), count(*) city_orders_day
	FROM
		orders AS o 
	GROUP BY
		city_code, DATE(creation_time)


-----------------------------------------------------------------------------
-- Solution) get percentage query: by boundled GLV and PLY in 1st Nov 
-- total = 100% = all orders in a day
SELECT
	ROUND((SELECT count_boun_city FROM vw_orders_bundled WHERE city_code = 'GLV' ) *100/COUNT(*)::numeric, 2) AS "% GLV",
	ROUND((SELECT city_orders_day FROM vw_count_orders_by_day WHERE city_code = 'PLY') *100/COUNT(*)::numeric, 2) AS "% PLY"
FROM
	orders AS o	
WHERE
	DATE(o.creation_time) = '2021-11-01'