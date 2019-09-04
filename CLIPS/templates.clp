(defmodule TEMPLATES (export ?ALL))

(deftemplate TEMPLATES::hotel "hotels"
    (slot name (type STRING))
    (slot stars (type INTEGER)(range 1 5))
    (slot location (type STRING))
    (slot free_rooms (type INTEGER) (range 0 ?VARIABLE))
)

(deftemplate TEMPLATES::location "location"
    (slot name (type STRING))
    (slot region (type SYMBOL)
    (allowed-symbols piemonte valle_aosta liguria lombardia trentino veneto friuli emilia_romagna toscana umbria marche lazio abruzzo molise campania puglia basilicata calabria sicilia sardegna))
    (slot balneare (type INTEGER)(default 0)(range 0 5))
    (slot montano (type INTEGER)(default 0)(range 0 5))
    (slot lacustre (type INTEGER)(default 0)(range 0 5))
    (slot naturalistico (type INTEGER)(default 0)(range 0 5))
    (slot termale (type INTEGER)(default 0)(range 0 5))
    (slot culturale (type INTEGER)(default 0)(range 0 5))
    (slot religioso (type INTEGER)(default 0)(range 0 5))
    (slot sportivo (type INTEGER)(default 0)(range 0 5))
    (slot enogastronomico (type INTEGER)(default 0)(range 0 5))
)

(deftemplate TEMPLATES::position
    (slot name (type STRING))
    (slot latitude (type FLOAT))
    (slot longitude (type FLOAT))
)

;;**********************
;;* QUESTIONS TEMPLATE *
;;**********************

(deftemplate TEMPLATES::question
   (slot preference (default ?NONE)) ; COSA è
   (slot the_question (default ?NONE))
   (multislot valid_answers (default nil))
   (slot already_asked (default FALSE)) ; avoid that a question is asked more than one time
)

(deftemplate TEMPLATES::preference ; SE NON SERVE TOGLIERLO, ALTRIMENTI SCRIVERE A COSA SERVE
   (slot name)
   (slot value)
)
 
(deftemplate TEMPLATES::hotel_cf 
    (slot name)
    (slot CF(type FLOAT))
)

(deftemplate TEMPLATES::hotel_cf_temp 
    (slot name)
    (slot CF(type FLOAT))
    (slot type)
)

(deftemplate TEMPLATES::distance
    (slot name1)
    (slot name2)
    (slot dist)
)

 (deftemplate TEMPLATES::node
     (slot parent)
;     (slot id)
     (slot hotel)
     (slot location)
     (slot CF)
;     (slot open) ; frontiera aperta
     (slot distance)
     (slot level)
     (multislot children)
 )

(deftemplate TEMPLATES::cf_list
    (multislot cf)
)

; (deftemplate TEMPLATES::best_node
;     (slot id)
; )

; (deftemplate TEMPLATES::best_expansion
;     (slot id)
; )

;(deftemplate TEMPLATES::solution
;    (multislot sol1)
;    (slot cf1)
;    (multislot sol2)
;    (slot cf2)
;    (multislot sol3)
;    (slot cf3)
;    (multislot sol4)
;    (slot cf4)
;    (multislot sol5)
;    (slot cf5)
;)

;(deftemplate TEMPLATES::bests
;    (multislot ids (default -100)) 