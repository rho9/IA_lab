#!/usr/bin/env python3
# argomento: un file con dentro solo "orario(..." con ogni orario separato con uno spazio dagli altri
# restituisce true se nessun professore ha piu lezioni nello stesso momento

from sys import argv

f = open(argv[1], "r")
content = f.read()
lezione = []
orario = []

elem = content.split(" ")
#print(elem)
for e in elem:
	#print(e)
	aux = e.split(",")[0]
	docente = aux.split("(")[1]
	lezione=(docente, e.split(",")[3], e.split(",")[4], e.split(",")[5])
	orario.append(lezione)
#print(orario)
print(len(orario)==len(set(orario)))