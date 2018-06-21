#!/bin/bash

filename="./build.setup";

while IFS='' read -r line || [[ -n $line ]]; do
    IFS=',' read -r -a cmd <<< $line;
    req=${cmd[0]};
    toExecute=${cmd[1]};
    if [ ! -f $req ]; then
        eval $toExecute;
    fi;
done < $filename;