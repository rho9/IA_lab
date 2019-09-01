(defmodule HOTEL_CF (import DATA ?ALL) (import QUESTIONS ?ALL) (export ?ALL)) ; import questions beause of preferences

; assert hotel-cf
(defrule HOTEL_CF::hotel-cf-init
  (declare (salience 1000))
  (hotel (name ?name))
=>
  (assert (hotel-cf (name ?name) (CF -1)))
)


; duplicate fact for each preference becuse of clips problems loop
(defrule HOTEL_CF::hotel-cf-temp
  (declare (salience 100))
  (hotel-cf (name ?name) (CF -1))
  (preference (name ?pref))
=>
  (assert (hotel-cf-temp (name ?name) (CF 0) (type ?pref)))
)

; for each temp fact sets 1 if satisfiable
(defrule HOTEL_CF::hotel-cf-min
  (declare (salience 10))
  (preference (name min-star-number) (value ?preferred_stars))
  ?f <- (hotel-cf-temp (name ?name) (CF 0) (type min-star-number))
  (hotel (name ?name) (stars ?stars&:(>= ?stars ?preferred_stars)))
=>
  (modify ?f (CF 1))
)

; for each temp fact sets 1 if satisfiable
(defrule HOTEL_CF::hotel-cf-max
  (declare (salience 10))
  ?f <- (hotel-cf-temp (name ?name) (CF 0) (type max-star-number))
  (preference (name max-star-number) (value ?preferred_stars))
  (hotel (name ?name) (stars ?stars&:(<= ?stars ?preferred_stars)))
=>
  (modify ?f (CF 1))
)

; calculation of cf
(defrule HOTEL_CF::hotel-cf-temp-remove
  (declare (salience 1))
  (preference (name ?pref))
  ?f <- (hotel-cf-temp (name ?name) (CF ?CF1) (type ?pref))
  ?g <- (hotel-cf (name ?name) (CF ?CF2))
=>
  (retract ?f)
  (if (eq ?CF2 -1) then (bind ?CF2 0))
  (modify ?g (CF(+ ?CF1 ?CF2)))
)