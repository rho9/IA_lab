#!/usr/bin/env python

import subprocess as sub
import sys

path = sys.argv[0][:0-len("start.py")]

print("\nStarting dfs limitata ...")
sub.run(["./"+path+"dfs_limitata/load.py", "labirinto_easy", "100"])
print("\nStarting iterative deepening ...")
sub.run(["./"+path+"iterative_deepening/load.py", "labirinto_easy", "100"])