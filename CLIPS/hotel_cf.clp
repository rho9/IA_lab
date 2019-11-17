(defmodule HOTEL_CF (import RULES ?ALL) (import DATA ?ALL) (import QUESTIONS ?ALL) (export ?ALL)) ; import questions because of preferences

; - La percentuale di importanza delle varie feature per quanto riguarda i cf:
;   * Regione si (10)
;   * Regione no (10)
;   * Tipologia (10)
;   * Stelle min (5)
;   * Stelle max (5)
;   * Vicinanza regione (5)
;   * Distanza da hotel (5) ; la calcolo poi nella ricerca: sarebbe troppo oneroso farlo qua. la regione invece posso perchè è statica
;   * Soldi (20)
;   * Disponibilità camere (30)

; assert hotel_cf
(defrule HOTEL_CF::hotel_cf_init
  (declare (salience 1000))
  (hotel (name ?name))
=>
  (assert (hotel_cf (id (gensym*)) (name ?name) (CF -1.0)))
)

; duplicate fact for each preference because of clips problems loop
; (defrule HOTEL_CF::hotel_cf_temp
;   (declare (salience 100))
;   (hotel_cf (name ?name) (CF -1.0))
;   (preference (name ?pref)(value ?value))
; =>
;   (if (and (and (neq ?pref ok_region) (neq ?pref no_region))(and (neq ?pref money) (neq ?pref tourism))) then
;     (assert (hotel_cf_temp (name ?name) (CF 0.0) (type ?pref))))
; )

; handle CF for tourism
(defrule HOTEL_CF::hotel_cf_temp_t
  (declare (salience 100))
  (hotel_cf (name ?name) (CF -1.0))
  (preference (name tourism)(value ?value))
=>
  (assert (hotel_cf_temp (name ?name) (CF 0.0) (type ?value)))
  (assert (hotel_cf_temp (name ?name) (CF 0.1) (type normal_region)))
  (assert (hotel_cf_temp (name ?name) (CF 0.05) (type distance)))
  ; normal_region: regioni neutrale (nè da non visitare, nè da visitare)
)

; handle CF for number of empty room and staying people
(defrule HOTEL_CF::hotel_cf_temp_p
  (declare (salience 100))
  (hotel_cf (name ?name) (CF -1.0))
  (preference (name people)(value ?value))
  (hotel (name ?name) (stars ?s) (location ?l) (free_rooms ?fr&:(<= (/ ?value 2) ?fr)))
=>
  (assert (hotel_cf_temp (name ?name) (CF 0.3) (type ?value)))
)

; handle CF for ok/not ok region
(defrule HOTEL_CF::hotel_cf_temp_r
  (declare (salience 100))
  (hotel_cf (name ?name) (CF -1.0))
  (preference (name ?pref&ok_region|no_region)(value ?value))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (region ?value))
=>
  (if (eq ?pref ok_region) then
    (assert (hotel_cf_temp (name ?name) (CF 0.1) (type ?value)))
  else
    (assert (hotel_cf_temp (name ?name) (CF -0.1) (type ?value)))
  )
)

; handle CF for distance from ok region
(defrule HOTEL_CF::hotel_cf_temp_d
  (declare (salience 50))
  (preference (name ok_region)(value ?value))
  (location (name ?loc)(region ?value))
  (location (name ?loc2)(region ?value2&:(neq ?value ?value2)))
  (hotel (name ?name)(location ?loc))
  (distance (name1 ?loc) (name2 ?loc2))
  ; se le due località sono in distance, allora stanno a meno di 120 km l'una dall'altra
  (hotel (name ?name2&:(neq ?name ?name2)) (location ?loc2))
  ;(not (hotel_cf_temp (name ?name2) (CF 0.05) (type ?value)))
  ; per evitare che venga calcolato il cf per ogni regione (lo vogliamo fare una sola volta)
  ; commentato perché non si possono duplicare i fatti (controllare se funziona)
=>
  (assert (hotel_cf_temp (name ?name2) (CF 0.05) (type ?value)))
)

; handle CF for min star number
(defrule HOTEL_CF::hotel_cf_min
  (declare (salience 10))
  (preference (name min_star_number) (value ?preferred_stars))
  (hotel (name ?name) (stars ?stars&:(>= ?stars ?preferred_stars)))
=>
  (assert (hotel_cf_temp (name ?name) (CF 0.05) (type min_star_number)))
)

; handle CF for max star number
(defrule HOTEL_CF::hotel_cf_max
  (declare (salience 10))
  (preference (name max_star_number) (value ?preferred_stars))
  (hotel (name ?name) (stars ?stars&:(<= ?stars ?preferred_stars)))
=>
(assert (hotel_cf_temp (name ?name) (CF 0.05) (type max_star_number)))
)

; if variable as name selector for slots it could be rewritten with a single rule
; for each temp fact sets (/ (/ 10 45) 100) per valutation if satisfiable
(defrule HOTEL_CF::hotel_cf_turism_balneare
  (declare (salience 10))
  (preference (name tourism) (value balneare))
  ;?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type balneare))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (balneare ?v&:(> ?v 0.0)))
=>
  (bind ?num_pref (length$ (find-all-facts ((?f preference)) (eq ?f:name tourism))))
  (assert (hotel_cf_temp (name ?name) (CF (* (/ (/ 10 (* ?num_pref 5)) 100) ?v)) (type balneare)))

  ;(modify ?f (CF (* (/ (/ 10 45) 100) ?v)))
  ; 10% è l'importanza della tipologia. 
  ; / 10 45 normalizza il CF dividendo ogni tipologia per il numero di valori che gli si può assegnare
  ; / (/ 10 45) 100) fa sì che il CF stia tra 0 e 1
)

