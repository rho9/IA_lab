(defmodule HOTEL_CF (import DATA ?ALL) (import QUESTIONS ?ALL) (export ?ALL)) ; import questions beause of preferences

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

(defrule HOTEL_CF::hotel-cf-temp-r
  (declare (salience 100))
  (hotel-cf (name ?name) (CF -1.0))
  (preference (name ok-region|no-region)(value ?value))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (region ?value))
=>
  (assert (hotel-cf-temp (name ?name) (CF 0.0) (type ?value)))
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

(defrule HOTEL_CF::hotel-cf-okregion-piemonte
	(declare (salience 10))
	(preference (name ok-region) (value piemonte))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type piemonte))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region piemonte))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-valle-aosta
	(declare (salience 10))
	(preference (name ok-region) (value valle-aosta))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type valle-aosta))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region valle-aosta))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-liguria
	(declare (salience 10))
	(preference (name ok-region) (value liguria))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type liguria))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region liguria))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-lombardia
	(declare (salience 10))
	(preference (name ok-region) (value lombardia))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type lombardia))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region lombardia))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-trentino
	(declare (salience 10))
	(preference (name ok-region) (value trentino))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type trentino))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region trentino))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-veneto
	(declare (salience 10))
	(preference (name ok-region) (value veneto))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type veneto))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region veneto))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-friuli
	(declare (salience 10))
	(preference (name ok-region) (value friuli))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type friuli))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region friuli))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-emilia-romagna
	(declare (salience 10))
	(preference (name ok-region) (value emilia-romagna))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type emilia-romagna))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region emilia-romagna))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-toscana
	(declare (salience 10))
	(preference (name ok-region) (value toscana))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type toscana))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region toscana))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-umbria
	(declare (salience 10))
	(preference (name ok-region) (value umbria))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type umbria))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region umbria))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-marche
	(declare (salience 10))
	(preference (name ok-region) (value marche))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type marche))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region marche))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-lazio
	(declare (salience 10))
	(preference (name ok-region) (value lazio))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type lazio))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region lazio))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-abruzzo
	(declare (salience 10))
	(preference (name ok-region) (value abruzzo))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type abruzzo))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region abruzzo))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-molise
	(declare (salience 10))
	(preference (name ok-region) (value molise))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type molise))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region molise))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-campania
	(declare (salience 10))
	(preference (name ok-region) (value campania))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type campania))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region campania))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-puglia
	(declare (salience 10))
	(preference (name ok-region) (value puglia))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type puglia))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region puglia))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-basilicata
	(declare (salience 10))
	(preference (name ok-region) (value basilicata))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type basilicata))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region basilicata))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-calabria
	(declare (salience 10))
	(preference (name ok-region) (value calabria))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type calabria))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region calabria))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-sicilia
	(declare (salience 10))
	(preference (name ok-region) (value sicilia))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type sicilia))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region sicilia))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-okregion-sardegna
	(declare (salience 10))
	(preference (name ok-region) (value sardegna))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type sardegna))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region sardegna))
=>
	(modify ?f (CF 5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-piemonte
	(declare (salience 10))
	(preference (name no-region) (value piemonte))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type piemonte))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region piemonte))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-valle-aosta
	(declare (salience 10))
	(preference (name no-region) (value valle-aosta))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type valle-aosta))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region valle-aosta))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-liguria
	(declare (salience 10))
	(preference (name no-region) (value liguria))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type liguria))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region liguria))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-lombardia
	(declare (salience 10))
	(preference (name no-region) (value lombardia))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type lombardia))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region lombardia))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-trentino
	(declare (salience 10))
	(preference (name no-region) (value trentino))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type trentino))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region trentino))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-veneto
	(declare (salience 10))
	(preference (name no-region) (value veneto))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type veneto))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region veneto))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-friuli
	(declare (salience 10))
	(preference (name no-region) (value friuli))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type friuli))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region friuli))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-emilia-romagna
	(declare (salience 10))
	(preference (name no-region) (value emilia-romagna))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type emilia-romagna))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region emilia-romagna))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-toscana
	(declare (salience 10))
	(preference (name no-region) (value toscana))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type toscana))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region toscana))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-umbria
	(declare (salience 10))
	(preference (name no-region) (value umbria))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type umbria))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region umbria))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-marche
	(declare (salience 10))
	(preference (name no-region) (value marche))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type marche))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region marche))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-lazio
	(declare (salience 10))
	(preference (name no-region) (value lazio))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type lazio))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region lazio))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-abruzzo
	(declare (salience 10))
	(preference (name no-region) (value abruzzo))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type abruzzo))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region abruzzo))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-molise
	(declare (salience 10))
	(preference (name no-region) (value molise))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type molise))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region molise))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-campania
	(declare (salience 10))
	(preference (name no-region) (value campania))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type campania))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region campania))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-puglia
	(declare (salience 10))
	(preference (name no-region) (value puglia))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type puglia))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region puglia))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-basilicata
	(declare (salience 10))
	(preference (name no-region) (value basilicata))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type basilicata))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region basilicata))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-calabria
	(declare (salience 10))
	(preference (name no-region) (value calabria))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type calabria))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region calabria))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-sicilia
	(declare (salience 10))
	(preference (name no-region) (value sicilia))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type sicilia))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc) (region sicilia))
=>
	(modify ?f (CF -5.0))
)

(defrule HOTEL_CF::hotel-cf-noregion-sardegna
	(declare (salience 10))
	(preference (name no-region) (value sardegna))
	?f <- (hotel-cf-temp (name ?name) (CF 0.0) (type sardegna))
	(hotel (name ?name)(location ?loc))
	(location (name ?loc)(region sardegna))
=>
	(modify ?f (CF -5.0))
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