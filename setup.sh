#!/bin/bash

week=$1
day=$2

fileDir="./week${week}/work/day${day}"
filename="build.setup";

if [ ! -d $fileDir ]; then 
    mkdir -p $fileDir;
fi;

cd $fileDir;

if [ -f $filename ]; then
    while IFS='' read -r line || [[ -n $line ]]; do
        IFS=',' read -r -a cmd <<< $line;
        req=${cmd[0]};
        toExecute=${cmd[1]};
        if [ ! -f $req ]; then
            eval $toExecute;
        fi;
    done < $filename;
else
    touch build.setup
fi;

