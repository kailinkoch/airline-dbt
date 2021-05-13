
-- Adding the start and end city and airports

SELECT A.*
,B.airport_name::json->'en' as departure_airport_name
,B.city::json->'en' as departure_city
,C.airport_name::json->'en' as arrival_airport_name
,C.city::json->'en' as arrival_city
FROM {{ ref('step4') }}  A
JOIN {{source('proj5', 'airports_data')}} B
on A.departure_airport = B.airport_code
JOIN airports_data C
ON A.arrival_airport=C.airport_code

