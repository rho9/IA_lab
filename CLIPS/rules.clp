(defmodule RULES (import DATA ?ALL) (export ?ALL))

; computes cost of hotel knowing his stars
(defrule RULES::cal_cost
  (hotel (name ?name)(stars ?x))
=>
  (assert (cost ?name (+ 50 (* (- ?x 1) 25))))
)

; computes distances between two locations
(defrule RULES::cal_distance
  (declare (salience 1000))
  (position (name ?name1)(latitude ?lat1)(longitude ?lon1))
  (position (name ?name2)(latitude ?lat2)(longitude ?lon2))
=>
  (if (neq ?name1 ?name2) then
    (bind ?earthRadius 6371)
    (bind ?dlat (- ?lat2 ?lat1))
    (bind ?dlon (- ?lon2 ?lon1))
    (bind ?rlat1 (/ (* ?lat1 (pi)) 180))
    (bind ?rlat2 (/ (* ?lat2 (pi)) 180))
    (bind ?rdlat (/ (* ?dlat (pi)) 180))
    (bind ?rdlon (/ (* ?dlon (pi)) 180))
    ;studio segno atan https://it.wikipedia.org/wiki/Arcotangente2
    (bind ?a (+ (** (sin (/ ?rdlat 2)) 2) (* (* (** (sin (/ ?rdlon 2)) 2) (cos ?rlat1))(cos ?rlat2))))
    (bind ?c (* (atan (/ (sqrt ?a) (sqrt (- 1 ?a)))) 2))
    (bind ?distance (* ?earthRadius ?c))
    (bind ?max_distance 100)
    (bind ?delta 20) ;approximation of 20 km
    (if (<= ?distance (+ ?max_distance ?delta)) then
      (assert (distance (name1 ?name1) (name2 ?name2) (dist ?distance)))
    )
  )
)

(defrule RULES::clean_positions
  (declare (salience 100))
  ?f <- (position (name ?name))
=>
  (retract ?f)
)
  

;condizione per rendere accettabile la proposta
;(defrule RULES::hotel_cf_money
;  ?f <- (hotel_cf ?name ?CF)
;  (preference money ?money)
;  (cost ?name :(<= ?cost ?money))
;=>
;  (modify ?f (CF (+ ?CF 1)))
;)
