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
B) Average courier speed from pickup to delivery of each city in the last 30 days.
In the case of bundled orders please consider only the trajectory to the first
delivery point, always being the one with shortest pickup to delivery distance.
The columns pd_dist, pickup_time and enters_delivery represent,
respectively: the distance from pickup to delivery; the timestamp when the
courier picks up the order and starts heading to the delivery point; the
timestamp when the courier enters the delivery area.
--------------------------------------------------------------------- 
*/

-- Resource 1) To propose a scalable solution I make a function that return average between 2 dates
-- NOTE: I extract the last 30 days from creation_time
CREATE FUNCTION  get_film_avg(init_date timestamp, end_date timestamp, city char(3))
RETURNS int
LANGUAGE plpgsql
as
$$
declare
   return_second integer;
begin
   SELECT 
	AVG (
		EXTRACT( second FROM enters_delivery::timestamp - pickup_time::timestamp) ) as mean_second
	INTO 
		return_second
	FROM 
		orders o
	WHERE 	
		creation_time BETWEEN init_date AND end_date 
		AND city_code = city;
   
   return return_second;
end;
$$;

-----------------------------------------------------------------------------
-- Solution) use function for each city and date between now and (now -30 days)
SELECT 
	city_code, get_film_avg(NOW()::timestamp, (NOW()::timestamp - INTERVAL '30 DAY'), city_code)
FROM 
	orders o

-- Execution example with return values
SELECT 
	city_code, get_film_avg('2021-11-01', '2021-11-30', city_code)
FROM 
	orders o
