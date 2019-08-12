# TO DO
- implementare una ricerca che trovi una soluzione qualunque
- Analizzare le risposte -> cercare di dare delle soluzioni (certainty) BLEAH
- Da gestire: Una visita turistica è rappresentata da un gruppo di una o più persone che occupano posti letto in
una località per un periodo di tempo di almeno una notte.
- in rules non più di 100km tra una meta e l'altra (nei cf un po' di tolleranza è ammessa)
- Gestione preferenza su una località (aggiungere campo a località: srà come un cf)

# Appunti
## main.clp
Gestisce il flusso di esecuzione (ha una salience molto alta per esssere sicuri che parta per primo).  
Le funzioni al suo interno gestiscono le domande che permettono di inferire i fatti
## questions.clp
Gestisce l'interazione con l'utente: le domande e le risposte possibili e asserisce i nuovi fatti

# Tipi primitivi
• float

• integer. Diverso "<>"

• symbol: e.g. this-is-a-symbol, wrzlbrmft, !?@\*+

• string: e.g. ”This is a string”

• external address (indirizzi o strutture dati restituite da funzioni user-defined)

• instance name (Cool)

• instance address (Cool)

Esempi di utilizzo

    (deftemplate student “a student record”
	(slot name (type STRING))
	(slot age (type INTEGER) (default 18) (range 0 ?VARIABLE) )
	(slot gender (type SYMBOL) (allowed-symbols male female))
    )
NOTA: `?VARIABLE` indica che il limite superiore non è specificato

    (deftemplate volleyball-team
	(slot name (type STRING))
	(multislot player (type STRING) (cardinality 6 6))
	(multislot alternates (type STRING) (cardinality 0 2))
    )

NOTA: l'attributo `cardinality` di `multislot` indica il numero minimo e massimo di valori che può essere memorizzato all'interno del multislot.
Formato generale: `(cardinality <lower (cardinality <lower-limit> <upper limit> <upper-limit>) limit>)`
dove `<lower‐limit>` e `<upper‐limit>` possono essere `?VARIABLE` (e quindi qualunque valore) o un intero positivo.

# Comandi
• Avvio da riga di comando (UNIX): `./clips`

• Terminare: `(exit)`

• Caricare i fatti: `(reset)`

• Eseguire le regole: `(run)`

• Caricare file: `(load percorso_file.clp)`

• Ripartire da capo: `(clear)`

• aggiungere fatti: `(assert <fact>+)`

• Rimuovere fatti: `(retract <fact-index>+)`. Per rimuovere tutti i fatti: `(retract *)`

• Modificare fatti: `(modify <fact-index> (<slot-name> <slot-value>)+ )`.
  Equivale a rimuovere il fatto originale e aggiungere il nuovo fatto modificato con un indice incrementato
  
• Duplicare fatti: `(duplicate <fact-index> (<slot-name> <slot-value>)+ )`

• Stampare (elencare) la lista dei fatti: `(facts)`
	
• Mostra automaticamente i cambiamenti che occorrono nella WM a seguito dell’esecuzione delle regole: `(watch facts)`. "<==" vuol dire che qualcosa è stato tolto; "==>" vul dire che qualcosa è stato inserito

• Mostrare, durante l’esecuzione, quali regole sono eseguite : `(watch rules)`

• Mostrare, durante l’esecuzione, quali attivazioni hanno permesso l’esecuzione delle regole: `(watch activations)`

•  Disattivare il watching: `(unwatch rules)` e `(unwatch activations)`. Puoi usare `(unwatch all)` per disabilitare tutti i fatti

• Ottenre l'indice del fatto: `(assert(fatto))`

• Elencare le regole definite fino a questo momento nella KB: `(rules)`

•  Mostrare la definizione della regola: `(ppdefrule nome-regola)`

• Mostrare l’agenda attuale:`(agenda)`. Restituisce l'elenco ordinato delle regole attivabili. La regola in cima sarà la prossima ad essere eseguita (per ogni regola sono indicati i fatti che l’attivano, cioè le precondizioni)

# Costrutti
• Fatto oridnato senza slot

  Esempio: `(person-name Verdi Franco L)`
  
• deftemplate: definisce fatti strutturati (detti non ordinati)

  Esempio:
  
     (deftemplate person "commento opzionale"
	(slot name)
	(slot age)
	(slot eye-color)
	(slot hair-color))
  
  Esempio di istanza:
  
     (person (name "Franco L. Verdi")
	(age 46)
	(eye-color brown)
	(hair-color brown))
  
