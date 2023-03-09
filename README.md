## Boston Bluebikes SQL Project

### Introduction
Investing in effective public transportation is important now more than ever. With the global conversation around reducing carbon emissions and transitioning to electric vehicles, it is perhaps more practical to look into expanding public transit systems such as trains, buses, and bike-sharing. Having recently moved to Boston from Karachi where the infrastructure is centered around private transport, I was able to witness firsthand how small-scale solutions like Bluebikes can be so useful. Bluebikes allows residents of the greater Boston area ease of transportation, without having to worry about the hassles of fuel costs and parking tickets. As I moved here in September of this year, I was able to avail this service for free, as the city of Boston was allowing free usage of these bikes due to a month-long renovation of one of the subway lines. **With the data provided by Bluebikes, I wanted to compare and analyze bike usage, types of users, their carbon footprint, and station activity of residents of Boston between the months of September and August 2022.**

### About the dataset
The dataset for each month was downloaded from the Bluebikes website with the table displaying the following:
![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/1.jpg)

The data was imported into the database after creating a separate table for each month.

### Usage

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/2.jpg)

Querying for the usage  shows an increase in usage from **487,201 rides in August to 601,049 rides in September** an increase of **23.36%.** As we can see, this is a large percentage increase in the number of rides taken between two months. However, we cannot simply infer from this data, whether it is:
1. a normal month-over-month increase
2. if it is due to the service being free of cost
3. due to other factors that are not observable in this data set

Fortunately, Bluebikes recently uploaded the October dataset which we can use to compare our findings and confirm if this increase is a normal month-over month increase.

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/3.jpg)

Looking at the number of trips taken in October, we can see a 14.42% decrease in usage. In order to further explore this relationship we can compare the change in the number of customers and subscribers across all three months. A customer is defined here as someone who paid for a single trip, whereas a subscriber is someone who has signed up on the application and is billed monthly or anually to use the service.

**The reason for doing this is to check if the number of subscribers increased in September and then decreased in October as a subscription was required to use the service for free.**

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/4.jpg)

Comparing across three months, we can see that the number of subscribers **decreased by approx 20%.** This confirms that the increased usage was due to the subscribers who registered during the month of September.

#### Trip duration in minutes

The duration of each trip is also something that we should investigate further. We can calculate this by grouping the data into bins of 5 minutes and then counting the number of trips that fall within these bins. The result is shown graphically below:

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/5.jpg)

The graphs for both months show a **positive skew**, which means that we must shorten the range of the data and increase the sensitivity of the bins. We can create bins of 5 minutes and limit the range to between 0 and 40 mins as this is the duration for the majority of the trips.

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/6.jpg)

We can see that in terms of trip duration there isn’t too much of a change in the mode of the dataset which is between 6 and 7 mins, as shown in the graphs above. Graphically, we cannot analyze the mean of the trip duration and will have to run a query.

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/7.jpg)

The results show that the **mean has dropped by 3.5 minutes**. This may be due to the fact that people who are not regular users started taking trips, increasing the count of shorter trips between 5–15 mins, pulling the mean closer to the mode. It may also be explained via consumer psychology where if a person is paying for a single trip they will keep the bike out for the longest time possible to fully utilize the money they are spending, or that the user is only paying for a trip if they have a long distance to commute. We can test this by checking the average trip duration for both customers and subscribers.

**On average, a customer is likely to keep the bike out for three times as long as a subscriber is.** 

#### Station Activity
To check for changes in terms of stations, first, we will query for the total number of active stations in each month and then rank the stations based on activity to see where most trips start and end.

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/8.jpg)

The query shows that there were **436 stations active in August and 441 in September.**

In order to compare the activity between these two months we can first rank the ten most active stations in August.

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/9.jpg)

We can now compare the change in activity at these stations in September.

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/9.jpg)

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/10.jpg)

Apart from one station at Cross Street and Hanover Street, all stations showed an increase in activity, with the MIT station showing the highest increase. The activity at Harvard Square increased at the start of the academic term, making it the second most used station in September due to the influx of new and returning students.

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/11.jpg)

The highest activity levels area within the Cambridge area and attributed particularly to the presence of the Harvard and MIT campuses.

#### Checking where new stations have been added in September

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/12.jpg)

After querying for new stations added in September, we can see that service was expanded away from the city center into the greater Boston area with two stations each added in Medford and Salem.

#### Checking how many new bikes were added

![table](https://github.com/saadabidsubhan/bluebikes-sql/blob/main/Bluebikes_sql_output/12.jpg)

19 bikes were added across 5 stations showing an estimated average of around 4 bikes per station. As the number of docks at a standard station is 19 according to the Bluebikes website, this means that bikes were relocated from other areas to each of these new stations.

### Conclusion

The month of September saw an approximately **25% increase in the usage of Bluebikes primarily from people availing the free service.** The most active areas were found in popular tourist destinations such as Newbury Street and student hubs in Cambridge around Harvard and MIT. The month of September also saw **5 new stations and 19 new bikes** added to the Bluebikes system expanding the service into the Greater Boston area. **The increase in usage with the free month can show policymakers the willingness of people to use carbon-neutral transport like bikes given the right incentives.**

