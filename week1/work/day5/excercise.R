library(tidyverse)
stocks <- tibble( year = c(2015, 2015, 2016, 2016), half = c(1,2,1,2), return = c(1.88, 0.59, 0.92, 0.17) ) 

stock2 <- stocks %>% spread(year, return)%>% gather("year", "return",'2015':'2016', convert=TRUE)

people <- tribble(
  ~name, ~key, ~value,
  "Phillip Woods", "age", 45,
  "Phillip Woods", "height", 186,
  "Phillip Woods", "age",50,
  "Jessica Cordero", "age", 37,
  "Jessica Cordero","height",156
)

people %>% group_by(name,key) %>% mutate(order=rank(name,ties.method = "last")) %>% ungroup() %>%
  mutate(key=ifelse(order==2,"original_age",key)) %>% select(-order) %>% spread(key,value)