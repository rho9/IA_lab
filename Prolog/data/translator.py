from PIL import Image
import sys

if len(sys.argv) != 2:
    print("usage python3 translator.py filename")
    exit()

filename = sys.argv[1][:-4]

# set up files
im = Image.open(filename+".png")
file = open(filename + ".pl", 'w')
file.write("% Configurazione labirinto " + filename + "\n\n")
pixels = im.load()

# get colored pixels
labirinto = {}
labirinto["walls"] = []

width, heigth = im.size

for i in range(width):
    for j in range(heigth):
        if pixels[i, j] == (0, 0, 255):
            labirinto['walls'].append((i+1, j+1))
        elif pixels[i, j] == (255, 0, 0):
            labirinto['start'] = (i+1, j+1)
        elif pixels[i, j] == (0, 255, 0):
            labirinto['end'] = (i+1, j+1)

# write prolog program
file.write("num_righe("+str(heigth)+").\n")
file.write("num_colonne("+str(width)+").\n\n")

file.write("iniziale(pos"+str(tuple(reversed(labirinto["start"])))+").\n")
file.write("finale(pos"+str(tuple(reversed(labirinto["end"])))+").\n\n")

file.writelines(map(
    lambda x: "occupata(pos"+str(tuple(reversed(x)))+").\n",
    labirinto["walls"])
)

print("Done.")
