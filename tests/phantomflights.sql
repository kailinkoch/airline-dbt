--Purpose: confirm no flights start and end in the same city
SELECT * FROM  {{ source('proj5', 'routes') }}
WHERE arrival_airport = departure_airport