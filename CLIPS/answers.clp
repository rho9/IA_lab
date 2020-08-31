(defmodule ANSWERS)

(deftemplate ANSWERS::answer
    (multislot locations (type STRING))
    (multislot nights (type INTEGER)(range 0 ?VARIABLE))
    (slot cost (type INTEGER)(range 0 ?VARIABLE))
    (slot CF (type FLOAT))
)

(defrule ANSWERS::print_answer
    (answer(locations $?l)(nights $?n)(cost ?cost)(CF ?cf))
    (printout "Proposta" clrf)
    (printout "Costo: " ?cost clrf)
    (printout "CF: " ?cf clrf)
    print_loc_nights(?l, ?n)
)

(deffunction ANSWERS::print_loc_nights(locations, nights)
    
)