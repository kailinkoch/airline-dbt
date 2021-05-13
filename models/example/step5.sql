


-- partition by departing airport to see average distance

SELECT 
departure_airport,
arrival_airport,
num_flights,
avg(num_flights) OVER (partition by departure_airport)
FROM {{ ref('step4') }} 
group by departure_airport, arrival_airport, num_flights



-- SELECT 
-- departure_airport,
-- arrival_airport,
-- num_flights,
-- avg(num_flights) OVER (partition by departure_airport)
-- into step_five
-- FROM step_four
-- group by departure_airport, arrival_airport, num_flights