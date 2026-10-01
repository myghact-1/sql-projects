# Divvy 2025 Bike-Share Analysis — Findings

## 1. Executive Summary

The 2025 Divvy dataset contains **5,552,994 recorded rides**. After checking the data for duplicate IDs, missing values, and invalid timestamps, **5,552,965 rides** were retained for analysis. Only 29 records were excluded because their end time was earlier than or equal to their start time.

The analysis shows that Divvy usage was strongly influenced by seasonality, time of day, and rider type. Members accounted for almost two-thirds of all rides, while casual riders represented just over one-third. However, casual riders had substantially longer average trips and a higher share of weekend usage.

Ride demand increased considerably from the beginning of the year and reached its highest level in the summer months, with August recording the highest number of rides. Evening hours were also the busiest, with 5 PM recording the highest number of rides.

Station-level analysis shows that demand is concentrated around a relatively small number of major stations and popular routes, particularly around downtown and recreational areas.

---

# 2. Dataset and Data Quality

The analysis began with **5,552,994 raw ride records** covering all 12 months of 2025.

Every `ride_id` was unique, meaning there were no duplicate ride IDs in the dataset.

During validation, 29 rides were found where:

```text
ended_at <= started_at
```

These records were excluded from the analytical table because they represent invalid or non-positive ride durations.

After cleaning:

- Raw rides: **5,552,994**
- Clean rides: **5,552,965**
- Excluded records: **29**
- Unique ride IDs: **5,552,994**

This means that only a very small fraction of the original records had to be excluded.

### Missing station information

Station information was less complete.

Approximately:

- **21.33%** of rides were missing the start station name.
- **22.39%** of rides were missing the end station name.

These records were not removed because the rides still contain useful information such as timestamps, rider type, duration, and, in most cases, geographic coordinates.

Therefore, station-specific analysis was performed only on records where the relevant station information was available.

---

# 3. Overall Rider Mix

Out of the 5,552,965 cleaned rides:

- **3,553,477** were made by members.
- **1,999,488** were made by casual riders.

This corresponds to:

- **63.99% member rides**
- **36.01% casual rides**

Members therefore accounted for the majority of annual ride volume.

However, the difference becomes more interesting when looking at how the two groups actually use the bike-share system.

---

# 4. Member vs Casual Rider Behavior

One of the clearest differences in the analysis is ride duration.

### Average ride duration

| Rider Type | Average Duration |
|---|---:|
| Member | 12.33 minutes |
| Casual | 22.60 minutes |

Casual rides were therefore considerably longer on average than member rides.

This suggests that the two rider groups may be using the service in different ways. Member trips appear to be shorter and potentially more consistent with routine transportation, while casual trips tend to last longer.


---

# 5. Weekday vs Weekend Behavior

Weekend usage shows another clear difference between the two rider groups.

### Weekend share

| Rider Type | Weekend Rides | Weekend Share |
|---|---:|---:|
| Casual | 745,989 | 37.31% |
| Member | 832,492 | 23.43% |

Although members generated more rides overall, a much larger proportion of casual riders' trips occurred on weekends.

This reinforces the difference observed in ride duration: casual riders appear to have a stronger association with longer and weekend-oriented trips, while member usage is more concentrated outside weekends.

Again, this is a behavioral pattern rather than proof of a specific purpose for the trips.

---

# 6. Monthly Demand and Seasonality

Ride volume varied significantly throughout 2025.

| Month | Total Rides |
|---|---:|
| January | 138,651 |
| February | 151,901 |
| March | 298,130 |
| April | 371,376 |
| May | 502,615 |
| June | 678,801 |
| July | 763,458 |
| August | **790,317** |
| September | 714,562 |
| October | 646,096 |
| November | 356,483 |
| December | 140,575 |

The dataset shows a strong seasonal pattern.

Ride volume was relatively low in January and February, then increased substantially from March onward. Demand continued rising through spring and reached its highest point in **August, with 790,317 rides**.

After August, ride volume began to decline:

- September: 714,562
- October: 646,096
- November: 356,483
- December: 140,575

This creates a clear rise-and-fall pattern across the year, with the highest activity concentrated during the warmer middle months.

---

# 7. Peak Riding Hours

The hourly analysis shows that demand was particularly concentrated during the afternoon and early evening.

The busiest hours were:

| Rank | Hour | Rides |
|---|---:|---:|
| 1 | 17:00 | 572,442 |
| 2 | 16:00 | 509,937 |
| 3 | 18:00 | 459,706 |
| 4 | 15:00 | 391,239 |
| 5 | 14:00 | 327,147 |

The **5 PM hour was the busiest individual hour**, with more than 572,000 rides.

Demand was also relatively high around 4 PM and 6 PM, indicating a strong concentration of usage during the late afternoon and early evening.

From an operational perspective, these periods represent important demand windows for monitoring bike availability and station capacity.

---

# 8. Highest-Demand Stations

