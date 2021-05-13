
-- Finding the most lucrative routes (lucrative = highest fare per dist unit)

SELECT fare_per_dist_unit, departure_city, arrival_city, distance, scheduled_duration
FROM {{ ref('step6') }} 
ORDER BY fare_per_dist_unit DESC
LIMIT 10

