#!/bin/bash


# optional timing parameter 
iterations=$1
trace_process=$2


echo "Starting benchmark program to run for 100 seconds."
./benchmark/benchmark > /dev/null &
p_pid=$!
echo "$p_pid"

echo "Running cachestat for $1 seconds."
./tools/cachestat.py 1 $iterations > output/cache_stdout &

echo "Running llcstat for $1 seconds."
./tools/llcstat.py $iterations > output/llc_stdout &

if [ -z "$trace_process" ]
then
    echo "Running biotop for all processes for $1 seconds, 1 times."
    ./tools/biotop.py $iterations 1 > output/biotop_stdout & 
else
    echo "Running biotop on $2 for $1 seconds, 1 times."
    ./tools/biotop.py $iterations 1 | grep $2 > output/biotop_stdout & 
fi


echo "...running..."

while [[ -n $(jobs -r) ]] 
do
    sleep 10
    echo "...running..."
done

rm *.txt
rm *.txt.

echo "Finished."


# usage getpid [varname] 
# function to get the pid of a process
#getpid(){
#    pid=$(exec sh -c 'echo "$PID"')
#    test "$1" && eval "$1=\$pid"
#}