The start-station analysis shows that a relatively small group of stations generated a large amount of activity.

The top 10 start stations were:

1. **Kingsbury St & Kinzie St** — 40,612 rides
2. **DuSable Lake Shore Dr & Monroe St** — 39,630 rides
3. **Michigan Ave & Oak St** — 35,138 rides
4. **Navy Pier** — 35,135 rides
5. **DuSable Lake Shore Dr & North Blvd** — 33,816 rides
6. **Clinton St & Washington Blvd** — 30,650 rides
7. **Streeter Dr & Grand Ave** — 30,065 rides
8. **Clark St & Elm St** — 29,896 rides
9. **Canal St & Madison St** — 29,195 rides
10. **Clinton St & Madison St** — 28,982 rides

The highest-volume stations are concentrated around major downtown, waterfront, recreational, and transportation areas.

**Kingsbury St & Kinzie St** had the highest number of recorded ride starts among the stations analyzed.

---

# 9. Most Popular Routes

The route analysis shows that several station pairs were used repeatedly throughout the year.

The most frequently observed route was:

**DuSable Lake Shore Dr & Monroe St → DuSable Lake Shore Dr & Monroe St**

with **6,782 rides**.

Other high-volume routes included:

- Navy Pier → Navy Pier — 5,824 rides
- Ellis Ave & 60th St → Ellis Ave & 55th St — 4,424 rides
- Streeter Dr & Grand Ave → Streeter Dr & Grand Ave — 4,394 rides
- Michigan Ave & Oak St → Michigan Ave & Oak St — 4,379 rides
- Ellis Ave & 55th St → Ellis Ave & 60th St — 4,249 rides

The presence of several same-station routes is notable. These trips likely represent rides where users begin and finish at the same station, although the SQL analysis itself does not establish the reason for the trip.

---

# 10. Key Behavioral Patterns

Several consistent patterns emerge from the analysis.

### Members

Members account for approximately **64% of all rides**.

Their average ride duration is relatively short at **12.33 minutes**, and only **23.43%** of member rides occurred on weekends.

This indicates that member usage is more concentrated outside weekends and involves shorter average trips.

### Casual riders

Casual riders account for approximately **36% of all rides**.

Their average ride duration is almost twice that of members at **22.60 minutes**, and **37.31%** of their rides occurred on weekends.

Casual usage therefore has a stronger weekend component and longer average trip duration.

---

# 11. Operational Observations

The analysis highlights several areas that could be relevant from an operational perspective.

### Peak-hour demand

The strongest hourly demand occurs between approximately 3 PM and 6 PM, with 5 PM being the busiest hour.

This suggests that station availability and bike distribution during these periods are important operational considerations.

### Seasonal demand

Demand increases sharply from spring into summer and then declines through autumn and winter.

The difference between August's 790,317 rides and December's 140,575 rides demonstrates how strongly annual demand varies by season.

### Station concentration

A relatively small number of stations appear repeatedly among the highest-demand locations and routes.

These stations could therefore be useful candidates for more detailed capacity and availability analysis.

### Rider segmentation

Members and casual riders exhibit noticeably different usage patterns.

The differences in average duration and weekend share suggest that analyzing the two groups separately provides more insight than looking only at total ride volume.

---

# 12. Data Limitations

There are several limitations that should be considered when interpreting the results.

### Missing station information

Around one-fifth of rides are missing station names. Therefore, station and route analysis does not represent the entire dataset.

### Long-duration rides

Long rides were retained rather than automatically removed. A long duration does not necessarily mean that the record is incorrect, so these observations should be investigated separately before being treated as errors.

### Descriptive analysis

The results describe patterns in the 2025 dataset. They do not by themselves establish why those patterns occurred.

For example, the analysis shows that casual riders have longer rides, but it does not prove the reason for that difference.

---

# 13. Final Takeaways

The 2025 Divvy data reveals a clear and highly seasonal pattern of bike-share usage.

The main findings are:

1. **5.55 million rides** were recorded during 2025.
2. **Members generated 63.99% of rides**, while casual riders generated 36.01%.
3. **Casual rides averaged 22.60 minutes**, compared with 12.33 minutes for members.
4. Casual riders had a higher weekend usage share (**37.31%**) than members (**23.43%**).
5. **August was the busiest month**, with 790,317 rides.
6. **December was the quietest month**, with 140,575 rides.
7. **5 PM was the busiest riding hour**, with 572,442 rides.
8. Demand was concentrated around several major downtown and waterfront stations.
9. The dataset contained **29 invalid timestamp records**, which were excluded from analysis.
10. Missing station names affect roughly **one-fifth of the dataset**, so station-level findings should be interpreted with that limitation in mind.

Overall, the analysis shows that looking beyond total ride counts provides a much clearer picture of how the bike-share system is being used. Rider type, time of day, season, station, and route all reveal different aspects of demand that would be missed by a simple annual ride-count analysis.
