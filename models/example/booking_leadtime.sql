
-- Adding the total number of seats available per aircraft

SELECT A.book_ref
,A.book_date
,min(D.scheduled_departure)
,min(D.scheduled_departure)- A.book_date AS lead_time 
FROM {{source('proj5', 'bookings')}}  A
JOIN {{source('proj5', 'tickets')}}  B
    ON A.book_ref = B.book_ref
JOIN {{source('proj5', 'ticket_flights')}}  C
    ON B.ticket_no = C.ticket_no
JOIN {{source('proj5', 'flights')}}  D
    ON C.flight_id = D.flight_id
GROUP BY A.book_ref, A.book_date



