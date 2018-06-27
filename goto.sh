#!/bin/bash
week=$1
day=$2

fileDir="./week${week}/work/day${day}"
echo $#
# if [ $# -eq 1 ]

if [ -d "${fileDir}" ]; then
    code $fileDir
else
    echo "${0} <week> <day>"
    echo "${0} <week>/<day>"
    echo "${0} <week>"
fi;