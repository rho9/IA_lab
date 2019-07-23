# Appunti su come usare Prolog
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