(defrule HOTEL_CF::hotel_cf_turism_montano
  (declare (salience 10))
  (preference (name tourism) (value montano))
  ;?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type montano))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (montano ?v&:(> ?v 0.0)))
=>
  (bind ?num_pref (length$ (find-all-facts ((?f preference)) (eq ?f:name tourism))))
  (assert (hotel_cf_temp (name ?name) (CF (* (/ (/ 10 (* ?num_pref 5)) 100) ?v)) (type montano)))
  ;(modify ?f (CF (* (/ (/ 10 45) 100) ?v)))
)
                
(defrule HOTEL_CF::hotel_cf_turism_lacustre
  (declare (salience 10))
  (preference (name tourism) (value lacustre))
  ;?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type lacustre))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (lacustre ?v&:(> ?v 0.0)))
=>
  (bind ?num_pref (length$ (find-all-facts ((?f preference)) (eq ?f:name tourism))))
  (assert (hotel_cf_temp (name ?name) (CF (* (/ (/ 10 (* ?num_pref 5)) 100) ?v)) (type lacustre)))
  ;(modify ?f (CF (* (/ (/ 10 45) 100) ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_naturalistico
  (declare (salience 10))
  (preference (name tourism) (value naturalistico))
  ;?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type naturalistico))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (naturalistico ?v&:(> ?v 0.0)))
=>
  (bind ?num_pref (length$ (find-all-facts ((?f preference)) (eq ?f:name tourism))))
  (assert (hotel_cf_temp (name ?name) (CF (* (/ (/ 10 (* ?num_pref 5)) 100) ?v)) (type naturalistico)))
  ;(modify ?f (CF (* (/ (/ 10 45) 100) ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_termale
  (declare (salience 10))
  (preference (name tourism) (value termale))
  ;?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type termale))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (termale ?v&:(> ?v 0.0)))
=>
  (bind ?num_pref (length$ (find-all-facts ((?f preference)) (eq ?f:name tourism))))
  (assert (hotel_cf_temp (name ?name) (CF (* (/ (/ 10 (* ?num_pref 5)) 100) ?v)) (type termale)))
  ;(modify ?f (CF (* (/ (/ 10 45) 100) ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_culturale
  (declare (salience 10))
  (preference (name tourism) (value culturale))
  ;?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type culturale))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (culturale ?v&:(> ?v 0.0)))
=>
  (bind ?num_pref (length$ (find-all-facts ((?f preference)) (eq ?f:name tourism))))
  (assert (hotel_cf_temp (name ?name) (CF (* (/ (/ 10 (* ?num_pref 5)) 100) ?v)) (type culturale)))
  ;(modify ?f (CF (* (/ (/ 10 45) 100) ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_religioso
  (declare (salience 10))
  (preference (name tourism) (value religioso))
  ;?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type religioso))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (religioso ?v&:(> ?v 0.0)))
=>
  (bind ?num_pref (length$ (find-all-facts ((?f preference)) (eq ?f:name tourism))))
  (assert (hotel_cf_temp (name ?name) (CF (* (/ (/ 10 (* ?num_pref 5)) 100) ?v)) (type religioso)))
  ;(modify ?f (CF (* (/ (/ 10 45) 100) ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_sportivo
  (declare (salience 10))
  (preference (name tourism) (value sportivo))
  ;?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type sportivo))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (sportivo ?v&:(> ?v 0.0)))
=>
  (bind ?num_pref (length$ (find-all-facts ((?f preference)) (eq ?f:name tourism))))
  (assert (hotel_cf_temp (name ?name) (CF (* (/ (/ 10 (* ?num_pref 5)) 100) ?v)) (type sportivo)))
  ;(modify ?f (CF (* (/ (/ 10 45) 100) ?v)))
)

(defrule HOTEL_CF::hotel_cf_turism_enogastronomico
  (declare (salience 10))
  (preference (name tourism) (value enogastronomico))
  ;?f <- (hotel_cf_temp (name ?name) (CF 0.0) (type enogastronomico))
  (hotel (name ?name)(location ?loc))
  (location (name ?loc) (enogastronomico ?v&:(> ?v 0.0)))
=>
  (bind ?num_pref (length$ (find-all-facts ((?f preference)) (eq ?f:name tourism))))
  (assert (hotel_cf_temp (name ?name) (CF (* (/ (/ 10 (* ?num_pref 5)) 100) ?v)) (type enogastronomico)))
  ;(modify ?f (CF (* (/ (/ 10 45) 100) ?v)))
)

; calculation of cf
(defrule HOTEL_CF::hotel_cf_temp_remove
  (declare (salience 1))
  ?f <- (hotel_cf_temp (name ?name) (CF ?CF1) (type ?pref))
  ?g <- (hotel_cf (name ?name) (CF ?CF2))
=>
  (retract ?f)
  ;(printout t ?pref) ; prints used for debugging purposes
  (if (eq ?CF2 -1.0) then
  (bind ?CF2 0))
  (modify ?g (CF(+ ?CF1 ?CF2)))
  ; (printout t ?name)
  ; (printout t (+ ?CF1 ?CF2) crlf)
  ; (printout t ?CF1 crlf)
  ; (printout t ?CF2 crlf crlf)
)

;rule used to print the facts and debug
(defrule HOTEL_CF_facts
  (declare (salience 0))
  (fale)
  =>
  (facts)
)
