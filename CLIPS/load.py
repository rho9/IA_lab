#!/usr/bin/env python3

import subprocess as sp
import sys
import re
import glob

def sort_files(files, ordered_files, scanning):
    f = open(scanning, "r")
    content = f.read()

    found = re.finditer(r'import (\w+)', content)
    dependencies = []
    for i in found:
        dependencies.append(i.group(1).lower()+".clp")

    if dependencies == []:
        ordered_files.insert(0,scanning)
    else:
        dep = set(dependencies)
        dep_scanning = dep.pop()
        sort_files(dep, ordered_files, dep_scanning)
        ordered_files.append(dep_scanning)
        ordered_files.append(scanning)

    if files == set():
        return

    scanning = files.pop()
    sort_files(files, ordered_files, scanning)
        


if len(sys.argv) > 1:
    extracommands = sys.argv[1:]
    for i in range(len(extracommands)):
        extracommands[i] = "("+extracommands[i]+")"
    extracommands = "\n".join(extracommands)

p = sp.Popen(["clips"], stdout=sp.PIPE, stdin=sp.PIPE)

files = glob.glob("*.clp")
ordered_files = []
files = set(files)
scanning = files.pop()
sort_files(files, ordered_files, scanning)
ordered_files=list(dict.fromkeys(ordered_files))

input = ""
for f in ordered_files:
    input += "(load " + f + ")\n(agenda)\n(reset)\n"
if len(sys.argv) > 1:
    input += extracommands + "\n"
input += "(exit)\n"

print(input)

out, err = p.communicate(input=input.encode("utf-8"))
print(out.decode("utf-8"))