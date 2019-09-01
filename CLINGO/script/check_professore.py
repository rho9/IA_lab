# argomento: un file con dentro solo "orario(..." con ogni orario separato con uno spazio dagli altri
# restituisce true se nessun professore ha piu lezioni nello stesso momento

from sys import argv

f = open(argv[1], "r")
content = f.read()
lezione = []
orario = []

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
	aux = e.split(",")[0]
	docente = aux.split("(")[1]
	lezione.append(docente)
	lezione.append(e.split(",")[4])
	lezione.append(e.split(",")[5])
	lezione.append(e.split(",")[6])
	orario.append(lezione)
	lezione = []
#print(orario)
print(checkEqual1(orario))