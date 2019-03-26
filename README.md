# IA_lab

/*COMMENTI su più righe*/
%COMMENTI su una riga

COMPILARE
-scrivi il tuo file
-salvalo in formato .pl
-apri il prompt dei comandi
-scrivi swipl e premi invio
-['nome_file']. //o percorso se sei da un'altra parte
-dovrebbe risponderti true
-ogni volta che fai modifiche al file devi salvare e ricompilare

VARIABILI
Devono essere scritte con l'iniziale maiuscola

GESTIONE DI RISPOSTE MULTIPLE
swipl te ne mostra una. Se ce ne sono altre ti dà la possibilità di vedere le altre inserendo ";"

AND
Si utilizza la virgola.
Esempio: piuCalorico(wurstel,X),piuCalorico(X,verza)

UGUALE
is

DIVERSO
\==

DEBUG
-scrivi "trace."
-scrivi la regola da analizzare
-premi invio per vedere i vari ragionamenti
-scrivi "nodebug." per tornare alla normalità
Fail: indica che il percorso scelto non porta da nessuna parte -> backtracking -> si torna indietro
Redo: riprova con un nuovo percorso
Exit verde: ha avuto successo

FINDALL
findall(X,member(X,[1,2,3,4]),R).
R = [1, 2, 3, 4].
findall(Azione,applicabile(Azione,pos(2,3)),ListaAzioni).
ListaAzioni = [est, ovest, nord, sud].
Trovami tutti i possibili valori di x

NEGAZIONE PER FALLIMENTO (\+)
Quando Prolog la trova, prova a dimostrare cosa è negato e:
- se è stato ritornato true, vuol dire che ci è riuscito e restituisce false
- se è stato ritornato false, vuol dire che non ci è riuscito e restituisce true
Nota: non puoi cominciare una regola con lui -> devi aggiungere true prima: :- true, \+goal

CUT (!)
Rende definitive alcune scelte fatte nel corso della valutazione dall’interprete Prolog.
Ossia elimina alcuni blocchi (choice point) dallo stack di backtracking
Può essere utilizzato per fare un IF-THEN-ELSE:
if a(.) then b else c, diventa:
p(X) :- a(X), !, b.
p(X) :- c.

PROGETTO ESAME1
iterative deepening: c'è sol a 1? no -> a 2? no ...
Così ottengo la soluzione ottima
Prova con write a vedere a quale soglia è. Se è troppo rispetto al labirinto che hai dovresti fermarti
per evitare di andare avanti all'ifinito perché non c'è soluzione

PROGETTO ESAME2
-iterative deepening
-Iterative deepening A* (Slide 5): imposta la soglia in base ad un'euristica in base a quanto è buono uno stato
(promettente una casella: quanto dista la casella in linea d'aria dall'arrivo)
Come reagisce l'algoritmo con auristiche diverse?
Se con una soglia non ottengo soluzione, invece di aumentare la soglia di un passo, l'aumento fino a
raggiungere la soluzione con la soglia più bassa (Manhattan Distance)
-A*: è in ampiezza ordinando in base all'euristica
Cerca di trovare più euristiche (magari fai confronti anche con quelle stupide. Es mettere 1  tutto (o qualcosa dii meno stupido)
Basta un dominio, ma fai le considerazioni e la sperimentazione (dimesione del problema, tipologia del problema
uscita non raggiungibile, più uscite, labirinto molto fitto)