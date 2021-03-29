#!/usr/bash

# some example bpftrace one-liners to get started

# list all probes with or without a search term
sudo bpftrace -l 'tracepoint:syscalls:sys_enter_*'