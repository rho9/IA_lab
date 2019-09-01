# TO DO
Importante: Un passo alla volta, altrimenti non passa più e non si capisce un cazzo.

- salvare le risposte all'interno di un fatto (creare template necessario)
- attraverso i cf fare una ricerca della soluzione

- implementare una ricerca che trovi una soluzione qualunque
- Da gestire: Una visita turistica è rappresentata da un gruppo di una o più persone che occupano posti letto in
una località per un periodo di tempo di almeno una notte.
- in rules non più di 100km tra una meta e l'altra (nei cf un po' di tolleranza è ammessa)
- Gestione preferenza su una località (aggiungere campo a località: sarà come un cf)

# Appunti
## main.clp
Gestisce il flusso di esecuzione (ha una salience molto alta per esssere sicuri che parta per primo).  

## questions.clp
Gestisce l'interazione con l'utente: le domande e le risposte possibili e asserisce i nuovi fatti.

# How to use
`(load l.clp)`
`(l)`
or
`./load.py` ma è un po' buggato [da sistemare]

# Testo Progetto
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