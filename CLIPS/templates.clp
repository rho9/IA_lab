(defmodule TEMPLATES (export ?ALL))

(deftemplate TEMPLATES::hotel "hotels"
    (slot name (type STRING))
    (slot stars (type INTEGER)(range 1 5))
    (slot location (type STRING))
    (slot free_rooms (type INTEGER) (range 0 ?VARIABLE))
)

(deftemplate TEMPLATES::locality "locality"
    (slot name (type STRING))
    (slot _region (type STRING))
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
   (slot attribute (default ?NONE)) ; COSA è
   (slot the-question (default ?NONE))
   (multislot valid-answers (default nil))
   (slot already-asked (default FALSE)) ; avoid that a question is asked more than one time
)

(deftemplate TEMPLATES::attribute ; SE NON SERVE TOGLIERLO, ALTRIMENTI SCRIVERE A COSA SERVE
   (slot name)
   (slot value)
   (slot certainty (default 100.0)))
 
