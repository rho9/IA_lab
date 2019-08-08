#!/usr/bin/env python3

import subprocess as sub
import sys

if len(sys.argv) != 3:
    print("Usage python3 load.py labyrinth max \nExample python3 load.py esempio1 30")
    exit()

path = sys.argv[0][:0-len("load.py")]

file = open(path + "script.pl", "w")
file.write(":- initialization main.\n")
file.write("\n")
file.write("main :- consult(['"+path+"a_star.pl']),\n")
file.write("  consult(['"+path+"../azioni.pl']),\n")
file.write("  consult(['"+path+"../data/"+sys.argv[1]+".pl']),\n")
file.write("  consult(['"+path+"../heuristics/manhattan_distance.pl']),\n")
file.write("  a_star(X, 1),\n")
file.write("  atomic_list_concat(X, ', ', A),\n")
file.write("  atom_string(A, S),\n")
file.write("  format(\"Solution = \"),\n")
file.write("  format(S),\n")
file.write("  format(\".\\n\"),\n")
file.write("  halt.\n")
file.write("\n")
file.write("main :- format(\"Solution = \"),\n")
file.write("  format(\"false.\\n\"),\n")
file.write("  halt.\n")

file.close()

print("\nLoaded.\n")

sub.run("./"+path+"start.py")
