
-- Checking the max delay per route AMONG flights with reported actual times! (16K/40K flights)

SELECT A.aircraft_code,
B.departure_airport,
B.arrival_airport,
A.scheduled_duration,
MAX(B.actual_arrival - B.actual_departure) AS max_actual_duration,
MAX((B.actual_arrival - B.actual_departure) - A.scheduled_duration) AS max_delay
FROM {{ ref('step1') }}  A
LEFT JOIN  {{source('proj5', 'flights')}}  B
    ON A.aircraft_code = B.aircraft_code
AND A.departure_airport = B.departure_airport
AND A.arrival_airport = B.arrival_airport
WHERE actual_arrival IS NOT NULL
GROUP BY  A.aircraft_code,
B.departure_airport,
B.arrival_airport,
A.scheduled_duration



