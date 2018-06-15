#!/bin/bash

#copying files
weekDir=../..;

cp -n $weekDir/citibike.R ./citibike_solution.R;

wget https://s3.amazonaws.com/tripdata/201402-citibike-tripdata.zip;
unzip 201402-citibike-tripdata.zip;
mv "2014-02 - Citi Bike trip data.csv" 201402-citibike-tripdata.csv;

mkdir trash;
mv 201402-citibike-tripdata.zip trash/;