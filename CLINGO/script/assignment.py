#!/usr/bin/env python3
from sys import argv
import re
import copy

f = open(argv[1], "r")
content = f.read()

giorni = ["lun", "mar", "mer", "gio", "ven"]
ore = ["otto_nove","nove_dieci", "dieci_undici", "undici_dodici", "dodici_tredici", "tredici_quattordici", "quattordici_quindici"]
aule = ["aula_lettere1", "aula_lettere2", "aula_matematica", "aula_tecnologia", "aula_musica", "aula_inglese", "aula_spagnolo", "aula_religione", "lab_arte", "lab_scienze", "lab_educazione_fisica"]

orari = {}
for i in range(len(aule)):
    orari.update({aule[i]:{}})
    for j in range(len(giorni)):
        orari[aule[i]].update({giorni[j]:{}})
        for k in range(len(giorni)):
            orari[aule[i]][giorni[j]].update({ore[k]:""})
content = content.replace('\n','')
content = content.split(" ")
#print(content)
for line in content:
    result = re.search(r'ore_a_settimana\(\w+,(\w+),(\w+),(\w+),(\w+)\)', line)
    if result is not None: 
        if orari[result.group(1)][result.group(3)].__contains__(result.group(2)):
            orari[result.group(1)][result.group(3)].update({result.group(2):orari[result.group(1)][result.group(3)][result.group(2)]+'-'+result.group(4)})
        else:
            orari[result.group(1)][result.group(3)].update({result.group(2):result.group(4)})
s=''
for i in orari.keys():
    print("\n" + i)
    for j in orari[i].keys():
        s+=j+','
    s = s[:-1]
    print(s)
    s=''
    for k in orari[i][j].keys():
        print(k, end=',')
        for j in orari[i].keys():
            if orari[i][j].keys().__contains__(k):
                s += orari[i][j][k]+','
            else:
                s += ','
        s = s[:-1]
        print(s)
        s=''