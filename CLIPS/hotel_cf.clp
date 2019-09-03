(defmodule HOTEL_CF (import RULES ?ALL) (import DATA ?ALL) (import QUESTIONS ?ALL) (export ?ALL)) ; import questions because of preferences

; assert hotel-cf
(defrule HOTEL_CF::hotel-cf-init
  (declare (salience 1000))
  (hotel (name ?name))
=>
  (assert (hotel-cf (name ?name) (CF -1.0)))
)

; duplicate fact for each preference becuse of clips problems loop
(defrule HOTEL_CF::hotel-cf-temp
  (declare (salience 100))
  (hotel-cf (name ?name) (CF -1.0))
  (preference (name ?pref)(value ?value))
=>
  (if (and (and (neq ?pref ok-region) (neq ?pref no-region))(and (neq ?pref money) (neq ?pref tourism))) then
    (assert (hotel-cf-temp (name ?name) (CF 0.0) (type ?pref))))
)

(defrule HOTEL_CF::hotel-cf-temp-t
  (declare (salience 100))
  (hotel-cf (name ?name) (CF -1.0))
  (preference (name tourism)(value ?value))
=>
  (assert (hotel-cf-temp (name ?name) (CF 0.0) (type ?value)))
)

; sets 5 if the region is ok else -5
(defrule HOTEL_CF::hotel-cf-temp-r
  (declare (salience 100))
  (hotel-cf (name ?name) (CF -1.0))
  (preference (name ?pref&ok-region|no-region)(value ?value))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (region ?value))
=>
  (if (eq ?pref ok-region) then
    (assert (hotel-cf-temp (name ?name) (CF 5.0) (type ?value)))
  else
    (assert (hotel-cf-temp (name ?name) (CF -5.0) (type ?value)))
  )
)

; sets 2.5 or -2.5 if the location dists less than 120km
(defrule HOTEL_CF::hotel-cf-temp-d
  (declare (salience 50))
  (hotel-cf-temp (name ?name) (CF ?CF&:(eq 5.0 (abs ?CF)))(type ?value))
  (hotel (name ?name)(location ?loc))
  (distance (name1 ?loc) (name2 ?loc2))
  (hotel (name ?name2&:(neq ?name ?name2)) (location ?loc2))
=>
  (printout t ?CF)
  (assert (hotel-cf-temp (name ?name2) (CF (/ ?CF 2)) (type ?value)))
)

; for each temp fact sets 1 if satisfiable
(defrule HOTEL_CF::hotel-cf-min
  (declare (salience 10))
  (preference (name min-star-number) (value ?preferred_stars))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type min-star-number))
  (hotel (name ?name) (stars ?stars&:(>= ?stars ?preferred_stars)))
=>
  (modify ?f (CF 1.0))
)

; for each temp fact sets 1 if satisfiable
(defrule HOTEL_CF::hotel-cf-max
  (declare (salience 10))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type max-star-number))
  (preference (name max-star-number) (value ?preferred_stars))
  (hotel (name ?name) (stars ?stars&:(<= ?stars ?preferred_stars)))
=>
  (modify ?f (CF 1.0))
)

; if variable as name selector for slots it could be rewritten with a single rule
; for each temp fact sets 0.2 per valutation if satisfiable
(defrule HOTEL_CF::hotel-cf-turism-balneare
  (declare (salience 10))
  (preference (name tourism) (value balneare))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type balneare))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (balneare ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel-cf-turism-montano
  (declare (salience 10))
  (preference (name tourism) (value montano))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type montano))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (montano ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)
                
(defrule HOTEL_CF::hotel-cf-turism-lacustre
  (declare (salience 10))
  (preference (name tourism) (value lacustre))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type lacustre))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (lacustre ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel-cf-turism-naturalistico
  (declare (salience 10))
  (preference (name tourism) (value naturalistico))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type naturalistico))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (naturalistico ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel-cf-turism-termale
  (declare (salience 10))
  (preference (name tourism) (value termale))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type termale))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (termale ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel-cf-turism-culturale
  (declare (salience 10))
  (preference (name tourism) (value culturale))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type culturale))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (culturale ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel-cf-turism-religioso
  (declare (salience 10))
  (preference (name tourism) (value religioso))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type religioso))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (religioso ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel-cf-turism-sportivo
  (declare (salience 10))
  (preference (name tourism) (value sportivo))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type sportivo))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (sportivo ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel-cf-turism-enogastronomico
  (declare (salience 10))
  (preference (name tourism) (value enogastronomico))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type enogastronomico))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (enogastronomico ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel-cf-people
  (declare (salience 10))
  ?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type people))
  (preference (name people) (value ?people))
  (hotel (name ?name) (free_rooms ?p&:(<= ?people ?p)))
=>
  (modify ?f (CF 1.0))
)

; calculation of cf
(defrule HOTEL_CF::hotel-cf-temp-remove
  (declare (salience 1))
  ?f <- (hotel-cf-temp (name ?name) (CF ?CF1) (type ?pref))
  ?g <- (hotel-cf (name ?name) (CF ?CF2))
=>
  (retract ?f)
  (printout t ?pref)
  (if (eq ?CF2 -1) then
  (bind ?CF2 0))
  (modify ?g (CF(+ ?CF1 ?CF2)))
  (printout t ?name)
  (printout t (+ ?CF1 ?CF2))
)