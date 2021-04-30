#!/bin/bash

#usage sudo ./ebpfv.sh (-c [comm_name] | -p [pid]) [trace_dur] (optional [-m, -f, -k])

lookup_pid=0

if [ $1 == "-c" ]; then
    lookup_pid=1
elif [ $1 == "-p" ]; then
    p_pid=$2
fi

trace_dur=$3

run_memoryhier=0
run_filesys=0
run_syscalls=0
runall=1

# check flags to determine which tools to run
for flag in "$@"
do
    if [ "$flag" == "-m" ]; then
        echo "Tracing memory hierarchy."
        run_memoryhier=1
        runall=0
    fi
    if [ "$flag" == "-f" ]; then
        echo "Tracing file system."
        run_filesys=1
        runall=0
    fi
    if [ "$flag" == "-k" ]; then
        echo "Tracing system calls."
        run_syscalls=1
        runall=0
    fi
done

#echo "Starting benchmark program to run for 100 seconds."
#./benchmark/benchmark > /dev/null &

if [ $lookup_pid -eq 1 ]; then
    # get the pid based on name of processes passed in
    p_pid=($(pidof "$2"))
fi

if [ "${#p_pid[@]}" -ne 1 ]; then
    echo "Multiple pids found for command name \"$2\", running trace on all."
fi

if [ -z "$p_pid" ]; then
    echo "No pids found for command name \"$2\"."
    exit 1
fi

if [ $runall -eq 1 ]; then
    echo "No tracing flags passed, running all tracing tools."
fi



for p in "${p_pid[@]}"; do
    ######### MEMORY HIERARCHY ##########
    if [ $runall -eq 1 ] || [ $run_memoryhier -ne 0 ]; then
        ##### LLC Stat #####
        echo "Running llcstat on $p for $trace_dur seconds."
        ./tools/llcstat.py $p_pid $trace_dur 1> ./output/llc_stdout 2> ./output/llcstaterr.log &

        ##### BIO Top #####
        echo "Running biotop on $p for $trace_dur seconds."
        ./tools/biotop.py -C $p 1 $trace_dur 1> ./output/biotop_stdout 2> ./output/biotoperr.log &
    fi

    ########## File System #############
    if [ $runall -eq 1 ] || [ $run_filesys -ne 0 ]; then
        echo "Running funccount on $p for $trace_dur seconds."
        ./tools/funccount.py -p $p -d $trace_dur 'vfs_*' 1> ./output/funccount_stdout 2> ./output/funccoungerr.log &
        
        echo "Running tplist on $p for $trace_dur seconds."
        ./tools/tplist.py -v -p $p > ./output/tplist_stdout 2> ./output/err.log &
    fi

    ########## Kernel Calls ##########
    if [ $runall -eq 1 ] || [ $run_syscalls -ne 0 ]; then
        ##### UThreads #####
        echo "Running uthreads on $p for $trace_dur seconds."
        ./tools/uthreads.py -l none $p $trace_dur 1> ./output/uthread_stdout 2> ./output/uthreaderr.log &

        ##### Ucalls #####
        echo "Running ucalls on $p for $trace_dur seconds."
        ./tools/ucalls.py -S $p 1 $trace_dur 1> ./output/ucalls_stdout 2> ./output/ucallerr.log &

        ##### Stackcount #####
        echo "Running stackcount for c:malloc on $p for $trace_dur seconds."
        ./tools/stackcount.py -p $p -D $trace_dur c:malloc 1> ./output/stackcount_stdout 2> ./output/stackcounterr.log

        ###### ssl sniff ######
        echo "Running SSL sniff on $p for $trace_dur seconds."
        ./tools/sslsniff.py -p $p $trace_dur 1> ./output/sslsniff_stdout 2> ./output/sslsnifferr.log &
    fi

done

echo "...running..."

while [[ -n $(jobs -r) ]] 
do
    sleep 5
    echo "...running..."
done

echo "Finished trace, analyzing data..."

#./visualize.py

#echo "Running dcsnoop to collect all p_pid's dir cache lookups"
#python3 ./tools/dcsnoop.py -d $trace_dur -a | grep "$p_pid" > output/dcsnoop_stdout &
#echo "Running cachestat for $2 seconds."
#python3 ./tools/cachestat.py 1 $trace_dur > output/cache_stdout &