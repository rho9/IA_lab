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
                   (attribute tourism)
                   (the-question ?the-question)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-string ?the-question ?valid-answers))
   (while (not (eq ?answer unknown))
      (assert (attribute (name tourism)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                         (value ?answer)))
      (bind ?answer (ask-question-string ?the-question ?valid-answers))
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
   (bind ?answer (ask-question-string ?the-question ?valid-answers))
   (while (not (eq ?answer unknown))
      (assert (attribute (name ok-region)  ; LASCIARE ATTRIBUTE O METTERE QUALCOSA DI PIù EVOCATIVO? + LA CERTAINTY VA GESTITA GIà QUA?????
                         (value ?answer)))
      (bind ?answer (ask-question-string ?the-question ?valid-answers))
   )
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
  (question (attribute main-component) ; CAPIRE E MODIFICARE DI CONSEGUENZA
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
  (question (attribute main-component) ; CAPIRE E MODIFICARE DI CONSEGUENZA
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
  (question (attribute main-component) ; CAPIRE E MODIFICARE DI CONSEGUENZA
            (the-question "Quanto vuoi spendere per il tuo soggiorno?"))
  (question (attribute main-component) ; CAPIRE E MODIFICARE DI CONSEGUENZA
            (the-question "Qual è il numero minimo di stelle che deve avere l'hotel in cui vuoi soggiornare?")
            (valid-answers 1 2 3 4))
  (question (attribute main-component) ; CAPIRE E MODIFICARE DI CONSEGUENZA
            (the-question "Qual è il numero massimo di stelle che deve avere l'hotel in cui vuoi soggiornare?")
            (valid-answers 1 2 3 4))
  (question (attribute main-component) ; CAPIRE E MODIFICARE DI CONSEGUENZA
            (the-question "Quante notti vuoi trascorrere in vacanza?"))
  (question (attribute main-component) ; CAPIRE E MODIFICARE DI CONSEGUENZA
            (the-question "Quante persone sarete?"))
)