# argomento: un file con dentro solo "orario(..." con ogni ha_lezione separata con uno spazio dalle altre
# restituisce true se nessuna classe ha piu lezioni nello stesso momento

from sys import argv

f = open(argv[1], "r")
content = f.read()
lezione = []
ha_lezioni = []

def checkEqual1(iterator):
    iterator = iter(iterator)
    try:
        first = next(iterator)
    except StopIteration:
        return True
    return all(first != rest for rest in iterator)

elem = content.split(" ")
#print(elem)
for e in elem:
	#print(e)
	lezione.append(e.split(",")[3])
	lezione.append(e.split(",")[4])
	lezione.append(e.split(",")[5])
	lezione.append(e.split(",")[6])
	lezione.append(e.split(",")[7])
	ha_lezioni.append(lezione)
	lezione = []
#print(ha_lezioni)
print(checkEqual1(ha_lezioni))
