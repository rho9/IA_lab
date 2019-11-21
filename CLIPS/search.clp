(defmodule SEARCH (import HOTEL_CF ?ALL) (import RULES ?ALL) (import DATA ?ALL) (import QUESTIONS ?ALL) (export ?ALL)) ; import questions because of preferences

(deftemplate TEMPLATES::path
    (slot pid)
    (slot id1)
    (slot id2)
    (slot CF)
    (slot count)
)

; (deftemplate TEMPLATES::chosen
;     (slot pid)
;     (slot id_hotel)
; )

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

(deftemplate TEMPLATES::chosen_loc
    (slot pid)
    (multislot l)
)

(deftemplate TEMPLATES::proposal_cf_money
    (multislot called)
)

(deftemplate TEMPLATES::path_value
    (slot value)
)

(deftemplate TEMPLATES::n_printed
    (slot value)
)

(deftemplate TEMPLATES::printing 
    (slot id)
)

(deftemplate TEMPLATES::printed
    (slot id)
)
; find first place of an holiday proposal
(defrule SEARCH::create_roots
    (declare (salience 10000))
    (preference (name locality_number)(value ?v)) ; to know how many places the user wants to visit
    (hotel_cf (id ?id1)(name ?name) (CF ?CF1))
    (hotel (name ?name)(location ?loc))
    (not (hotel_cf (CF ?CF2&:(and (> (- ?CF2 0.2) ?CF1) (> (+ ?CF2 0.2) ?CF1)))))
    =>
    (bind ?pid (gensym*))
    (assert (path (pid ?pid)(id1 ?id1)(id2 ?id1)(CF (/ ?CF1 ?v))(count 1)))
    (assert (cost (pid ?pid)(cost 0)))
    ;(assert (chosen (pid ?pid) (id_hotel ?id1)))
    (assert (chosen_loc (pid ?pid)(l (create$ ?loc))))
    (printout t ?pid (create$ ?loc) crlf)
    (assert (proposal_cf_money (called )))
)

; find other places of an holiday proposal
(defrule SEARCH::find_proposal
    (declare (salience 9000))
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
    ?f <- (chosen_loc (pid ?pid)(l $?l&:(not (member$ ?loc2 $?l))))
    (not (hotel_cf (name ?name3) (CF ?CF3&:(> (- ?CF3 (max 0 (* 0.05 (/(- ?d3 100) 20)))) (- ?CF2 (max 0 (* 0.05 (/(- ?d2 100) 20)))))))) ;non esiste un hotel3 con cf maggiore di hotel2
=>
    (assert (path (pid ?pid)(id1 ?id1)(id2 ?id2)(CF (+ ?CF_path (/ (- ?CF2 (max 0 (* 0.05 (/(- ?d2 100) 20)))) ?v)))(count (+ ?c 1))))
    (modify ?f (l ?loc2 $?l))
    ;(assert (chosen (pid ?pid) (id_hotel ?id2)))
    ;(assert (chosen_loc))
)

(defrule SEARCH::cal_cost_root
    (declare (salience 8000))
    (path (pid ?pid)(id2 ?id1)(count ?c)(CF ?CF_path))
    (hotel_cf (id ?id1) (name ?name1))
    (hotel (name ?name1) (stars ?stars))
=>
    (assert (cost_temp (id (gensym*)) (pid ?pid) (cost (+ 50 (* (- ?stars 1) 25)))))
)

(defrule SEARCH::cost_temp_remove
    (declare (salience 7000))
    (preference (name locality_number)(value ?v))
    ?f <- (cost_temp (pid ?pid)(cost ?cost))
    ?g <- (cost (pid ?pid) (cost ?cost1))
    (path (pid ?pid) (count ?v))
=>
    (retract ?f)
    ; (printout t "ciao")
    ; (printout t ?cost ?cost1) ; prints used for debugging purposes
    (modify ?g (cost (+ ?cost ?cost1)))
)

