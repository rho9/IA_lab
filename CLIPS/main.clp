(defmodule MAIN (export ?ALL))

(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication FALSE) ; QUANDO VIENE USATO????
  (focus DATA RULES QUESTIONS HOTEL_CF)
)

