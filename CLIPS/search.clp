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

(defrule SEARCH::create_roots
    (declare (salience 10000))
    (hotel_cf (id ?id1) (CF ?CF1))
    (not (hotel_cf (CF ?CF2&:(and (> (- ?CF2 0.02) ?CF1) (> (+ ?CF2 0.02) ?CF1)))))
    =>
    (bind ?pid (gensym*))
    (assert (path (pid ?pid))(id1 ?id1)(id2 ?id1)(CF ?CF1)(count 1)))
    (assert (chosen (pid ?pid) (id_hotel ?id1)))
)

(defrule SEARCH::find_proposal
    (declare (salience 1000))
    (preference (?name locality_number)(value ?v))
    (path (pid ?pid)(id2 ?id1)(count ?c&:(< ?c ?v)))
    (hotel_cf (id ?id1)(name ?name1))
    (hotel (name ?name1)(location ?loc1))
    (distance (name1 ?loc1)(name2 ?loc2)(dist ?d2))
    (hotel (name ?name2)(location ?loc2))
    (hotel_cf (name ?name2) (CF ?CF2) (id ?id2))
    (hotel (name ?name3)(location ?loc3))
    (distance (name1 ?loc1)(name2 ?loc3)(dist ?d3))
    (not (hotel_cf (name ?name3) (CF ?CF3&:((> (- ?CF3 (max 0 (* 0.05 ?d3-100))) (- ?CF2 (max 0 (* 0.05 ?d2-100))))))))
=>
    ;aggiorna count cf creare nuovo path
)