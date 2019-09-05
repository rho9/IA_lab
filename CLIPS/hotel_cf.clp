(defmodule HOTEL_CF (import RULES ?ALL) (import DATA ?ALL) (import QUESTIONS ?ALL) (export ?ALL)) ; import questions because of preferences

; assert hotel_cf
(defrule HOTEL_CF::hotel_cf_init
  (declare (salience 1000))
  (hotel (name ?name))
=>
  (assert (hotel_cf (name ?name) (CF -1.0)))
)

; duplicate fact for each preference becuse of clips problems loop
(defrule HOTEL_CF::hotel_cf_temp
  (declare (salience 100))
  (hotel_cf (name ?name) (CF -1.0))
  (preference (name ?pref)(value ?value))
=>
  (if (and (and (neq ?pref ok_region) (neq ?pref no_region))(and (neq ?pref money) (neq ?pref tourism))) then
    (assert (hotel_cf_temp (name ?name) (CF 0.0) (type ?pref))))
)

(defrule HOTEL_CF::hotel_cf_temp_t
  (declare (salience 100))
  (hotel_cf (name ?name) (CF -1.0))
  (preference (name tourism)(value ?value))
=>
  (assert (hotel_cf_temp (name ?name) (CF 0.0) (type ?value)))
)

(defrule HOTEL_CF::hotel_cf_temp_p
  (declare (salience 100))
  (hotel_cf (name ?name) (CF -1.0))
  (preference (name people)(value ?value))
  (hotel (name ?name) (stars ?s) (location ?l) (free_rooms ?fr))
=>
  (if (> (/ people 2) ?fr) then
    (assert (hotel_cf_temp (name ?name) (CF -50.0) (type ?value)))
  else
    (assert (hotel_cf_temp (name ?name) (CF 0.0) (type ?value)))
  )
)

; sets 5 if the region is ok else -5
(defrule HOTEL_CF::hotel_cf_temp_r
  (declare (salience 100))
  (hotel_cf (name ?name) (CF -1.0))
  (preference (name ?pref&ok_region|no_region)(value ?value))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (region ?value))
=>
  (if (eq ?pref ok_region) then
    (assert (hotel_cf_temp (name ?name) (CF 5.0) (type ?value)))
  else
    (assert (hotel_cf_temp (name ?name) (CF -5.0) (type ?value)))
  )
)

; sets 2.5 or -2.5 if the location dists less than 120km
(defrule HOTEL_CF::hotel_cf_temp_d
  (declare (salience 50))
  (hotel_cf_temp (name ?name) (CF ?CF&:(eq 5.0 ?CF))(type ?value))
  (hotel (name ?name)(location ?loc))
  (distance (name1 ?loc) (name2 ?loc2))
  (hotel (name ?name2&:(neq ?name ?name2)) (location ?loc2))
=>
  (assert (hotel_cf_temp (name ?name2) (CF (/ ?CF 2)) (type ?value)))
)

; for each temp fact sets 1 if satisfiable
(defrule HOTEL_CF::hotel_cf_min
  (declare (salience 10))
  (preference (name min_star_number) (value ?preferred_stars))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type min_star_number))
  (hotel (name ?name) (stars ?stars&:(>= ?stars ?preferred_stars)))
=>
  (modify ?f (CF 1.0))
)

; for each temp fact sets 1 if satisfiable
(defrule HOTEL_CF::hotel_cf_max
  (declare (salience 10))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type max_star_number))
  (preference (name max_star_number) (value ?preferred_stars))
  (hotel (name ?name) (stars ?stars&:(<= ?stars ?preferred_stars)))
=>
  (modify ?f (CF 1.0))
)

; if variable as name selector for slots it could be rewritten with a single rule
; for each temp fact sets 0.2 per valutation if satisfiable
(defrule HOTEL_CF::hotel_cf_turism_balneare
  (declare (salience 10))
  (preference (name tourism) (value balneare))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type balneare))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (balneare ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_montano
  (declare (salience 10))
  (preference (name tourism) (value montano))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type montano))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (montano ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)
                
(defrule HOTEL_CF::hotel_cf_turism_lacustre
  (declare (salience 10))
  (preference (name tourism) (value lacustre))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type lacustre))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (lacustre ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_naturalistico
  (declare (salience 10))
  (preference (name tourism) (value naturalistico))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type naturalistico))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (naturalistico ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_termale
  (declare (salience 10))
  (preference (name tourism) (value termale))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type termale))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (termale ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_culturale
  (declare (salience 10))
  (preference (name tourism) (value culturale))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type culturale))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (culturale ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_religioso
  (declare (salience 10))
  (preference (name tourism) (value religioso))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type religioso))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (religioso ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_sportivo
  (declare (salience 10))
  (preference (name tourism) (value sportivo))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type sportivo))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (sportivo ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_enogastronomico
  (declare (salience 10))
  (preference (name tourism) (value enogastronomico))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type enogastronomico))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (enogastronomico ?v&:(> ?v 0.0)))
=>
  (modify ?f (CF (* 0.2 ?v)))
)

(defrule HOTEL_CF::hotel_cf_people
  (declare (salience 10))
  ?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type people))
  (preference (name people) (value ?people))
  (hotel (name ?name) (free_rooms ?p&:(<= ?people ?p)))
=>
  (modify ?f (CF 1.0))
)

; calculation of cf
(defrule HOTEL_CF::hotel_cf_temp_remove
  (declare (salience 1))
  ?f <- (hotel_cf_temp (name ?name) (CF ?CF1) (type ?pref))
  ?g <- (hotel_cf (name ?name) (CF ?CF2))
=>
  (retract ?f)
  ;(printout t ?pref)
  (if (eq ?CF2 -1) then
  (bind ?CF2 0))
  (modify ?g (CF(+ ?CF1 ?CF2)))
  ;(printout t ?name)
  ;(printout t (+ ?CF1 ?CF2))
)