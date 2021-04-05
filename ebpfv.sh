#!/bin/bash

echo "Starting benchmark program to run for 100 seconds."
./a.out & > /dev/null

echo "Running cachestat for 100 seconds."
./tools/cachestat.py 1 100 > output/cache_stdout &

echo "Running llcstat for 100 seconds."
./tools/llcstat.py 100 > output/llc_stdout &

echo "Running biotop for 5 seconds, 10 times."
./tools/biotop.py 5 5 | grep "a.out" > output/biotop_stdout & 


echo "...running..."

wait

echo "Finished."

# usage getpid [varname] 
# function to get the pid of a process
#getpid(){
#    pid=$(exec sh -c 'echo "$PID"')
#    test "$1" && eval "$1=\$pid"
#}