#!/bin/bash

iterations=$1

echo "Starting benchmark program to run for 100 seconds."
./a.out > /dev/null &

echo "Running cachestat for $1 seconds."
./tools/cachestat.py 1 $iterations > output/cache_stdout &

echo "Running llcstat for $1 seconds."
./tools/llcstat.py $iterations > output/llc_stdout &

echo "Running biotop for $1 seconds, 1 times."
./tools/biotop.py $iterations 1 | grep "a.out" > output/biotop_stdout & 


echo "...running..."

wait

echo "Finished."

# usage getpid [varname] 
# function to get the pid of a process
#getpid(){
#    pid=$(exec sh -c 'echo "$PID"')
#    test "$1" && eval "$1=\$pid"
#}