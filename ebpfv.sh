#!/bin/bash


iterations=$1
trace_process=$2


echo "Starting benchmark program to run for 100 seconds."
./benchmark/benchmark > /dev/null &
p_pid=$!
echo "$p_pid"

echo "Running cachestat for $1 seconds."
python3 ./tools/cachestat.py 1 $iterations > output/cache_stdout &

echo "Running llcstat for $1 seconds."
python3 ./tools/llcstat.py $p_pid $iterations > output/llc_stdout &

echo "Running biotop for p_pid processes for $1 seconds, 1 times."
python3 ./tools/biotop.py $p_pid $iterations 1 > output/biotop_stdout & 

echo "Running dcsnoop to collect all p_pid's dir cache lookups"
python3 ./tools/dcsnoop.py -d $iterations -a | grep "$p_pid" > output/dcsnoop_stdout &



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
