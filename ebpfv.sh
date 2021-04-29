#!/bin/bash

#usage sudo ./ebpfv.sh [proc_name] [trace_dur] (optional [-m, -f, -k])

proc_name=$1
trace_dur=$2

run_memoryhier=0
run_filesys=0
run_syscalls=0

# check flags to determine which tools to run
for flag in "$@"
do
    if [ "$flag" == "-m" ]; then
        echo "Tracing memory hierarchy."
        run_memoryhier=1
    fi
    if [ "$flag" == "-f" ]; then
        echo "Tracing file system."
        run_filesys=1
    fi
    if [ "$flag" == "-k" ]; then
        echo "Tracing system calls."
        run_syscalls=1
    fi
done


echo "Starting benchmark program to run for 100 seconds."
./benchmark/benchmark > /dev/null &

# get the pid based on name of processes passed in
p_pid=$( pidof "$1" | awk '{print $1}' )

######### MEMORY HIERARCHY ##########
if [ $run_memoryhier -ne 0 ]; then
    ##### LLC Stat #####
    echo "Running llcstat on $p_pid for $trace_dur seconds."
    python3 ./tools/llcstat.py $p_pid $trace_dur > output/llc_stdout &

    ##### BIO Top #####
    echo "Running biotop on $p_pid for $trace_dur seconds."
    python3 ./tools/biotop.py $p_pid $trace_dur 1 > output/biotop_stdout &
fi

########## File System #############
if [ $run_filesys -ne 0 ]; then
    echo "Running funccount on $p_pid for $trace_dur seconds."
    python3 ./tools/funccount.py -p $p_pid -d $trace_dur 'vfs_*' > output/funccount_stdout &
    
    echo "Running tplist on $p_pid."
    python3 ./tools/tplist.py -v -p $p_pid > output/tplist_stdout &
fi

##### UThreads #####
if [ $run_syscalls -ne 0 ]; then
    echo "Running uthreads on $p_pid of $trace_dur seconds."
    python3 ./tools/uthreads.py -l none $p_pid $trace_dur > output/uthread_stdout &
fi


##### Ucalls #####









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
