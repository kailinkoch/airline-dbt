--Description: confirm all bookings had some cost
SELECT * FROM {{ source('proj5', 'bookings') }}
WHERE total_amount = 0