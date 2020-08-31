(defmodule SEARCH (import HOTEL_CF ?ALL) (import RULES ?ALL) (import DATA ?ALL) (import QUESTIONS ?ALL) (export ?ALL)) ; import questions because of preferences

; find first place of an holiday proposal
(defrule SEARCH::create_roots
    (declare (salience 10000))
    (preference (name locality_number)(value ?v)) ; to know how many places the user wants to visit
    (hotel_cf (id ?id1)(name ?name) (CF ?CF1))
    (hotel (name ?name)(location ?loc))
    (not (hotel_cf (CF ?CF2&:(> (- ?CF2 0.2) ?CF1))))
    =>
    (bind ?pid (gensym*))
    (assert (path (pid ?pid)(id1 ?id1)(id2 ?id1)(CF (/ ?CF1 ?v))(count 1)))
    (assert (cost (pid ?pid)(cost 0)))
    (assert (chosen_loc (pid ?pid)(l (create$ ?loc))))
    (printout t ?pid (create$ ?loc) crlf)
    (assert (proposal_cf_money (called )(over false)))
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
    (not (path (pid ?pid)(count ?c1&:(eq ?c1 (+ ?c 1)))));untill the end
    ?f <- (chosen_loc (pid ?pid)(l $?l&:(not (member$ ?loc2 $?l))))
    (not (hotel_cf (name ?name3) (CF ?CF3&:(> (- ?CF3 (max 0 (* 0.05 (/(- ?d3 100) 20)))) (- ?CF2 (max 0 (* 0.05 (/(- ?d2 100) 20)))))))) ;non esiste un hotel3 con cf maggiore di hotel2
=>
    (assert (path (pid ?pid)(id1 ?id1)(id2 ?id2)(CF (+ ?CF_path (/ (- ?CF2 (max 0 (* 0.05 (/(- ?d2 100) 20)))) ?v)))(count (+ ?c 1)))) ; 
    (modify ?f (l ?loc2 $?l))
)

(defrule SEARCH::cal_cost
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
    (modify ?g (cost (+ ?cost ?cost1)))
)

(defrule SEARCH::root_proposals
    (declare (salience 6000))
    (preference (name locality_number)(value ?v))
    ?f <- (path (pid ?pid) (id2 ?id)(count 1))
    (path (pid ?pid) (count ?v)(CF ?CF))
    (cost (pid ?pid) (cost ?cost))
    (hotel_cf (name ?name) (id ?id))
    (hotel (name ?name)(location ?loc))
=>
    (assert (proposal (id (gensym*)) (pid ?pid) (l ?id) (locs ?loc) (CF ?CF)(cost ?cost)))
    (assert (path_value (value 2)))
    (retract ?f)
)

(defrule SEARCH::child_proposals
    (declare (salience 5000))
    (path_value (value ?c))
    ?f <- (proposal (id ?proid)(pid ?pid)(l ?head $?l)(locs ?locshead $?locs))
    ?g <- (path (pid ?pid) (id1 ?head) (id2 ?id&:(neq ?id ?head))(count ?c))
    (hotel_cf (name ?name) (id ?id))
    (hotel (name ?name)(location ?loc))
    (cost (pid ?pid) (cost ?cost))
=>
    (retract ?g)
    (modify ?f (l ?id ?head $?l)(locs ?loc ?locshead $?locs))
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
    (refresh SEARCH::child_proposals)
)

(defrule SEARCH::remove_proposals
    (declare (salience 3500))
    ?f <- (proposal (pid ?pid1)(locs $?locs1)(CF ?CF1))
    ?g <- (proposal (pid ?pid2&:(neq ?pid1 ?pid2))(locs $?locs2)(CF ?CF2))
=>
    (foreach ?loc1 $?locs1
        (foreach ?loc2 $?locs2
            (bind ?l2 ?loc2)
            (if (eq ?loc1 ?loc2) then (break)))
        (bind ?l1 ?loc1)
        (if (neq ?l1 ?l2) then (break)))
    (if (eq ?l1 ?l2) then (if (> ?CF1 ?CF2) then (retract ?g)else (retract ?f)))
)

(defrule SEARCH::money_temp
    (declare (salience 3000))
    ?f <- (proposal (id ?id)(CF ?CF)(cost ?cost))
    (preference (name money)(value ?v))
    ?g <- (proposal_cf_money (called $?l&:(not( member$ ?id $?l)))(over false))
=>
    (if (> ?cost ?v) then 
        (modify ?f (id ?id)(CF (- ?CF 0.2)))
        (modify ?g (over true))
    )
    (modify ?g (called $?l ?id))
)

(defrule SEARCH::init_printing 
    (declare (salience 2000))
=>
    (assert (n_printed (value 0)))
    (printout t crlf)
)

(defrule SEARCH::print_paths
    (declare (salience 1000))
    (proposal (id ?id)(pid ?pid)(l $?path)(CF ?CF)(cost ?cost))
    (not (proposal (CF ?CF1&:(> ?CF1 ?CF)))) ;must be max
    ?f <- (n_printed (value ?p&:(and (< ?p 5) (or (> ?CF 0.5) (< ?p 2)))))
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