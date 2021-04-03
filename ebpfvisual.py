#!/usr/bin/python3

import sys
import os

if len(sys.argv) < 2:
	print ("Expected input: ./ebpfvisual Flags (-b for base) Process (optional)")


stream = os.popen('./tools/biotop.py')
output = stream.read()
print (output)
