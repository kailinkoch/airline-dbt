
-- getting rough distance metric and basic route info

SELECT 
distinct
A.aircraft_code
,A.departure_airport
,A.arrival_airport
,A.scheduled_arrival - A.scheduled_departure AS scheduled_duration
,(point(B.coordinates) <@> point(C.coordinates))AS distance
,B.timezone != C.timezone as timezone_change
FROM {{source('proj5', 'flights')}} A
JOIN {{source('proj5', 'airports')}} B
    ON A.departure_airport = B.airport_code
JOIN {{source('proj5', 'airports')}} C
    ON A.arrival_airport = C.airport_code 
order by departure_airport, arrival_airport, aircraft_code






