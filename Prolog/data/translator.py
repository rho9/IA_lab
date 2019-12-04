#!/usr/bin/env python3

from PIL import Image
import sys

if len(sys.argv) != 2:
    print("usage python3 translator.py filename")
    exit()

path = sys.argv[0][:0-len("translator.py")]

filename = sys.argv[1]

# set up files
im = Image.open(path +filename+".png")
file = open(path+filename + ".pl", 'w')
file.write("% Configurazione labirinto " + filename + "\n\n")
pixels = im.load()

# get colored pixels
labirinto = {}
labirinto["walls"] = []
labirinto["start"] = []
labirinto["end"] = []

width, heigth = im.size

for i in range(width):
    for j in range(heigth):
        if pixels[i, j] == (0, 0, 255) or pixels[i, j] == (0, 0, 255, 255):
            labirinto['walls'].append((i+1, j+1))
        elif pixels[i, j] == (255, 0, 0) or pixels[i, j] == (255, 0, 0, 255):
            labirinto['start'].append((i+1, j+1))
        elif pixels[i, j] == (0, 255, 0) or pixels[i, j] == (0, 255, 0, 255):
            labirinto['end'].append((i+1, j+1))

# write prolog program
file.write("num_righe("+str(heigth)+").\n")
file.write("num_colonne("+str(width)+").\n\n")

for start in labirinto["start"]:
    file.write("iniziale(pos"+str(tuple(reversed(start)))+").\n")
for end in labirinto["end"]:
    file.write("finale(pos"+str(tuple(reversed(end)))+").\n")

file.write("\n")

file.writelines(map(
    lambda x: "occupata(pos"+str(tuple(reversed(x)))+").\n",
    labirinto["walls"])
)

file.close()

print("Done.")