(defrule SEARCH::root_proposals
    (declare (salience 6000))
    (preference (name locality_number)(value ?v))
    ?f <- (path (pid ?pid) (id2 ?id)(count 1))
    (path (pid ?pid) (count ?v)(CF ?CF))
    (cost (pid ?pid) (cost ?cost))
=>
    (assert (proposal (id (gensym*)) (pid ?pid) (l ?id) (CF ?CF)(cost ?cost)))
    (assert (path_value (value 2)))
    (retract ?f)
)

(defrule SEARCH::child_proposals
    (declare (salience 5000))
    (path_value (value ?c))
    ?f <- (proposal (id ?proid)(pid ?pid)(l ?head $?l))
    ?g <- (path (pid ?pid) (id1 ?head) (id2 ?id&:(neq ?id ?head))(count ?c))
    (cost (pid ?pid) (cost ?cost))
=>
    (retract ?g)
    (modify ?f (l ?id ?head $?l))
)

(defrule SEARCH::child_update_bound
    (declare (salience 4000))
    (preference (name locality_number)(value ?v))
    ?g <- (path_value(value ?c&:(<= ?c ?v)))
    ?f <- (proposal (pid ?pid)(l ?id $?l))
    (not(path (pid ?pid) (id1 ?id)(count ?c)))
    (cost (pid ?pid) (cost ?cost))
=>
    (modify ?g (value (+ ?c 1)))
    (printout t "refresh" crlf)
    (refresh SEARCH::child_proposals)
)


(defrule SEARCH::money_temp
    (declare (salience 3000))
    ?f <- (proposal (id ?id)(CF ?CF)(cost ?cost))
    (preference (name money)(value ?v))
    ?g <- (proposal_cf_money (called $?l&:(not( member$ ?id $?l))))
=>
    (if (> ?cost ?v) then (modify ?f (id ?id)(CF (- ?CF 0.2))))
    (modify ?g (called $?l ?id)) 
)

; (defrule SEARCH::money_temp_remove
;     (declare (salience 3000))
;     ?f <- (proposal (id ?id)(CF ?CF)(cost ?cost))
;     ?g <- (proposal_cf_diff (id ?id)(CF ?deltaCF))
; =>
;     (printout t ?id ?g crlf)
;     (retract ?g)
;     (modify ?f (CF (- ?CF ?deltaCF)))
;     (printout t (- ?CF ?deltaCF))
; )

(defrule SEARCH::init_printing 
    (declare (salience 2000))
=>
    (assert (n_printed (value 0)))
    (printout t crlf)
)

(defrule SEARCH::print_paths
    (declare (salience 1000))
    (proposal (id ?id)(pid ?pid)(l $?path)(CF ?CF)(cost ?cost))
    (not (proposal (CF ?CF1&:(> ?CF1 ?CF))))
    ?f <- (n_printed (value ?p&:(< ?p 5)))
    (not (printing (id ?idp)))
    (not (printed (id ?idd)))
=>
    (modify ?f (value (+ ?p 1)))
    (assert (printing (id ?id)))
    (printout t (+ ?p 1) ") ")
)

(defrule SEARCH::printing_paths
    (declare (salience 900))
    ?g <- (printing (id ?id))
    ?f <- (proposal (id ?id)(pid ?pid)(l ?head $?path)(CF ?CF)(cost ?cost))
    (hotel_cf (id ?head)(name ?name))
    (hotel(name ?name)(location ?loc)(stars ?s))
    (not (printed (id ?idd)))
=>
    ;(retract ?f)
    ;(assert(proposal (id ?id)(pid ?pid)(l ?head $?path)(CF ?CF)(cost ?cost)))
    (printout t ?loc " (" ?name " " ?s " stars" ") ")
    (if (eq $?path (create$)) 
        then 
            (retract ?g)
            (assert (printed (id ?id)))
        else
            (modify ?f (l $?path))
    )
)

(defrule SEARCH::printed_paths
    (declare (salience 800))
    ?g <-(printed (id ?id))
    ?f <- (proposal (id ?id)(pid ?pid)(CF ?CF)(cost ?cost))
=>
    (printout t "cost: " ?cost "€ -> " (* ?CF 100) "%" crlf)
    (retract ?f)
    (retract ?g)
)


(defrule SEARCH::print
    (declare (salience -100))
    (false)
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