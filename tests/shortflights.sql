--Purpose: confirm there are no anomalously short flights in the dataset
SELECT * FROM {{ source('proj5', 'flights') }} 
WHERE scheduled_arrival - scheduled_departure < interval '10 minutes'