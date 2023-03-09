--The aim of this notebook is to track compare how incentivizing public transportation is refelcted in its uage. 

--First I created a table for each month to import the .csv files.

CREATE TABLE IF NOT EXISTS bluebikes_september

(											
	tripduration				INT,
	start_time					TIME,
	stop_time					TIME,
	start_station_id			VARCHAR,
	start_station_name			VARCHAR,
	start_station_latitude		DECIMAL,
	start_station_longitude		DECIMAL,
	end_station_id				VARCHAR,
	end_station_name			VARCHAR,
	end_station_latitude		DECIMAL,
	end_station_longitude		DECIMAL,
	bike_id						INT,
	user_type					VARCHAR,
	postal_code					VARCHAR	
);


CREATE TABLE IF NOT EXISTS bluebikes_august

(												
	tripduration				INT,
	start_time					TIME,
	stop_time					TIME,
	start_station_id			VARCHAR,
	start_station_name			VARCHAR,
	start_station_latitude		DECIMAL,
	start_station_longitude		DECIMAL,
	end_station_id				VARCHAR,
	end_station_name			VARCHAR,
	end_station_latitude		DECIMAL,
	end_station_longitude		DECIMAL,
	bike_id						INT,
	user_type					VARCHAR,
	postal_code					VARCHAR	
);


--Adding column for month to be able to segregate data after unioning the tables.

ALTER TABLE bluebikes_august 
ADD month VARCHAR 

UPDATE bluebikes_august
SET month = 'August'

ALTER TABLE bluebikes_september
ADD month VARCHAR 

UPDATE bluebikes_september
SET month = 'September'


--Total nnumber of trips in August vs September.

WITH full_table AS
( 
SELECT *
FROM bluebikes_august
UNION 
SELECT *
FROM bluebikes_september
)

SELECT 
	   SUM(CASE WHEN month IN('August') THEN 1 ELSE 0 END) AS total_rides_aug,
	   SUM(CASE WHEN month IN ('September') THEN 1 ELSE 0 END ) AS total_rides_sept
FROM full_table


--Total number of trips in October 

--Repeated steps taken for the above tables.

--Query for August v September v October rides

WITH full_table AS
( 
SELECT *
FROM bluebikes_august
UNION 
SELECT *
FROM bluebikes_september
)

SELECT 
	   SUM(CASE WHEN month IN('August') THEN 1 ELSE 0 END) AS total_rides_aug,
	   SUM(CASE WHEN month IN ('September') THEN 1 ELSE 0 END ) AS total_rides_sept,
	   SUM(CASE WHEN month IN ('October') THEN 1 ELSE 0 END ) AS total_rides_october
FROM full_table

--Comparing the number of Subscribers vs Customers 

SELECT 
	   SUM(CASE WHEN user_type IN ('Customer') THEN 1 ELSE 0 END ) AS num_customers_aug,
	   SUM(CASE WHEN user_type IN ('Subscriber') THEN 1 ELSE 0 END) AS num_subscribers_aug
FROM bluebikes_august
)

SELECT 
	   SUM(CASE WHEN user_type IN ('Customer') THEN 1 ELSE 0 END ) AS num_customers_sept,
	   SUM(CASE WHEN user_type IN ('Subscriber') THEN 1 ELSE 0 END) AS num_subscribers_sept
FROM bluebikes_september
)

SELECT 
	   SUM(CASE WHEN user_type IN ('Customer') THEN 1 ELSE 0 END ) AS num_customers_oct,
	   SUM(CASE WHEN user_type IN ('Subscriber') THEN 1 ELSE 0 END) AS num_subscribers_oct
FROM bluebikes_october


--Trip trip duration in mins

SELECT floor((tripduration/60)/10)*10 AS tripduration_mins, count(*)
FROM bluebikes_august
GROUP BY tripduration_mins
ORDER BY tripduration_mins


--Using the appropriate range

