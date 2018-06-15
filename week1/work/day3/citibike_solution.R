library(tidyverse)
library(lubridate)

########################################
# READ AND TRANSFORM THE DATA
########################################

# read one month of data
trips <- read_csv('201402-citibike-tripdata.csv')

# replace spaces in column names with underscores
names(trips) <- gsub(' ', '_', names(trips))

# convert dates strings to dates
# trips <- mutate(trips, starttime = mdy_hms(starttime), stoptime = mdy_hms(stoptime))

# recode gender as a factor 0->"Unknown", 1->"Male", 2->"Female"
trips <- mutate(trips, gender = factor(gender, levels=c(0,1,2), labels = c("Unknown","Male","Female")))


########################################
# YOUR SOLUTIONS BELOW
########################################

# 1.count the number of trips (= rows in the data frame)
number_of_trips <-nrow(trips)-1
# 2.find the earliest and latest birth years (see help for max and min to deal with NAs)
max(trips$birth_year,na.rm=TRUE);
min(as.numeric(trips$birth_year),na.rm=TRUE)
select(trips, birth_year) %>% filter(birth_year != "\\N") %>% arrange(birth_year) %>% head(1)
# 3.use filter and grepl to find all trips that either start or end on broadway
trips %>% filter(grepl('.*Broadway.*',start_station_name)| grepl('Broadway', end_station_name))
# 4.do the same, but find all trips that both start and end on broadway
trips %>% filter(grepl('.*Broadway.*',start_station_name) & grepl('Broadway', end_station_name))

# 5.find all unique station names
trips %>% select(start_station_name) %>% unique()
union(trips$start_station_name, trips$end_station_name)

# 6.count the number of trips by gender
trips %>% group_by(gender) %>% summarize(trips= n())
# 7.compute the average trip time by gender
trips %>% group_by(gender) %>% summarize(trips= mean(tripduration))

# comment on whether there's a (statistically) significant difference
#males appear to take shorter trips than female.
#registered users appear to take shorter trips than unregistered users
#8. find the 10 most frequent station-to-station trips
trips %>% 
  group_by(start_station_id, end_station_id) %>% 
  summarize(count=n()) %>%
  arrange(desc(count)) %>%
  head(10)
#9 find the top 3 end stations for trips starting from each start station
  trips %>%
    group_by(start_station_id, end_station_id) %>%
    summarize(count=n()) %>% group_by(start_station_id) %>%
    filter(rank(desc(count))<4) %>% arrange(desc(count))
# 10 find the top 3 most common station-to-station trips by gender
  trips %>%
  group_by(start_station_id,end_station_id,gender) %>%
  summarise(count=n()) %>% 
  group_by(gender) %>% 
  filter(rank(desc(count)) <4) %>% 
  arrange(gender)
# 11 find the day with the most trips 
# tip: first add a column for year/month/day without time of day (use as.Date or floor_date from the lubridate package)
  trips %>% mutate(ymd = as.Date(starttime)) %>% 
    group_by(ymd) %>% 
    summarize(count = n()) %>% 
    arrange(desc(count)) %>%
    head(1)
# 12 compute the average number of trips taken during each of the 24 hours of the day across the entire month
# what time(s) of day tend to be peak hour(s)?
  trips %>% 
    mutate(ymd= as.Date(starttime)) %>% 
    mutate(hour=hour(starttime)) %>% 
    group_by(ymd,hour) %>% 
    summarise(count=n()) %>% 
    group_by(hour) %>%
    summarise(avg=mean(count)) 
  
