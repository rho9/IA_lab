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

; una per ogni domanda -> modificare e moltiplicare
(defrule QUESTIONS::ask-a-question
   ?f <- (question (already-asked FALSE)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question-string ?the-question ?valid-answers))))
)


;;**********************
;;* POSSIBLE QUESTIONS *
;;**********************

(deffacts QUESTIONS::question-attributes
  (question (attribute main-component) ; CAPIRE E MODIFICARE DI CONSEGUENZA
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
)