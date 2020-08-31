#!/usr/bin/env python3
# argomento: un file con dentro solo "orario(..." con ogni ha_lezione separata con uno spazio dalle altre
# restituisce true se nessuna classe ha piu lezioni nello stesso momento

from sys import argv

f = open(argv[1], "r")
content = f.read()
ha_lezioni = []

elem = content.split(" ")
#print(elem)
for e in elem:
	#print(e)
	lezione=(e.split(",")[3], e.split(",")[4], e.split(",")[5], e.split(",")[6], e.split(",")[7])
	ha_lezioni.append(lezione)
#print(ha_lezioni)
s = set(ha_lezioni)
print(len(ha_lezioni)==len(s))
