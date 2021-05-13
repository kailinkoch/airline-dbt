
-- Adding the total number of seats available per aircraft

WITH seatsclass AS
(SELECT 
count(seat_no) AS available_seats
, aircraft_code 
FROM {{source('proj5', 'seats')}}
GROUP BY aircraft_code
)
SELECT 
available_seats*num_flights as total_seats
,A.*
FROM {{ ref('step2') }}  A 
JOIN  seatsclass B
ON A.aircraft_code = B.aircraft_code



