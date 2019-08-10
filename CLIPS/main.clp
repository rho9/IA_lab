(defmodule MAIN (export ?ALL))

; interacts with user when an allowed values is required (it handles both integer and strings values)
(deffunction MAIN::ask-question-av (?question ?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   ; lexemep check if the variable is a string or a symbol
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t "Inserire un valore tra quelli validi")
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)

; interacts with user when an integer without allowed values is required
(deffunction MAIN::ask-question-int (?question)
   (printout t ?question)
   (bind ?answer (read))
   ; lexemep check if the variable is a string or a symbol
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))) ; usefull for "unknown"
   (while (or (not (integerp ?answer)) (>= 0 ?answer)) do ; -3 è stringa O INTERO????
      (printout t "Inserire un numero intero postivo")
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)


(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication TRUE) ; QUANDO VIENE USATO????
  (focus QUESTIONS CHOOSE-QUALITIES WINES PRINT-RESULTS)
)