• deffacts: definisce il set iniziale di fatti

# Fatti
Si usa il costrutto `deffacts`.

Esempio

    (deffacts famiglia-verdi "alcuni membri della famiglia Verdi"
	(person (name "Luigi") (age 46) (eye-color brown) ( hair-color brown))
	(person (name "Maria") (age 40) (eye-color blue) ( hair-color brown))
	(person (name "Marco") (age 25) (eye-color brown) ( hair-color brown))
	(person (name "Lisa") (age 20) (eye-color blue) ( hair-color blonde))
    )
    
NOTA: I fatti sno asseriti nella Working Memory (WM) solo dopo aver dato il comando `(reset)`

# Regole

Costrutto:

	(defrule <rule name> ["comment"]
	  <patterns>* ; left-hand side (LHS)
		      ; or antecedent of the rule
	=>
	  <actions>* ; right-hand side (RHS)
		      ; or consequent of the rule
	)

Esempio di istanza:

	(defrule birthday-FLV
	  (person (name "Luigi")
	    (age 46)
	    (eye-color brown)
	    (hair-color brown))
	    (date-today April-13-02)
	=>
	    (printout t "Happy birthday, Luigi!")
	    (modify 1 (age 47))
	)

NOTA: non usare un indice esplicito (qui 1) per modificare i fatti (è raro conoscerlo). Servono degli handlers forniti da variabili

# Debugging
Salvare tutto ciò che viene visualizzato sul terminale sul file indicato, compreso gli input dell’utente.: (dribble-on filename)
Disabilitare il comando: (dribble-off)

Breackpoints:
(set-break <rulename>)
(remove-break <rulename>)
(show-breaks)
Così dopo la run l'esecuzione va avanti finché non arriva alla regola che hai inserito
	
## Variabili
Nomi simbolici che iniziano con ? per campi singoli (uno slot), con $? per math da 0 a più valori in un multislot
Esempio:

	(defrule birthday-FLV
	  ?person <- (person (name "Luigi")
	    (age 46)
	    (eye-color brown)
	    (hair-color brown))
	    (date-today April-13-02)
	=>
	    (printout t "Happy birthday, Luigi!")
	    (modify ?person (age 47))
	)

	
## Priorità: Salience
Intervallo : [-10000, 10000].

	(defrule test-1 (declare (salience 100)) ; di solito si usano multipli di 10
	    (fire test-1)
	=>
	    (printout t "Rule test-1 firing." crlf)
	)

## Field Constraints
Vincoli definiti per il singolo campo usati per filtrare il pattern matching

• ~ not: il campo può prendere qualsiasi valore tranne quello specificato

`(name ~Simpson)`

`(age ~40)`

• | or: sono specificati valori alternativi ammissibili per uno stesso campo

`(name Simpson|Oswald)`

`(age 30|40|50)`

• & and: il valore del campo deve soddisfare una congiunzione di vincoli

`(name ?name&~Simpson)` equivalente al not Simspon di prima

`(name ?name&Harvey)`

• : expression: aggiungi l’espressione che segue come vincolo

`(age ?age&:(> ?age 20))`

`(name ?name&:(eq (sub-string 1 1 ?name) "S")`

## Connettivi logici

• or:
	(or (pattern1) (pattern2))
	    ;soddisfatta se almeno uno dei due pattern unifica con i fatti della WM
	    
	(defrule celebrate
	    (or (birthday) (anniversary))
	=>
	    (printout t "Let's have a party!" crlf))
	    
• not:
	(not (pattern))
	    ;soddisfatto quando nessun fatto unifica con il pattern
	    
	(defrule working-day
	    (not (birthday))
	    (not (anniversary))
	=>
	    (printout t "Let's work!" crlf))
	    
• exists:
	(exists (pattern))
	    ;soddisfatto per un unico fatto che unifica
	    
    	(defrule emergency-report
	    (exists
	        (or (emergency (emergency-type fire))
	        (emergency (emergency-type bomb)))
	    )
	=>
	    (printout t “There is an emergency.“ crlf )
	)
	
Se anche la WM contenesse entrambe le emergenze, la regola scatterebbe una volta sola

• forall:
	(forall (pattern))
	    ;soddisfatto se il pattern vale per tutti i fatti che unificano
	    
	(defrule evacuated-all-buildings
	    (forall (emergency (emergency-type fire | bomb)
	                       (location ?building) )
	            (evacuated (building ?building))
	    )
	=>
	    (printout t “All buildings with emergency are evacuated “ crlf))
	    
