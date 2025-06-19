create	database Ride_Sharing_Analytics;
use Ride_Sharing_Analytics;
select * from drivers;
select * from rides;

# Q. Show users who took more than 5 rides
select user_id, count(*)
from rides
group by user_id
having count(*)>5;

# Q. Find average fare per driver using CTE
select driver_id, avg(total_fare)
from rides
group by driver_id;

with my_cte as (select ride_id, driver_id,  avg(total_fare) as "new_avg"
				from rides
                group by ride_id, driver_id)
select new_avg 
from my_cte;

# Q17. Get the previous ride fare for each user
select total_fare,
  lag (total_fare) over (partition by user_id order by  total_fare) AS "previous_ride_fare"
from rides;

select * from drivers;
select * from rides; 

# Q. Add row number to each ride per user by date
select ride_id, ride_date,
row_number() over (partition by user_id order by ride_date ) as "row_num"
from rides;

# Q. Show rides with duration > 30 mins and fare/km > ₹15

select ride_id, trip_duration_min, total_fare/trip_distance_km 
from rides
where trip_duration_min>30 and (total_fare/trip_distance_km) >15;

# Q. Categorize rides into Low/Medium/High fare segments
select ride_id, base_fare,
case
  when base_fare> 100 then "High"
  when base_fare between 50 and 100 then "Medium"
  else "Low"
end as "segments"
from rides;

# Q. Rank drivers by total fare earned
select ride_id, total_fare,
rank() over (order by total_fare) as "rank"
from rides;

select * from drivers;
select * from rides; 
# Q. List all completed rides in Mumbai with fare above ₹300.
select ride_id, city, cancellation_status
from rides
where city="Mumbai" and cancellation_status="Completed" and total_fare>300;

# Q. Find drivers whose average fare is higher than overall average

select name from drivers
where driver_id in ( select driver_id
                    from rides
                    group by driver_id
                     having avg(total_fare) > (select avg(total_fare) 
                                              from rides));


# Q. Find the average trip distance per city.

select city, avg(trip_distance_km)
from rides 
group by city;
# Q. Count number of rides by month
select Month (start_date) as "month"
from rides;

select ride_id, ride_date,
count(ride_id) over (partition by ride_date order by ride_date) as" count"
from rides;
select * from drivers;
select * from rides; 

# Q. Update all rides with zero fare to ₹50 as minimum base.
update rides
set base_fare=50
where ride_id=10003;

# Q. Find top 3 most experienced drivers in Delhi
 select driver_id, name, experience_years
                    from drivers
                    where city = "Delhi"
                    order by experience_years desc
                    limit 3;

# Q. Delete records of cancelled rides before Jan 2023.
delete from rides 
where cancellation_status="Cancelled" and ride_date < "2023-01-01";

# Q. Show top 5 most expensive rides.

select ride_id, total_fare as "expensive_rides"
from rides
order by total_fare desc
limit 5;
select * from drivers;
select * from rides; 

# Q. List cities with average fare > ₹250.
select city
from drivers
where driver_id in  (select driver_id
					from rides
                    group by driver_id
				    having avg(total_fare)>25);

# Q. Add a column surge_multiplier to track surge pricing.

alter table drivers
add column surge_multiplier varchar(50);
select * from drivers;
select * from rides; 

# Q. Write the SQL command to remove this is_active column from the table.

alter table drivers
drop column is_active;


#  Q: Get a combined list of all unique cities from both drivers and rides tables.
 
select city from rides
union
select city from drivers;

# Q: Get names of drivers who have driven rides in more than 1 city.

select name
from drivers
where driver_id in (select driver_id
                    from rides
                    group by driver_id
                    having count(*)>1);


# Q: Show all rides and attach driver names if available.

# Q: Get a list of all cities (including duplicates) from both drivers and rides.
select * from drivers;
select * from rides; 

select *
from rides
left join drivers
on rides.driver_id=drivers.driver_id;

# Q: Get the name and city of drivers along with total fare from each of their rides.

select drivers.name, drivers.city, rides.total_fare
from drivers
inner join rides
on rides.driver_id=drivers.driver_id;

# Q: List all drivers and their ride total_fare, even if they haven’t driven any rides.
select *
from drivers
left join rides
on rides.driver_id=drivers.driver_id;


# Q: Find drivers who have more than 1000 rides.

select name
from drivers
where driver_id in (select driver_id
                    from rides 
                    group by driver_id
                    having count(*) >1000);
                    

select * from drivers;
select * from rides; 