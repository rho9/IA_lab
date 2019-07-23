#!/usr/bin/env python3

import subprocess as sub
import sys

path = sys.argv[0][:0-len("start.py")]


if len(sys.argv) < 2:
    print("usage python3 start.py labirinth_name")
    exit()

labirinth_name = sys.argv[1]

print("\nStarting ida star ...")
sub.run(["./"+path+"ida_star/load.py", labirinth_name, "100"])
print("\nStarting iterative deepening ...")
sub.run(["./"+path+"iterative_deepening/load.py", labirinth_name, "100"])
print("\nStarting a star ...")
sub.run(["./"+path+"a_star/load.py", labirinth_name, "100"])