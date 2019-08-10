(defmodule QUESTIONS (import MAIN ?ALL) (export ?ALL))


;;**********************
;;* QUESTIONS TEMPLATE *
;;**********************

(deftemplate QUESTIONS::question
   (slot attribute (default ?NONE)) ; COSA è
   (slot the-question (default ?NONE))
   (multislot valid-answers (default nil))
   (slot already-asked (default FALSE)) ; avoid that a question is asked more than one time
)

(deftemplate MAIN::attribute ; SE NON SERVE TOGLIERLO, ALTRIMENTI SCRIVERE A COSA SERVE
   (slot name)
   (slot value)
   (slot certainty (default 100.0)))
 

;;*******************
;;* QUESTIONS RULES *
;;*******************

; handle tourism type
(defrule QUESTIONS::tourism-question
   ?f <- (question (already-asked FALSE)
                   (attribute tourism) ; SE NON SERVE SI POSSONO ACCORPARE ALCUNE DELLE REGOLE SOTTO
                   (the-question ?the-question)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-av ?the-question ?valid-answers))
   (while (not (eq ?answer unknown))
      (assert (attribute (name tourism)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                         (value ?answer)))
      (bind ?answer (ask-question-av ?the-question ?valid-answers))
   )
)

; handle ok region
(defrule QUESTIONS::ok-region-question
   ?f <- (question (already-asked FALSE)
                   (attribute ok-region)
                   (the-question ?the-question)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-av ?the-question ?valid-answers))
   (while (not (eq ?answer unknown))
      (assert (attribute (name ok-region)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                         (value ?answer)))
      (bind ?answer (ask-question-av ?the-question ?valid-answers))
   )
)

; handle region not liked
(defrule QUESTIONS::no-region-question
   ?f <- (question (already-asked FALSE)
                   (attribute no-region)
                   (the-question ?the-question)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-av ?the-question ?valid-answers))
   (while (not (eq ?answer unknown))
      (assert (attribute (name no-region)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                         (value ?answer)))
      (bind ?answer (ask-question-av ?the-question ?valid-answers))
   )
)

; handle how much the user wants to spend
(defrule QUESTIONS::money-question
   ?f <- (question (already-asked FALSE)
                   (attribute money)
                   (the-question ?the-question))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-int ?the-question))
   (if (not (eq ?answer unknown))
   then (assert (attribute (name money)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                           (value ?answer))))
)

; handle the minimum number of stars the user wants
(defrule QUESTIONS::min-star-number-question
   ?f <- (question (already-asked FALSE)
                   (attribute min-star-number)
                   (the-question ?the-question)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-av ?the-question ?valid-answers))
   (while (not (eq ?answer unknown))
      (assert (attribute (name min-star-number)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                         (value ?answer)))
      (bind ?answer (ask-question-av ?the-question ?valid-answers))
   )
)

; handle the maximum number of stars the user wants
(defrule QUESTIONS::max-star-number-question
   ?f <- (question (already-asked FALSE)
                   (attribute max-star-number)
                   (the-question ?the-question)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-av ?the-question ?valid-answers))
   (while (not (eq ?answer unknown))
      (assert (attribute (name max-star-number)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                         (value ?answer)))
      (bind ?answer (ask-question-av ?the-question ?valid-answers))
   )
)

; handle how many nights the user wants to spend in the hotels
(defrule QUESTIONS::night-question
   ?f <- (question (already-asked FALSE)
                   (attribute night)
                   (the-question ?the-question))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-int ?the-question))
   (if (not (eq ?answer unknown))
   then (assert (attribute (name night)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                           (value ?answer))))
)

; handle how many people will spend the nights in the hotels
(defrule QUESTIONS::people-question
   ?f <- (question (already-asked FALSE)
                   (attribute people)
                   (the-question ?the-question))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-int ?the-question))
   (if (not (eq ?answer unknown))
   then (assert (attribute (name people)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                           (value ?answer))))
)

;;**********************
;;* POSSIBLE QUESTIONS *
;;**********************

(deffacts QUESTIONS::question-attributes
  (question (attribute tourism) ; used in QUESTIONS RULES
            (the-question "Scegli quali tipologie di turismo preferisci (anche più d'uno) tra balneare, montano, lacustre, naturalistico, termale, culturale, religioso, sportivo, enogastronomico")
            (valid-answers balneare
                           montano
                           lacustre
                           naturalistico
                           termale
                           culturale
                           sportivo
                           enogastronomico
                           unknown))
  (question (attribute ok-region)
            (the-question "Vuoi visitare delle specifiche regioni italiane?")
            (valid-answers Piemonte
                           Aosta
                           Liguria
                           Lombardia
                           Trentino
                           Veneto
                           Friuli
                           Emilia-Romagna
                           Toscana
                           Umbria
                           Marche
                           Lazio
                           Abruzzo
                           Molise
                           Campania
                           Puglia
                           Basilicata
                           Calabria
                           Sicilia
                           Sardegna
                           unknown))
  (question (attribute no-region)
            (the-question "Ci sono delle specifiche regioni italiane che non vuoi visitare?")
            (valid-answers Piemonte
                           Aosta
                           Liguria
                           Lombardia
                           Trentino
                           Veneto
                           Friuli
                           Emilia-Romagna
                           Toscana
                           Umbria
                           Marche
                           Lazio
                           Abruzzo
                           Molise
                           Campania
                           Puglia
                           Basilicata
                           Calabria
                           Sicilia
                           Sardegna
                           unknown))
  (question (attribute money)
            (the-question "Quanto vuoi spendere per il tuo soggiorno?"))
  (question (attribute min-star-number)
            (the-question "Qual è il numero minimo di stelle che deve avere l'hotel in cui vuoi soggiornare?")
            (valid-answers 1 2 3 4))
  (question (attribute max-star-number)
            (the-question "Qual è il numero massimo di stelle che deve avere l'hotel in cui vuoi soggiornare?")
            (valid-answers 1 2 3 4))
  (question (attribute night)
            (the-question "Quante notti vuoi trascorrere in vacanza?"))
  (question (attribute people)
            (the-question "Quante persone sarete?"))
)