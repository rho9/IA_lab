# Prolog
### Commenti
- `/*COMMENTI su più righe*/`
- `%COMMENTI su una riga`

### Compilare
- scrivi il tuo file
- salvalo in formato .pl
- apri il prompt dei comandi
- scrivi swipl e premi invio
- `['nome_file'].` //o percorso se sei da un'altra parte
- dovrebbe risponderti true
- ogni volta che fai modifiche al file devi salvare e ricaricarlo

### Comando da aggiungere a prolog per stampe complete
`set_prolog_flag(answer_write_options, [quoted(true), portray(true), spacing(next_argument)]).`

### Variabili
Devono essere scritte con l'iniziale maiuscola

### Risposte Multiple
swipl ti mostra la prima. Se ce ne sono altre ti dà la possibilità di vedere le altre inserendo `;`

### Connettivi Logici
- **and**: `,`
Esempio: piuCalorico(wurstel,X),piuCalorico(X,verza)

- **uguale**: `is`
- **diverso**: `\==`
- **minore uguale**: `=<` molto controintuitivo lol

Per espressioni booleane e altre magie guardare [qui](http://www.swi-prolog.org/pldoc/man?section=clpb-exprs).

### Debug
- scrivi `trace.`
- scrivi la regola da analizzare
- premi invio per vedere i vari step dei vari ragionamenti
- scrivi `nodebug.` per tornare alla modalità normale.

Vari possibili stati:
- *Fail*: indica che il percorso scelto non porta da nessuna parte -> backtracking -> si torna indietro
- *Redo*: riprova con un nuovo percorso
- *Exit verde*: ha avuto successo

### Find All
```
findall(X,member(X,[1,2,3,4]),R).
R = [1, 2, 3, 4].
```

```
findall(Azione,applicabile(Azione,pos(2,3)),ListaAzioni).
ListaAzioni = [est, ovest, nord, sud].
```
Trovami tutti i possibili valori di x

### Negazione Per Fallimento 
L'operatore della negazione per fallimento si scrive così `\+`.

Quando Prolog la trova, prova a dimostrare cosa è negato e:
- se è stato ritornato `true`, vuol dire che ci è riuscito e restituisce `false`
- se è stato ritornato `false`, vuol dire che non ci è riuscito e restituisce `true`
Nota: non puoi cominciare una regola con `\+`, è necessario aggiungere `true` prima: `:- true, \+goal`

### Cut
L'operatore del cut si scrive così `!`.

Rende definitive alcune scelte fatte nel corso della valutazione dall’interprete Prolog.
Ossia elimina alcuni blocchi (choice point) dallo stack di backtracking
Può essere utilizzato per fare una sorta di IF-THEN-ELSE:
`if a(.) then b else c`, diventa:
```
p(X) :- a(X), !, b.
p(X) :- c.
```

### Progetto Esame1
Iterative deepening: c'è sol a 1? no -> a 2? no ...
Così ottengo la soluzione ottima
Prova con write a vedere a quale soglia è. Se è troppo rispetto al labirinto che hai dovresti fermarti
per evitare di andare avanti all'infinito perché non c'è soluzione.

### Progetto Esame2
- iterative deepening
- Iterative deepening A* (Slide 5): imposta la soglia in base ad un'euristica in base a quanto è buono uno stato
(promettente una casella: quanto dista la casella in linea d'aria dall'arrivo)
Come reagisce l'algoritmo con auristiche diverse?
Se con una soglia non ottengo soluzione, invece di aumentare la soglia di un passo, l'aumento fino a
raggiungere la soluzione con la soglia più bassa (Manhattan Distance)
- A*: è in ampiezza ordinando in base all'euristica
Cerca di trovare più euristiche (magari fai confronti anche con quelle stupide. Es mettere 1  tutto (o qualcosa dii meno stupido)
Basta un dominio, ma fai le considerazioni e la sperimentazione (dimesione del problema, tipologia del problema
uscita non raggiungibile, più uscite, labirinto molto fitto)
