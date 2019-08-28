(defmodule MAIN (export ?ALL))

(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication TRUE) ; QUANDO VIENE USATO????
  (focus QUESTIONS)
)