--For August with bins of 5 min
SELECT floor((tripduration/60)/5)*5 AS tripduration_mins, count(*)
FROM bluebikes_august
GROUP BY tripduration_mins
ORDER BY tripduration_mins

--For September with bins of 5 mins
SELECT floor((tripduration/60)/5)*5 AS tripduration_mins, count(*)
FROM bluebikes_september
GROUP BY tripduration_mins
ORDER BY tripduration_mins


--Calcualting trip average durations

SELECT AVG(tripduration/60) AS avg_trip_mins_aug
FROM bluebikes_august

SELECT AVG(tripduration/60) AS avg_trip_mins_sep
FROM bluebikes_september


--Comparing average trip durations of customers vs subscribers

SELECT AVG(tripduration/60) AS avg_trip_customer_aug
FROM bluebikes_august
GROUP BY user_type
HAVING user_type IN ('Customer')

SELECT AVG(tripduration/60) AS avg_trip_subscriber_aug
FROM bluebikes_august
GROUP BY user_type
HAVING user_type IN ('Subscriber')


--Number of active stations in August v September

WITH full_table AS
( 
SELECT *
FROM bluebikes_august
UNION 
SELECT *
FROM bluebikes_september
),

stations as (
 SELECT distinct start_station_id, month
 FROM full_table
)

SELECT 
    SUM(CASE WHEN month IN('August') THEN 1 ELSE 0 END) AS active_stations_aug,
    SUM(CASE WHEN month IN ('September') THEN 1 ELSE 0 END ) AS active_stations_sept
FROM stations;


--Ranking stations by activity in August

WITH t1 AS (
    SELECT start_station_id, start_station_name, COUNT(start_station_id) AS station_activity
    FROM bluebikes_august
    GROUP BY start_station_id, start_station_name
),

t2 AS (
 SELECT *,
 DENSE_RANK() OVER(ORDER BY station_activity DESC) AS aug_rank
 FROM t1
)

SELECT *
FROM t2;


--Ranking station activity in September

WITH t1 AS (
    SELECT start_station_id, start_station_name, COUNT(start_station_id) AS station_activity
 FROM bluebikes_september
 Group by start_station_id, start_station_name
),

t2 AS (
 SELECT *,
 DENSE_RANK() OVER(ORDER BY station_activity DESC) AS sept_rank
 FROM t1
)

SELECT *
FROM t2
LIMIT 10;


--Comparing station activity in August and September.

WITH t1 AS (
    SELECT start_station_id, start_station_name, COUNT(start_station_id) AS station_activity_aug
 FROM bluebikes_august
 Group by start_station_id, start_station_name
),

t2 AS (
 SELECT start_station_id, start_station_name, COUNT(start_station_id) AS station_activity_sept
 FROM bluebikes_september
 Group by start_station_id, start_station_name
)

SELECT t1.*, t2.station_activity_sept
FROM t1
LEFT JOIN t2
ON t1.start_station_id = t2.start_station_id
ORDER BY t1.station_activity_Aug DESC
LIMIT 10;


--Checking where new stations have been added in September.

WITH new_stations AS (
SELECT bs.start_station_name, bs.start_station_id
FROM bluebikes_september AS bs
LEFT JOIN bluebikes_august AS ba
ON ba.start_station_id = bs.start_station_id
WHERE ba.start_station_id IS NULL
)

SELECT distinct start_station_name, start_station_id
FROM new_stations
ORDER BY start_station_id;


--Checking how many bikes have been added. 
WITH full_table AS
( 
SELECT *
FROM bluebikes_august
UNION 
SELECT *
FROM bluebikes_september
),

bikes AS (
 SELECT distinct bike_id, month
 FROM full_table
)

SELECT 
    SUM(CASE WHEN month IN('August') THEN 1 ELSE 0 END) AS total_bikes_aug,
    SUM(CASE WHEN month IN ('September') THEN 1 ELSE 0 END ) AS total_bikes_sept
FROM bikes;
