#!/bin/bash

echo "Running cachestat for 100 seconds."
./tools/cachestat.py 1 100 > ouput/cache_stdout &

echo "Running llcstat for 100 seconds."
./tools/llcstat.py 100 > output/llc_stdout &



# usage getpid [varname] 
# function to get the pid of a process
#getpid(){
#    pid=$(exec sh -c 'echo "$PID"')
#    test "$1" && eval "$1=\$pid"
#}