########################################
# load libraries
########################################

# load some packages that we'll need
library(tidyverse)
library(scales)
library(lubridate)


# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')

currentYear <- year(Sys.Date())

########################################
# plot trip data
########################################

# plot the distribution of trip times across all rides
filter(trips, tripduration <quantile(tripduration, .99)) %>%
  ggplot() + 
  geom_histogram(aes(x=tripduration/60)) + 
  scale_x_log10()
# plot the distribution of trip times by rider type
filter(trips, tripduration < quantile(tripduration, .99)) %>%
  ggplot() + 
  geom_histogram(aes(x=tripduration)) + 
  scale_x_log10(label=comma) +
  xlab("Trip Duration") +
  facet_wrap(~ usertype, ncol=1, scale = "free_y")

# plot the total number of trips over each day
trips %>% group_by( ymd) %>% 
  summarise(count = n()) %>%
  ggplot(aes(x=ymd, y=count)) + 
  geom_point() + 
  xlab("Date") +
  ylab("Total number of trips")
# plot the total number of trips (on the y axis) by age (on the x axis) and age (indicated with color)

trips %>%
  mutate(age=2014 - birth_year) %>% group_by(age,gender) %>%
  summarise(count = n()) %>%
  ggplot(aes(x=age, y=count, color=gender)) + 
  geom_point(na.rm=TRUE) + 
  xlab("Age") +
  ylab("Total number of trips")
  
# plot the ratio of male to female trips (on the y axis) by age (on the x axis)
# hint: use the spread() function to reshape things to make it easier to compute this ratio
trips %>% 
  mutate(age=2014-birth_year) %>% 
  group_by(age, gender) %>% 
  summarize(count=n()) %>%
  spread(gender, count) %>% 
  mutate(ratio = Male/Female) %>%
  ggplot(aes(x=age, y= ratio)) + 
    geom_point(na.rm=TRUE) + 
    ylab("Male to Female ratio")

########################################
# plot weather data
########################################
# plot the minimum temperature (on the y axis) over each day (on the x axis)
weather  %>%
  ggplot(aes(x=ymd,y=tmin)) + 
  geom_point()
# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis)
# hint: try using the gather() function for this to reshape things before plotting
weather %>% 
  gather (key="type", value="temp", tmin,tmax) %>% 
  ggplot(aes(x=ymd,y=temp, color=type)) + 
  geom_point()
########################################
# plot trip and weather data
########################################

# join trips and weather
trips_with_weather <- inner_join(trips, weather, by="ymd")

# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this
trips_with_weather %>% 
  group_by(ymd,tmin) %>% 
  summarize(count=n()) %>%
  ggplot(aes(x=tmin, y=count)) + 
  geom_point()

# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this
substantial_precipitation = .5;
weather %>% ggplot() +
  geom_histogram(aes(x=prcp))
trips_with_weather %>%
  mutate(is_substantial=prcp>substantial_precipitation) %>% 
  group_by(is_substantial,ymd, tmin) %>% 
  summarize(count=n()) %>%
  ggplot(aes(x=tmin, y=count)) + 
  geom_point() +
  facet_wrap(facets = ~is_substantial)
# add a smoothed fit on top of the previous plot, using geom_smooth
trips_with_weather %>%
  mutate(is_substantial=prcp>substantial_precipitation) %>% 
  group_by(is_substantial,ymd, tmin) %>% 
  summarize(count=n()) %>%
  ggplot(aes(x=tmin, y=count)) + 
  geom_point() +
  geom_smooth() + 
  facet_wrap(facets = ~is_substantial)
# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
trips_with_weather %>%
  mutate(hour=hour(starttime)) %>% 
  group_by(ymd,hour) %>% 
  summarise(count=n()) %>%
  group_by(hour) %>% 
  summarise(avg=mean(x = count), sd = sd(x=count)) %>%
  View()
# plot the above
trips_with_weather %>%
  mutate(hour=hour(starttime)) %>% 
  group_by(ymd,hour) %>% 
  summarise(count=n()) %>% 
  group_by(hour) %>% 
  summarise(avg=mean(x = count), sd = sd(x=count)) %>%
  ggplot(aes(x=hour)) +
  geom_line(color="blue", aes(y=avg)) + 
  geom_ribbon(aes(ymin=avg-sd, ymax=avg+sd),alpha=.2)

trips_with_weather %>%
  mutate(hour=hour(starttime)) %>% 
  group_by(ymd,hour) %>% 
  summarise(count=n()) %>% 
  group_by(hour) %>% 
  summarise(avg=mean(x = count), sd = sd(x=count)) %>%
  ggplot(aes(x=hour, y= avg, fill = hour)) +
  geom_bar(na.rm = TRUE, stat="identity") +
  geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd), color ="red")
# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package
trips_with_weather %>% 
  mutate(weekday = wday(ymd)) %>%
  group_by(ymd, weekday) %>%
  summarise(count=n()) %>%
  group_by(weekday) %>%
  summarise(avg=mean(x=count), sd = sd(x=count)) %>%
  View()

trips_with_weather %>% 
  mutate(weekday = wday(ymd,label=TRUE)) %>%
  group_by(ymd, weekday) %>%
  summarise(count=n()) %>%
  group_by(weekday) %>%
  summarise(avg=mean(x=count), sd = sd(x=count)) %>%
  ggplot(aes(x=weekday,y=avg)) + 
  geom_bar(na.rm = TRUE, stat="identity") +
  geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd))

trips_with_weather %>%
  mutate(hour=hour(starttime)) %>% 
  group_by(ymd,hour) %>% 
  summarise(count=n()) %>% 
  group_by(hour,weekday=wday(ymd,label=TRUE)) %>% 
  summarise(avg=mean(x = count), sd = sd(x=count)) %>%
  ggplot(aes(x=hour)) +
  geom_line(aes(y=avg),na.rm = TRUE, stat="identity") +
  geom_ribbon(aes(ymin=avg-sd, ymax=avg+sd), alpha = .2) + 
  facet_wrap(facets = ~weekday)
