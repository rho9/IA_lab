#!/usr/bin/env python

import sys
import os
import subprocess as sub

path = sys.argv[0][:0-len("setup.py")]

if len(sys.argv) != 2:
    print("Usage python setup.py algorithm \nExample python setup.py iterative_deepening")
    exit()

#create folder and empty files
os.mkdir(path+sys.argv[1])
os.mknod(path+sys.argv[1]+"/"+sys.argv[1]+".pl")

#generate load.py file
file = open(path+sys.argv[1]+"/"+"load.py","w")
file.write("#!/usr/bin/env python\n")
file.write("\n")
file.write("import subprocess as sub\n")
file.write("import sys\n")
file.write("\n")
file.write("if len(sys.argv) != 3:\n")
file.write("    print(\"Usage python3 load.py labyrinth max \\nExample python3 load.py esempio1 30\")\n")
file.write("    exit()\n")
file.write("\n")
file.write("path = sys.argv[0][:0-len(\"load.py\")]\n")
file.write("\n")
file.write("file = open(path + \"script.pl\", \"w\")\n")
file.write("file.write(\":- initialization main.\\n\")\n")
file.write("file.write(\"\\n\")\n")
file.write("file.write(\"main :- consult(['\"+path+\""+sys.argv[1]+".pl']),\\n\")\n")
file.write("file.write(\"  consult(['\"+path+\"../azioni.pl']),\\n\")\n")                        
file.write("file.write(\"  consult(['\"+path+\"../data/\"+sys.argv[1]+\".pl']),\\n\")\n")
file.write("file.write(\"  "+sys.argv[1]+"(X, \"+sys.argv[2]+\"),\\n\")\n")                    
file.write("file.write(\"  atomic_list_concat(X, ', ', A),\\n\")\n")                 
file.write("file.write(\"  atom_string(A, S),\\n\")\n")
file.write("file.write(\"  format(\\\"Solution = \\\"),\\n\")\n")                                          
file.write("file.write(\"  format(S),\\n\")\n")                                 
file.write("file.write(\"  format(\\\".\\\\n\\\"),\\n\")\n")                                             
file.write("file.write(\"  halt.\\n\")\n")                                       
file.write("file.write(\"\\n\")\n")                                                                
file.write("file.write(\"main :- format(\\\"Solution = \\\"),\\n\")\n")
file.write("file.write(\"  format(\\\"false.\\\\n\\\"),\\n\")\n")                       
file.write("file.write(\"  halt.\\n\")\n")
file.write("\n")
file.write("file.close()\n")
file.write("\n")
file.write("print(\"\\nLoaded.\\n\")\n")
file.write("\n")
file.write("sub.run(\"./\"+path+\"start.py\")\n")

file.close()

sub.run(["chmod", "+x", "./"+sys.argv[1]+"/"+path+"load.py"])

#generate start.py file
file = open(path+sys.argv[1]+"/"+"start.py","w")

file.write("#!/usr/bin/env python\n")
file.write("\n")
file.write("import subprocess as sub\n")
file.write("import sys\n")
file.write("from time import time, sleep\n")
file.write("\n")
file.write("path = sys.argv[0][:0-len(\"start.py\")]\n")
file.write("\n")
file.write("start=time()\n")
file.write("sub.run([\"prolog\", \"-s\", path+\"script.pl\", \"--quiet\"])\n")
file.write("print(\"\\nIt takes\", time()-start, \"seconds.\\n\")\n")

sub.run(["chmod", "+x", "./"+sys.argv[1]+"/"+path+"start.py"])
