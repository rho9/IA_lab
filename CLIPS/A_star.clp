(defmodule SEARCH (import HOTEL_CF ?ALL) (export ?ALL))

(defrule SEARCH::init_structure
    (declare (salience 1000))
=>
    (bind ?id (gensym*))
    (assert (node (hotel "root")(id root)(location "")(CF -9999.0)(distance 0.0)(level 0)(children_id (create$))(children_hotel(create$))))
    (assert (cf_list (cf (create$)))) ; LISTA VUOTA
    (assert (tabu_list (name "Tabu 1")(locations(create$))))
    (assert (tabu_list (name "Tabu 2")(locations(create$))))
    (assert (tabu_list (name "Tabu 3")(locations(create$))))
    (assert (tabu_list (name "Tabu 4")(locations(create$))))
    (assert (tabu_list (name "Tabu 5")(locations(create$))))
    (assert (tabu_list (name "Tabu_first")(locations (create$))))
)

(defrule SEARCH::extract_cf
    (declare (salience 100))
    (hotel_cf (name ?hotel) (CF ?CF))
    ?f <- (cf_list (cf $?cf_value&:(not(member$ ?hotel $?cf_value))))
=>
    (modify ?f (cf (insert$ $?cf_value 1 ?hotel)))
)

(defrule SEARCH::order_hotel_by_cf
    (declare (salience 10))
    ?f <- (cf_list (cf $?cf_value_s ?hotel ?hotel2 $?cf_value_e))
    (hotel_cf (name ?hotel) (CF ?CF))
    (hotel_cf (name ?hotel2) (CF ?CF2))
    (test (< ?CF ?CF2))
=>
    (assert (cf_list (cf $?cf_value_s ?hotel2 ?hotel $?cf_value_e)))
    (retract ?f)
)

(defrule SEARCH::first_layer
    (declare (salience 1))
    ?g <- (cf_list (cf $?cf_value))
    (hotel_cf (name ?hotel&:(member$ ?hotel $?cf_value)) (CF ?CF))
    ?i <- (tabu_list (name ?name_f&:(eq ?name_f "Tabu_first")) (locations $?locations))
    ?h <- (tabu_list (name ?name&:(neq ?name ?name_f)) (locations $?locs)(last nil))
    (hotel (name ?hotel) (location ?loc&:(not (member$ ?loc $?locations))))
    ?f <- (node (hotel "root")(id ?idr)(children_id $?children_id)(children_hotel $?children_h&:(not (member$ ?hotel $?children_h))))
=>
    (bind ?id (gensym*))
    (assert(node (parent ?idr)(id ?id)(hotel ?hotel)(location ?loc)(CF ?CF)(level 1)(distance 0.0)(children_id (create$))))
    (modify ?f (children_hotel (insert$ $?children_h 1  ?hotel)))
    (modify ?f (children_id (insert$ $?children_id 1  ?hotel)))
    (modify ?h (last ?id)(locations (insert$ $?locs 1 ?loc)))
    (modify ?i (locations (insert$ $?locations 1 ?loc)))
)



; inserisce i 40 hotel nell'albero e prende il cf migliore (modificare: deve prendere i primi 5 migliori)
; di questi 5 sottoalberi fai un cammino



; (defrule SEARCH::best_CF
;     (declare (salience 10))
;     ?f <- (node (id ?id)(hotel ?hotel) (CF ?CF) (open 1))
;     ?g <- (best_node(id ?id))
;     (node (id ?id2) (CF ?CF2&:(> ?CF ?CF2)))
; =>
;     (modify ?g (id ?id))
; )

; (defrule SEARCH::expand
;     (declare (salience -1))
;     (preference (name night) (value ?night))
;     (best_node (id ?id))
;     ?f <- (node(id ?id)(hotel ?hotel)(CF ?CF)(level ?lev&:(< ?lev ?night))) ; NON NIGHT, MA HOTEL (LOCALITà)
;     (hotel (name ?hotel)(location ?loc))
;     (distance (name1 ?loc)(name2 ?loc2)(dist ?d))
;     (hotel (name ?hotel2) (location ?loc2))
;     (hotel_cf (name ?hotel2)(CF ?CF2))
; =>  
;     (assert(node (parent ?id)(id (gensym*))(hotel ?hotel)(location ?loc)(CF ?CF)(open 1)(level ?lev)(distance ?d)(children (create$)))))
;     (modify ?f (open 0))
; )