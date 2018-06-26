#!/bin/bash

week=$1
day=$2

currentDir=`pwd`
sourceDir="${currentDir}/week${week}";
fileDir="${sourceDir}/work/day${day}";
filename="build.setup";

if [ -d $fileDir ] 
then
    cd $fileDir
    for f in `find . ! -name "build.setup" ! -name "."`
    do
        destDir="${sourceDir}/${f}"
        fromDir="${fileDir}/${f}"
        if [ -f $fromDir ]; then
            if [ ! -f $destDir ]; then
                echo "new file ${f} detected;";
                cp $fromDir $destDir;
                git add $destDir;
            elif ! cmp -s $fromDir $destDir; then
                echo "change in file ${f} detected;";
                cp $fromDir $destDir;
                git add $destDir;
            fi;
        elif [ ! -d $destDir ]; then 
            echo "new folder ${f} detected;";
            mkdir -p $destDir;
            git add $destDir;
        fi;
    done
fi;