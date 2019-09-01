# argomento: un file con dentro solo "orario(..." con ogni orario separato con uno spazio dagli altri
# restituisce true se in nessuna aula viene tenuta piu di una lezione nello stesso momento

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
	lezione.append(e.split(",")[2])
	lezione.append(e.split(",")[3])
	lezione.append(e.split(",")[4])
	lezione.append(e.split(",")[5])
	orario.append(lezione)
	lezione = []
#print(orario)
print(checkEqual1(orario))