# Prolog

### Progetto Esame1
Iterative deepening: c'è sol a 1? no -> a 2? no ...
Così ottengo la soluzione ottima
Prova con write a vedere a quale soglia è. Se è troppo rispetto al labirinto che hai dovresti fermarti
per evitare di andare avanti all'infinito perché non c'è soluzione.

### Progetto Esame2
- iterative deepening
- Iterative deepening A\* (Slide 5): imposta la soglia in base ad un'euristica in base a quanto è buono uno stato
(promettente una casella: quanto dista la casella in linea d'aria dall'arrivo)
Come reagisce l'algoritmo con auristiche diverse?
Se con una soglia non ottengo soluzione, invece di aumentare la soglia di un passo, l'aumento fino a
raggiungere la soluzione con la soglia più bassa (Manhattan Distance)
- A\*: è in ampiezza ordinando in base all'euristica
Cerca di trovare più euristiche (magari fai confronti anche con quelle stupide. Es mettere 1  tutto (o qualcosa di meno stupido).
Basta un dominio, ma fai le considerazioni e la sperimentazione (dimesione del problema, tipologia del problema uscita non raggiungibile, più uscite, labirinto molto fitto).


## `start.py`
Per eseguire lo script:
```bash
./start.py labirinth_name
```
Non mettere il path del labirinto ma solo il nome.
Lo script esegue tutti gli algoritmi di esplorazione sul labirinto passato come parametro, elencando i tempi di esecuzione.
Per fare ciò lancia `load.py` nelle cartelle degli algoritmi. Il file lanciato crea `script.pl` che carica i files e formatta l'output. `load.py` inoltre lancia `start.py` all'interno delle folder degli algoritmi che lancia `script.pl` precedentemente creato.

## `setup.py`
Per eseguire lo script:
```bash
./setup.py algo_name
```
Lo script crea la folder e i files necessari per l'esecuzione automatica (`load.py` e `start.py`).

## `test.py`
```bash
./test.py number_of_labirinths
```
Lo script crea labirinti a caso usando `generate.py` e `translate.py`, e lancia tutti gli algoritmi su questi ultimi. Lo fa in modo simile a `start.py`.
Con *number_of_labirinths* si specifica con quanti labirinti testare gli algoritmi.