;;******************
;; file da eseguire*
;;******************

(deffunction MAIN::l ()
   (load main.clp)
   (load templates.clp)
   (load questions.clp)
   (load data.clp)
   (load rules.clp)
   (load hotel_cf.clp)
   (reset)
   (run)
   TRUE
)