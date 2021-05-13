
-- Find all new bookings


{{
    config(
        materialized='incremental'
    )
}}

SELECT passenger_id, book_date, B.ticket_no, fare_conditions, amount
FROM {{source('proj5', 'bookings')}}  A
JOIN {{source('proj5', 'tickets')}}  B 
ON A.book_ref = B.book_ref
JOIN {{source('proj5', 'ticket_flights')}}  C 
ON B.ticket_no = C.ticket_no
