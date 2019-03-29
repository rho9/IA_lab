#!/usr/bin/env python

import random as r
import sys
from PIL import Image

path = sys.argv[0][:0-len("generator.py")]

START = (255, 0, 0)
END = (0, 255, 0)

def generate_point(pxs, color):
    ri, rj = r.randint(0, width-1), r.randint(0, heigth-1)
    regen = False
    while pxs[ri, (rj - 1) % heigth] == (0, 0, 255) \
        and pxs[ri, (rj + 1) % heigth] == (0, 0, 255) \
        and pxs[(ri + 1) % width, rj] == (0, 0, 255) \
        and pxs[(ri - 1) % width, rj] == (0, 0, 255):
        regen = True
        while pxs[ri, rj] == END or pxs[ri, rj] == START or regen:
            regen = False
            ri, rj = r.randint(0, width-1), r.randint(0, heigth-1)
    pxs[ri, rj] = color

if len(sys.argv) < 3:
    print("usage python3 generator.py filename x [y]")
    exit()

filename = sys.argv[1]

# set up image
width = int(sys.argv[2])
heigth = int(sys.argv[len(sys.argv)-1])
image = Image.new("RGB", (width, heigth))
image = image.point(lambda i: 255)
pixels = image.load()


# change pixels
for i in range(width):
    for j in range(heigth):
        if not r.randint(0, 4):
            for k in range(r.randint(1, 4)):
                dx = r.randint(-1, 1)
                dy = r.randint(-1, 1)
                pixels[(i+k*dx) % width, (j+k*dy) % heigth] = (0, 0, 255)

# position start and end
generate_point(pixels, START)
generate_point(pixels, END)

# save image
image.save(path+filename+".png")

print("Done.")
