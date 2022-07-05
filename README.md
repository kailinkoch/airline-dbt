
# Airline Data Pipeline 

## Contents
* Background
* Use Case
* Data
* Code
* Data Pipeline
* Tests

## Background
This was a final project for a graduate data engineering course. I implement a reusable data pipeline using reusable DBT data pipeline, including cleaning and transforming the raw data. I chose to focus on airlines, because I find airline logistics really fascinating.

## Use Cases
For the purposes of this project, I am a data engineer working with a data scientist who is creating a model to forecast air travel demand. The current data is organized at the flight level. However, to conduct her analysis, the data must be restructured at the route level. She also needs some additional variables to feed into her model, such as the distance, occupancy and duration of the route. My hypothesis is structuring the data at the route level will make it easier to identify patterns across flights and reduce the noisiness of the data. A route in this case is all the flights that start and end at the same airport. Only one aircraft type flew each route. 

## Data
I used this publically available dataset from PostGres, which had Russian flight data from 3 months of 2017. The dataset had about 70k rows. The dataset can be found [here](https://postgrespro.com/docs/postgrespro/10/demodb-bookings). Specifically, I used the demo-medium-en.zip file.
![Screen Shot 2022-07-05 at 9 46 27 AM](https://user-images.githubusercontent.com/68975515/177377029-c8da6e83-de6c-44ba-9e6b-b394364c921e.png)

## Code
The code for this data pipeline can be found in the .yml file and models folder of this repository.

## Data Pipeline
![Screen Shot 2022-07-05 at 9 38 16 AM](https://user-images.githubusercontent.com/68975515/177375612-4a261498-87f4-4578-ac72-ecd2901604c5.png)
### Step 1: Allow for some distance based estimates at the route level 
Steps: 
* Rough point distance estimate between airports (not perfect distance of route flown, but approximation) 
* Calculate duration from arrival and departure times 
* Identify if timezone change occurs via a boolean if arrival timezone = departure timezone 
![Screen Shot 2022-07-05 at 9 46 34 AM](https://user-images.githubusercontent.com/68975515/177377054-bbe9bba4-7d5b-4861-b1c1-525cec3e4dbf.png)

### Step 2: Aggregate ticket and flight data at the route level 
Steps: 
* Count unique flights 
* Sum ticket info (seats purchased etc) 
* Group by route (aircraft, departure airport, arrival airport) 
![Screen Shot 2022-07-05 at 9 47 55 AM](https://user-images.githubusercontent.com/68975515/177377216-51688807-2daa-42c5-8389-fa00626cd61c.png)

### Step 3: Get available seats to determine occupancy 
Steps: Use aircraft info to determine number of seats available per aircraft, multiply by number of flights to get total number of seats. 

### Step 4: Calculate occupancy per route 
Steps: Add a column calculating occupancy (purchased seats / total seats) 

### Step 5: Determine busiest average departure airports 
Steps: Use a window function to partition avg num_flights on departure airport 
![Screen Shot 2022-07-05 at 9 48 16 AM](https://user-images.githubusercontent.com/68975515/177377310-3980e4f2-329e-4596-87ef-5a0ff62d76a5.png)

### Step 6: Make it easy to interpret data 
Steps: Add english name of airport and city, extracted from JSON. For readability this only includes the new columns but these were added to all of the additional columns in step4. 
![Screen Shot 2022-07-05 at 9 48 36 AM](https://user-images.githubusercontent.com/68975515/177377348-09285167-cf86-4765-ae40-0e9431a47851.png)

### Lucrative_Routes: Find the routes with the highest fare per distance unit 
Steps: Select the top 10 routes with the highest fare per distance unit measurements 
![Screen Shot 2022-07-05 at 9 48 56 AM](https://user-images.githubusercontent.com/68975515/177377383-530e4369-40e2-48dc-8dbf-88f6910886b9.png)

### Delays: Find the routes with max delays, among flights with actual data 
Steps: Compare scheduled with actual duration, take max per route 
![Screen Shot 2022-07-05 at 9 49 09 AM](https://user-images.githubusercontent.com/68975515/177377420-66c4721d-7197-4a53-9743-42ebe2f5ddc3.png)

### Booking_Leadtime: Create clear picture of how far in advance people purchased tickets 
Steps: Compare booking date to min flight departure date, calculate difference 
![Screen Shot 2022-07-05 at 9 50 07 AM](https://user-images.githubusercontent.com/68975515/177377568-d4f114db-7fa1-478a-88b6-33f9dfa9e857.png)

### New_Bookings: Identify new bookings that haven’t yet been analyzed 
Steps: Create incremental view of most recent bookings 
![Screen Shot 2022-07-05 at 9 49 57 AM](https://user-images.githubusercontent.com/68975515/177377538-3c91fb76-f69d-4cd5-9332-82e25812f2a2.png)

## Tests
Luckily for me, the creators of this dataset included a number of constraints that meant the data was pretty clean when it got to me. As such, I tried to focus on situations that might be valid data types but not logical (things a human would immediately find suspicious but a computer might not). I came up with three tests to validate the data behaved how we’d expect of an airline.With more time, I’d like to add some similar tests for newly created fields. For example, occupancy rate should never exceed 1, and booking lead time should never be negative. 

* Phantom flights: ensuring no flights took off and landed from the same airport
* Free bookings: no tickets were booked for $0 
* Short flights: there were no flights under 10 minutes. This could throw off duration calculations down the line.

