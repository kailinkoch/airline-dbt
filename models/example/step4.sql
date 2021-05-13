
-- Aggregate fully at the route level

SELECT 
*
, cast(purchased_seats as decimal) / cast(total_seats as decimal)* 100 as occupancy_rate
, total_fare / distance as fare_per_dist_unit
from {{ ref('step3') }} 