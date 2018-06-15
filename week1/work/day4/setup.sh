#!/bin/bash

#copying files
weekDir=../../;
cp $weekDir/{weather.csv,download_trips.sh,load_trips.R,plot_trips.R} ./;

# ./download_trips.sh

# #load the trips
# R <load_trips.R --save

#moves non-essential files to archive folder
mkdir trash && mv *.csv trash/