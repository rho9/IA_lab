#!/usr/bin/env python3

import subprocess as sub
import sys

path = sys.argv[0][:0-len("start.py")]

print("\nStarting ida star ...")
sub.run(["./"+path+"ida_star/load.py", "labirinto_easy", "100"])
print("\nStarting iterative deepening ...")
sub.run(["./"+path+"iterative_deepening/load.py", "labirinto_easy", "100"])
print("\nStarting a star ...")
sub.run(["./"+path+"a_star/load.py", "labirinto_easy", "100"])