(defmodule SEARCH (import HOTEL_CF ?ALL) (import RULES ?ALL) (import DATA ?ALL) (import QUESTIONS ?ALL) (export ?ALL)) ; import questions because of preferences

(defrule SEARCH::init_list
    (salience -1)
    (hotel_cf (id ?id) (CF ?CF))
    ;?f <- (orderedHCF(hotel_cf_id_list $?head&:(not(member$ ?id $?head)) $?tail&:(not(member$ ?id $?tail))))
=>
    ;(retract ?f)
    ;(assert (orderedHCF(hotel_cf_id_list $?head ?id $?tail)))
    ;(printout t $?head ?id $?tail crlf)
    (printout t 1)
)