La regola scatta solo se per tutti i ?building dove è stata riscontrata una emergenza è anche stato dato l’ordine di evacuazione.

# Funzioni
• `(gensym)` restituisce un nuovo simbolo con forma genX dove X è un intero incrementato automaticamente ad ogni invocazione della funzione. Il primo simbolo generato è gen1. I simboli generati non sono necessariamente univoci

• `(gensym*)` è simile a gensym, ma con la garanzia che il simbolo generato è univoco

• `(setgen X)` imposta il valore iniziale del numero in coda al simbolo

• `(bind)` lega esplicitamente un valore ad una variabile, può essere usato nel conseguente delle regole. Esempi.

	(bind ?distance (+ f g))
	(bind ?new (gensym*))
	(assert (car (state-id ?new) (name ?name) (position MI)))
	
# Input/Output
`(open <file-name> <logical-name> "r")`
	
• <file-name> è il nome del file su disco
	
• <logical-name> è un nome usato all’interno del codice CLIPS
	
• ”r” indica il permesso di lettura (”w” per scrivere)

`(open "example.dat" my-file "r")`

`(read my-file)`

• Al termine il file deve essere chiuso: `(close <logical-name>)`

• read legge un solo simbolo

• readline legge un’intera riga terminata da CR

Struttura generale:

• (read <logical-name>) legge un solo token dal file
	
• (read) legge un solo token dal terminale (il file di default)

Esempi:

	(bind ?input (read))
	(bind ?$input (readline))
	
# Per stampare
The Printout Command

    (printout <logical-name> <print-items>*)

    (defrule fire-emergency
        (emergency (type fire))
     =>
        (printout t "action activate-sprinkler-system" crlf)
     )
# PROGETTO
```
Progetto di Intelligenza Artificiale e Laboratorio
Modulo: Planning e Sistemi a Regole
a.a. 2018-
```
```
Quest’anno ti mando in vacanza a...
```
L’obiettivo del progetto è quello di sviluppare un sistema esperto che, utilizzato da un’agenzia di
viaggi, suggerisca ai clienti pacchetti vacanze in modo tale da: (1) incontrare le esigenze dei clienti
stessi, e (2) consentire una equa distribuzione dei flussi turistici negli alberghi convenzionati.

L’agenzia ha contatti con diversi alberghi in diverse località turistiche. Più alberghi nella stessa
località sono possibili.
Non tutti gli alberghi sono per tutte le tasche, ci sono infatti alberghi da 1 a 4 stelle.
Indicativamente, una notte in un albergo da una stella costa 50 euro, mentre per ogni stella in più
occorre aggiungere 25 euro. (Per semplicità esistono solo camere doppie e il prezzo è il medesimo
che sia usata da una o due persone.)

Ogni località turistica è caratterizzata da un nome, una regione, e dal tipo di turismo, quest’ultimo
può essere uno o più tra i seguenti.
 Turismo Balneare
 Turismo Montano
 Turismo Lacustre
 Turismo Naturalistico
 Turismo Termale
 Turismo Culturale
 Turismo Religioso
 Turismo Sportivo
 Turismo Enogastronomico

Per ciascun tipo di turismo, una località ha un punteggio da 0 (n.a.) a 5 stelle.

Una visita turistica è rappresentata da un gruppo di una o più persone che occupano posti letto in
una località per un periodo di tempo di almeno una notte.

Il potenziale cliente si rivolge al vostro sistema esperto indicando che vuole fare un viaggio, ma non
avendo le idee chiare, la richiesta non necessariamente già contiene una meta precisa, la richiesta è
da considerarsi come un insieme di requisiti sul viaggio che il cliente vorrebbe fare. Ad esempio,
possibili richieste di suggerimento sono:

- R1) vorrei visitare tre luoghi al mare nell’arco di una settimana ma non vorrei spendere più
    di 500 euro per due persone.
    Per risolvere questo tipo di richiesta dovete:
    ◦ considerare la distanza tra i luoghi e stimare il tempo di spostamento.
    ◦ Il costo delle camere per notte e la disponibilità di camere negli alberghi


```
◦ NB: ho indicato tre luoghi in una settimana, ma potrebbero essere più/meno luoghi in un
diverso intervallo temporale. Anche il numero di persone è una variabile!
```
- R2) Come R1, ma con preferenze per mete dove l’aspetto enogastronomico e/o culturale sia
    rilevante
    ◦ Per risolvere questa richiesta dovete considerare le caratteristiche di ogni luogo. Poiché
       più alternative sono possibili, è consigliabile usare i certainty factors per calcolare e
       ordinare soluzioni alternative.
