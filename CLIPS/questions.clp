(defmodule QUESTIONS (import MAIN ?ALL)(import TEMPLATES ?ALL) (export ?ALL))

;;*******************
;;* QUESTIONS FUNCTIONS *
;;*******************

 ; interacts with user when an allowed values is required (it handles both integer and strings values)
(deffunction MAIN::ask-question-av (?question ?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   ; lexemep check if the variable is a string or a symbol
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t "Inserire un valore tra quelli validi ")
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)

; interacts with user when an integer without allowed values is required
(deffunction MAIN::ask-question-int (?question)
   (printout t ?question)
   (bind ?answer (read))
   ; lexemep check if the variable is a string or a symbol
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))) ; usefull for "stop"
   (while (or (not (integerp ?answer)) (<= ?answer 0)) do ; or is lazy, if the first cond is true does not verify the second
      (printout t "Inserire un numero intero postivo ")
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)

;;*******************
;;* QUESTIONS RULES *
;;*******************

; handle multiple choose type
(defrule QUESTIONS::multiple-choose-question
   ?f <- (question (already-asked FALSE)
                   (preference ?type&tourism|ok-region|no-region)
                   (the-question ?the-question)
                   (valid-answers $?valid-answers))
   
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-av ?the-question ?valid-answers))
   (while (neq ?answer stop)
      (assert (preference (name ?type)
                         (value ?answer)))
      (bind ?answer (ask-question-av ?the-question ?valid-answers))
   )
)

; handle integer question
(defrule QUESTIONS::integer-question
   ?f <- (question (already-asked FALSE)
                   (preference ?type&money|people)
                   (the-question ?the-question))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-int ?the-question))
   (if (neq ?answer stop) then (assert (preference (name ?type) 
                           (value ?answer))))
)

; handle choose question
(defrule QUESTIONS::choose-question
   ?f <- (question (already-asked FALSE)
                   (preference ?type&min-star-number|max-star-number)
                   (the-question ?the-question)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (bind ?answer (ask-question-av ?the-question ?valid-answers))
   (if (neq ?answer stop) then
      (assert (preference (name ?type)  
                         (value ?answer)))
   )
)


;;**********************
;;* POSSIBLE QUESTIONS *
;;**********************

(deffacts QUESTIONS::question-preferences
  (question (preference tourism) ; used in QUESTIONS RULES
            (the-question "Quali tipologie di turismo preferisci? (tra: balneare, montano, lacustre, naturalistico, termale, culturale, religioso, sportivo, enogastronomico): ")
            (valid-answers balneare
                           montano
                           lacustre
                           naturalistico
                           termale
                           culturale
                           religioso
                           sportivo
                           enogastronomico
                           stop))
  (question (preference ok-region)
            (the-question "Quali regioni italiane vuoi visitare? ")
            (valid-answers piemonte
                           valle-aosta
                           liguria
                           lombardia
                           trentino
                           veneto
                           friuli
                           emilia-romagna
                           toscana
                           umbria
                           marche
                           lazio
                           abruzzo
                           molise
                           campania
                           puglia
                           basilicata
                           calabria
                           sicilia
                           sardegna
                           stop))
  (question (preference no-region)
            (the-question "Quali regioni italiane NON vuoi visitare? ")
            (valid-answers piemonte
                           valle-aosta
                           liguria
                           lombardia
                           trentino
                           veneto
                           friuli
                           emilia-romagna
                           toscana
                           umbria
                           marche
                           lazio
                           abruzzo
                           molise
                           campania
                           puglia
                           basilicata
                           calabria
                           sicilia
                           sardegna
                           stop))
  (question (preference money)
            (the-question "Quanto vuoi spendere per il tuo soggiorno? "))
  (question (preference min-star-number)
            (the-question "Qual è il numero minimo di stelle che deve avere l'hotel in cui vuoi soggiornare? ")
            (valid-answers 1 2 3 4 stop))
  (question (preference max-star-number)
            (the-question "Qual è il numero massimo di stelle che deve avere l'hotel in cui vuoi soggiornare? ")
            (valid-answers 1 2 3 4 stop))
  (question (preference night)
            (the-question "Quante notti vuoi trascorrere in vacanza? "))
  (question (preference people)
            (the-question "Quante persone sarete? "))
)