# Tipi primitivi
• float

• integer

• symbol: e.g. this-is-a-symbol, wrzlbrmft, !?@*+

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

# Avvio e terminazione
• Avvio da riga di comando (UNIX): `./clips`

• Terminare: `(exit)`

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

## Manipolaizone dei fatti
• aggiungere fatti: `(assert <fact>+)`

• rimuovere fatti: `(retract <fact-index>+)`

• modificare fatti: `(modify <fact-index> (<slot-name> <slot-value>)+ )`.
  Equivale a rimuovere il fatto originale e aggiungere il nuovo fatto modificato con un indice incrementato
  
• duplicare fatti: `(duplicate <fact-index> (<slot-name> <slot-value>)+ )`

• ispezionare la working memory:
	`(facts)` stampa (elenca) la lista dei fatti
	`(watch facts)` mostra automaticamente i cambiamenti che occorrono nella WM a seguito dell’esecuzione delle regole
  
• `(unwatch facts)` per disabilitare il watching sui fatti

• ottenre l'indice del fatto: `(assert(fatto))`

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

Ispezionare e tracciare

• (rules) elenca le regole definite fino a questo momento nella KB

• (ppdefrule nome-regola) mostra la definizione della regola

• (agenda) mostra l’agenda attuale: elenco ordinato di regole attivabili. La regola in cima sarà la prossima ad essere eseguita (per ogni regola sono indicati i fatti che l’attivano, cioè le precondizioni)

• (watch rules) mostra, durante l’esecuzione, quali regole sono eseguite

• (watch activations) mostra, durante l’esecuzione, quali attivazioni hanno permesso l’esecuzione delle regole

• (unwatch rules) e (unwatch activations) per disattivare il watching

# Debugging
Salvare tutto ciò che viene visualizzato sul terminale sul file indicato, compreso gli input dell’utente.: (dribble-on filename)
Disabilitare il comando: (dribble-off)

Breackpoints:
(set-break <rulename>)
(remove-break <rulename>)
(show-breaks)
Così dopo la run l'esecuzione va avanti finché non arriva alla regola che hai inserito
