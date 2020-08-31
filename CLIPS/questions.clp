(defmodule QUESTIONS (import MAIN ?ALL)(import TEMPLATES ?ALL) (export ?ALL))

;;*******************
;;* QUESTIONS FUNCTIONS *
;;*******************

 ; interacts with user when an allowed values is required (it handles both integer and strings values)
(deffunction MAIN::ask_question_av (?question ?allowed_values)
   (printout t ?question)
   (bind ?answer (read))
   ; lexemep check if the variable is a string or a symbol
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed_values)) do
      (printout t "Inserire un valore tra quelli validi ")
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)

; interacts with user when an integer without allowed values is required
(deffunction MAIN::ask_question_int (?question)
   (printout t ?question)
   (bind ?answer (read))
   ; lexemep check if the variable is a string or a symbol
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))) ; usefull for "s"
   (while (or (not (integerp ?answer)) (<= ?answer 0)) do ; or is lazy, if the first cond is true does not verify the second
      (printout t "Inserire un numero intero postivo ")
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)

;;*******************
;;* QUESTIONS RULES *
;;*******************

; handle multiple choose type
(defrule QUESTIONS::multiple_choose_question
   ?f <- (question (already_asked FALSE)
                   (preference ?type&tourism|ok_region|no_region)
                   (the_question ?the_question)
                   (valid_answers $?valid_answers))
   
   =>
   (modify ?f (already_asked TRUE))
   (bind ?answer (ask_question_av ?the_question ?valid_answers))
   (while (neq ?answer s)
      (assert (preference (name ?type)
                         (value ?answer)))
      (bind ?answer (ask_question_av ?the_question ?valid_answers))
   )
)

; handle integer question
(defrule QUESTIONS::integer_question
   ?f <- (question (already_asked FALSE)
                   (preference ?type&money|people|locality_number)
                   (the_question ?the_question))
   =>
   (modify ?f (already_asked TRUE))
   (bind ?answer (ask_question_int ?the_question))
   (while (or (not (integerp ?answer)) (not (> ?answer 0)))
      (bind ?answer (ask_question_int ?the_question)))
   (assert (preference (name ?type) (value ?answer)))
)

; handle choose question
(defrule QUESTIONS::choose_question
   ?f <- (question (already_asked FALSE)
                   (preference ?type&min_star_number|max_star_number)
                   (the_question ?the_question)
                   (valid_answers $?valid_answers))
   =>
   (modify ?f (already_asked TRUE))
   (bind ?answer (ask_question_av ?the_question ?valid_answers))
   (if (neq ?answer s) then
      (assert (preference (name ?type)  
                         (value ?answer)))
   )
)


;;**********************
;;* POSSIBLE QUESTIONS *
;;**********************

(deffacts QUESTIONS::question_preferences
  (question (preference tourism) ; used in QUESTIONS RULES
            (the_question "Quali tipologie di turismo preferisci? (tra: balneare, montano, lacustre, naturalistico, termale, culturale, religioso, sportivo, enogastronomico): ")
            (valid_answers balneare
                           montano
                           lacustre
                           naturalistico
                           termale
                           culturale
                           religioso
                           sportivo
                           enogastronomico
                           s))
  (question (preference ok_region)
            (the_question "Quali regioni italiane vuoi visitare? ")
            (valid_answers piemonte
                           valle_aosta
                           liguria
                           lombardia
                           trentino
                           veneto
                           friuli
                           emilia_romagna
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
                           s))
  (question (preference no_region)
            (the_question "Quali regioni italiane NON vuoi visitare? ")
            (valid_answers piemonte
                           valle_aosta
                           liguria
                           lombardia
                           trentino
                           veneto
                           friuli
                           emilia_romagna
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
                           s))
  (question (preference locality_number)
            (the_question "Quante località vorresti visitare? "))
  (question (preference money)
            (the_question "Quanto vuoi spendere per il tuo soggiorno? "))
  (question (preference min_star_number)
            (the_question "Qual è il numero minimo di stelle che deve avere l'hotel in cui vuoi soggiornare? ")
            (valid_answers 1 2 3 4 s))
  (question (preference max_star_number)
            (the_question "Qual è il numero massimo di stelle che deve avere l'hotel in cui vuoi soggiornare? ")
            (valid_answers 1 2 3 4 s))
  (question (preference night)
            (the_question "Quante notti vuoi trascorrere in vacanza? "))
  (question (preference people)
            (the_question "Quante persone sarete? "))
)