#!/usr/bin/env python3

import subprocess as sub
import sys
from time import time, sleep

path = sys.argv[0][:0-len("start.py")]

start=time()
sub.run(["prolog", "-s", path+"script.pl", "--quiet"])
print("\nIt takes", time()-start, "seconds.\n")
