(defmodule SEARCH (import HOTEL_CF ?ALL) (export ?ALL))

(defrule SEARCH::init_search
    (declare (salience 1000))
=>
    (assert (bests(ids (create$))))
)

(defrule SEARCH::best5
    (hotel_cf (name ?name) (CF ?CF))
    (bests (ids $?ids&:(member ?id&:(member ))))
=>
    (if (< (length$ $?ids) 5) then (insert$ $?ids ?name))
)