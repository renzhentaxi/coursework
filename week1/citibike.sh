#!/bin/bash
#
# add your solution after each of the 10 comments below
#
file="./2014-02-citibike-tripdata.csv";
# file="./test.data"
# count the number of unique stations
# tail -n +2 $file| cut -d, -f5,9 | tr , "\n"| sort |uniq| wc -l;
# count the number of unique bikes
# tail -n +2 $file| cut -d, -f12 | sort |uniq| wc -l;
# count the number of trips per day
# tail -n +2 $file| cut -d, -f2 | tr -d \"| awk -F" " '{print $1}'|sort| uniq -c;
# tail -n +2 $file| cut -d, -f3 | tr -d \"| awk -F" " '{print $1}'|sort|uniq -c ;
# find the day with the most rides
# tail -n +2 $file| cut -d, -f2 | tr -d \"| awk -F" " '{print $1}'| sort|uniq -c|sort -n|tail -n1;
# find the day with the fewest rides
# tail -n +2 $file| cut -d, -f2 | tr -d \"| awk -F" " '{print $1}'| sort -n|uniq -c|sort -n |head -n1;
# find the id of the bike with the most rides
# tail -n +2 $file| cut -d, -f12| sort | uniq -c | sort -nr | head -n1
# count the number of rides by gender and birth year
# tail -n +2 $file| cut -d, -f14,15 | sort |uniq -c
# count the number of trips that start on cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)
# tail -n +2 $file| cut -d, -f5 | grep --color ".*[0-9].*&.*[0-9].*" | sort | uniq -c
# awk -F, '$5 ~ /.*[0-9].*&.*[0-9].*/ {print $5}' $file | sort | uniq -c
# compute the average trip duration

tail -n +2 $file| cut -d, -f1| tr -d \"  | awk -F, '{sum+=$1;n++} END{print sum/n}'