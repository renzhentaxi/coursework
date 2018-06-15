#!/bin/bash

#copying files
weekDir=../../;
cp $weekDir/{weather.csv,download_trips.sh,load_trips.R,plot_trips.R} ./;

#download trips
./download_trips.sh

#load the trips
R <load_trips.R --no-save

#moves non-essential files to trash folder
mkdir trash && mv *.csv trash/
