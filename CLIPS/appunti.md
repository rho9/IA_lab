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