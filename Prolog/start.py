#!/usr/bin/env python3

import subprocess as sub
import sys
import os

path = sys.argv[0][:0-len("start.py")]


if len(sys.argv) < 1:
    print("usage python3 start.py")
    exit()
 
blacklist = ["labirinto_con_sol_vuoto_20", "generator", "translator"]
blacklist_ = [("ida_star", "chebyshev_distance", "labirinto_con_sol_30"), ("ida_star", "manhattan_distance", "labirinto_con_sol_30")]
algorithms = ["iterative_deepening", "ida_star", "a_star"]
euristics = ["chebyshev_distance", "manhattan_distance"]
data = set()


for _, _, files in os.walk(path + "/data"):
    for f in files:
        if f != "README.md":
            data.add(f.split(".")[0])

data = data - set(blacklist)
data = list(data) 

for d in data:
    for h in euristics:
        for a in algorithms:
            if not ((a,h,d) in blacklist_):
                print("\nStarting {} with heuristic {} and example {} ...".format(a, h, d))
                sub.run(["./{}{}/load.py".format(path, a), d, h, "15"])