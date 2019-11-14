(defmodule SEARCH (import HOTEL_CF ?ALL) (import RULES ?ALL) (import DATA ?ALL) (import QUESTIONS ?ALL) (export ?ALL)) ; import questions because of preferences

(deftemplate TEMPLATES::path
    (slot pid)
    (slot id1)
    (slot id2)
    (slot CF)
    (slot count)
)

(deftemplate TEMPLATES::chosen
    (slot pid)
    (slot id_hotel)
)

(deftemplate TEMPLATES::cost
    (slot pid)
    (slot cost)
)

(deftemplate TEMPLATES::cost_temp
    (slot id)
    (slot pid)
    (slot cost)
)

(deftemplate TEMPLATES::proposal
    (slot id)
    (slot pid)
    (multislot l)
    (slot CF)
    (slot cost)
)

; find first place of an holiday proposal
(defrule SEARCH::create_roots
    (declare (salience 10000))
    (preference (name locality_number)(value ?v)) ; to know how many places the user wants to visit
    (hotel_cf (id ?id1) (CF ?CF1))
    (not (hotel_cf (CF ?CF2&:(and (> (- ?CF2 0.02) ?CF1) (> (+ ?CF2 0.02) ?CF1)))))
    =>
    (bind ?pid (gensym*))
    (assert (path (pid ?pid)(id1 ?id1)(id2 ?id1)(CF (/ ?CF1 ?v))(count 1)))
    (assert (cost (pid ?pid)(cost 0)))
    (assert (chosen (pid ?pid) (id_hotel ?id1)))
)

; find other places of an holiday proposal
(defrule SEARCH::find_proposal
    (declare (salience 1000))
    (preference (name locality_number)(value ?v))
    (path (pid ?pid)(id2 ?id1)(count ?c&:(< ?c ?v))(CF ?CF_path))
    (hotel_cf (id ?id1)(name ?name1))
    (hotel (name ?name1)(location ?loc1))
    (distance (name1 ?loc1)(name2 ?loc2)(dist ?d2))
    (hotel (name ?name2)(location ?loc2))
    (hotel_cf (name ?name2) (CF ?CF2) (id ?id2))
    (hotel (name ?name3)(location ?loc3))
    (distance (name1 ?loc1)(name2 ?loc3)(dist ?d3))
    (not (path (pid ?pid)(count ?c1&:(eq ?c1 (+ ?c 1)))));fix bug: ripetizione percorsi stesso livello stesso pid
    (not (chosen (pid ?pid)(id_hotel ?id2)))
    (not (hotel_cf (name ?name3) (CF ?CF3&:(> (- ?CF3 (max 0 (* 0.05 (/(- ?d3 100) 20)))) (- ?CF2 (max 0 (* 0.05 (/(- ?d2 100) 20)))))))) ;non esiste un hotel3 con cf maggiore di hotel2
=>
    (assert (path (pid ?pid)(id1 ?id1)(id2 ?id2)(CF (+ ?CF_path (/ (- ?CF2 (max 0 (* 0.05 (/(- ?d2 100) 20)))) ?v)))(count (+ ?c 1))))
    (assert (chosen (pid ?pid) (id_hotel ?id2)))
)

(defrule SEARCH::cal_cost_root
    (declare (salience 100))
    (path (pid ?pid)(id2 ?id1)(count ?c)(CF ?CF_path))
    (hotel_cf (id ?id1) (name ?name1))
    (hotel (name ?name1) (stars ?stars))
=>
    (assert (cost_temp (id (gensym*)) (pid ?pid) (cost (+ 50 (* (- ?stars 1) 25)))))
)

(defrule SEARCH::cost_temp_remove
    (declare (salience 10))
    (preference (name locality_number)(value ?v))
    ?f <- (cost_temp (pid ?pid)(cost ?cost))
    ?g <- (cost (pid ?pid) (cost ?cost1))
    (path (pid ?pid) (count ?v))
=>
    (retract ?f)
    (printout t ?cost ?cost1) ; prints used for debugging purposes
    (modify ?g (cost (+ ?cost ?cost1)))

)

(defrule SEARCH::root_proposals
    (preference (name locality_number)(value ?v))
    (path (pid ?pid) (id2 ?id)(count 1))
    (path (pid ?pid) (count ?v)(CF ?CF))
    (cost (pid ?pid) (cost ?cost))
=>
    (assert (proposal (id (gensym*)) (pid ?pid) (l ?id) (CF ?CF)(cost ?cost)))
)

(defrule SEARCH::child_proposals
    (declare (salience 1))
    (preference (name locality_number)(value ?v))
    (path (pid ?pid) (id2 ?id)(count ?c&:(neq ?c 1)))
    ?f <- (proposal (pid ?pid)(l ?l))
    (cost (pid ?pid) (cost ?cost))
=>
    (modify ?f (l ?l ?id))
)

(defrule SEARCH::print
    (declare (salience 0))
    ;(false)
=>
    (facts)
)


; (defrule ANSWERS::print_answer
;     (answer(locations $?l)(nights $?n)(cost ?cost)(CF ?cf))
;     (printout "Proposta" clrf)
;     (printout "Costo: " ?cost clrf)
;     (printout "CF: " ?cf clrf)
;     print_loc_nights(?l, ?n)
; )