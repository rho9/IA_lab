#!/usr/bin/env python3
from sys import argv
import re
import copy

f = open(argv[1], "r")
content = f.read()

giorni = ["lun", "mar", "mer", "gio", "ven"]
ore = ["8,9","9,10", "10,11", "11,12", "12,13", "13,14", "14,15"]
aule = ["a_lettere1", "a_lettere2", "a_matematica", "a_tecnologia", "a_musica", "a_inglese", "a_spagnolo", "a_religione", "l_arte", "l_scienze", "l_educazione_fisica"]
orari = {}
for i in range(len(aule)):
    orari.update({aule[i]:{}})
    for j in range(len(giorni)):
        orari[aule[i]].update({giorni[j]:{}})
        for k in range(len(giorni)):
            orari[aule[i]][giorni[j]].update({ore[k]:""})
content = content.replace('\n','')
content = content.split(" ")
for line in content:
    result = re.search(r'orario\((\w+),\w+,(\w+\d*),(\d+,\d+),(\w+),(\d,\w)\)', line)
    if result is not None: 
        if orari[result.group(2)][result.group(4)].__contains__(result.group(3)) and orari[result.group(2)][result.group(4)][result.group(3)]!="":
            orari[result.group(2)][result.group(4)].update({result.group(3):orari[result.group(2)][result.group(4)][result.group(3)]+'-'+result.group(5).replace(",","_")+":"+result.group(1)})
        else:
            orari[result.group(2)][result.group(4)].update({result.group(3):result.group(5).replace(",","_")+":"+result.group(1)})
s=''
for i in orari.keys():
    print("\n" + i)
    for j in orari[i].keys():
        s+=j+','
    s = s[:-1]
    print(s)
    s=''
    for k in orari[i][j].keys():
        print(k.replace(",","-"), end=',')
        for j in orari[i].keys():
            if orari[i][j].keys().__contains__(k):
                s += orari[i][j][k]+','
            else:
                s += ','
        s = s[:-1]
        print(s)
        s=''