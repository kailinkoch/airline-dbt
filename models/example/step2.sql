
-- Use the `ref` function to select from other models

-- Aggregating flight data at aircraft by route level 

SELECT 
COUNT(distinct d.flight_id) as num_flights
,SUM(d.amount) AS total_fare
,COUNT(d.ticket_no) AS purchased_seats
,A.*
FROM {{ ref('step1') }} A
JOIN {{source('proj5', 'flights')}}  B
    ON A.aircraft_code = B.aircraft_code
    AND A.departure_airport = B.departure_airport
    AND A.arrival_airport = B.arrival_airport
JOIN {{source('proj5', 'ticket_flights')}}  D
    ON B.flight_id = D.flight_id
GROUP BY  
A.aircraft_code
,A.departure_airport
,A.arrival_airport
,A.scheduled_duration
,A.distance
,A.timezone_change
ORDER BY A.departure_airport, A.arrival_airport, A.aircraft_code





