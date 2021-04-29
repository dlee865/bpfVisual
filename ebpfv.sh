#!/bin/bash

#usage sudo ./ebpfv.sh [proc_name] [trace_dur]

proc_name=$1
trace_dur=$2

echo "Starting benchmark program to run for 100 seconds."
./benchmark/benchmark > /dev/null &

# get the pid based on name of processes passed in
p_pid=$(pidof "$1")

######### MEMORY HIERARCHY ##########

##### LLC Stat #####
echo "Running llcstat on $p_pid for $trace_dur seconds."
python3 ./tools/llcstat.py $p_pid $trace_dur > output/llc_stdout &

##### BIO Top #####
echo "Running biotop on $p_pid for $trace_dur seconds."
python3 ./tools/biotop.py $p_pid $trace_dur 1 > output/biotop_stdout &

########## File System #############
echo "Running funccount on $p_pid for $trace_dur seconds."
python3 ./tools/funccount.py -p $p_pid -d $trace_dur 'vfs_*' > output/funccount_stdout &



##### UThreads #####


##### Ucalls #####



###### TP List #####






echo "...running..."

while [[ -n $(jobs -r) ]] 
do
    sleep 10
    echo "...running..."
done

rm *.txt
rm *.txt.

echo "Finished."



#echo "Running dcsnoop to collect all p_pid's dir cache lookups"
#python3 ./tools/dcsnoop.py -d $trace_dur -a | grep "$p_pid" > output/dcsnoop_stdout &
#echo "Running cachestat for $2 seconds."
#python3 ./tools/cachestat.py 1 $trace_dur > output/cache_stdout &
