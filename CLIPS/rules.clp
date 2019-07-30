(defmodule RULES (import DATA ?ALL) (export ?ALL))


(defrule cal_cost
  (hotel (name ?name)(stars ?x))
=>
  (assert (cost ?name (+ 50 (* (- ?x 1) 25))))
  (printout "ciao" crlf)
)