- R3) Il cliente potrebbe mettere vincoli sulla regionalità: solo luoghi di una data regione o
    nessun luogo in una data regione.
    ◦ anche qui, però, potreste suggerire soluzioni in cui una dei tre luoghi sia poco fuori la
       regione indicata. Ad esempio: la richiesta potrebbe essere tre luoghi in Liguria, ma tra le
       risposte potrebbe anche esserci la soluzione (Levanto, La Spezia, Massa) magari con un
       CF inferiore a (Rapallo, Sestri Levante, La Spezia).
- R4) Qualsiasi altro tipo di richiesta che potete immaginare (es. sul numero minimo/massimo
    di stelle degli alberghi).

E’ importante che l’utente inserisca la richiesta nel modo più libero possibile: cioè deve poter
indicare i suoi requisiti che saranno solo parziali e che quindi potranno non essere tali da
determinare una sola soluzione. Ma è proprio per questo che serve un sistema esperto.

Sottomessa la richiesta, il vostro sistema esperto dovrà produrre almeno due ma non più di cinque
alternative. Questo vuol dire che potreste dover scegliere di scartare alcune soluzioni. Ogni
alternativa indicherà quale luogo visitare, per quanto tempo, il costo del soggiorno e il CF.

A questo punto il cliente può ritenersi soddisfatto con la risposta, oppure può raffinare la sua
richiesta aggiungendo un ulteriore requisito. Il sistema quindi riparte a calcolare altre soluzioni, che
possono essere diverse dalle precedenti.

**Cosa ci deve essere nella vostra soluzione**

- Modellare il dominio: mete (e loro caratteristiche), alberghi, richieste, soluzioni, ecc.
- Organizzare il codice in moduli stabilendo un ciclo di esecuzione tra di essi.
- Scrivere le regole per il calcolo delle soluzioni. Queste regole devono:
    ◦ dimostrare che viene fatto un po’ di reasoning (nel senso che vengono vagliate più
       soluzioni, e alcune sono scartate)
    ◦ devono utilizzare della conoscenza empirica (di vostra fantasia, non entrerò nel merito
       delle vostre scelte), ad esempio: meglio proporre un viaggio con mete mono-tematiche
       (e.g., tutto mare), o meglio distribuire tra mete più variegate (e.g., mare e cultura,
       montagna e enogastronomia, e lago)? Ovviamente c’è il problema degli spostamenti. Per
       semplicità non vi chiedo di modellare esplicitamente gli spostamenti, ma di assumere
       che il cliente si sposta in auto e non è disposto a viaggiare per più di 100Km tra una
       meta e l’altra (ma un po’ di tolleranza data dai CF è ammessa).


```
◦ Le regole del vostro sistema esperto dovranno anche considerare che siete in accordo
con diversi alberghi, anche nella stessa località, e quindi dovreste suggerire gli alberghi
cercando di non avvantaggiare un albergo specifico proponendo sempre lo stesso.
◦ Dovete dimostrare le inferenze del vostro sistema esperto predisponendo uno o più
scenari (e.g., fatti iniziali e richieste) in modo opportuno. Non serve un database di 100
luoghi e 10 alberghi per luogo! Definite le mete e gli alberghi (con loro occupazione e
costi), che vi servono per dimostrare come il vostro sistema esperto prende una
decisione.
◦ Vi può tornare utile avere un profilo dell’utente in cui tracciate le sue preferenze rispetto
al tipo di turismo. I CF possono servire per rappresentare dei gradi di credenza sulle
preferenze del cliente.
```
- Dimostrate di avere fatto prove con scenari alternativi: richieste di tipo diverso, ma anche
    conoscenza più o meno completa delle preferenze del cliente (es., con i CF nell’intervallo [-
    1, 1] potete dire di non sapere se il cliente gradisce il turismo enogastronomico associando
    un CF pari a 0).

**Relazione**

E’ ovviamente prevista una relazione in cui descrivete tutte le scelte di progetto fondamentali.
Dovete ad esempio spiegare come avete distinto conoscenza di dominio da conoscenza di controllo,
e come avete usati i CF nella modellazione del problema. La relazione deve anche descrivere gli
scenari che avete investigato e trarre delle conclusioni sulla bontà e limiti della soluzione che
proponente.


