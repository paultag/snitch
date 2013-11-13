
(defmacro rule [host &rest conds]
  `(fn [] (setv ret null)
      (print ~host)
      (assoc results ~host [])  ;; do the list thang.
      (for [x [~@conds]]
        (print (+ "   -> " (getattr x "__name__")))
        (.append (get results ~host) (x ~host)))))


(defmacro rule-set [set-id &rest rules]
  `((fn []
      (import [pymongo [Connection]])
      (setv db (getattr (Connection "localhost" 27017) "snitch"))
      (setv results {})  ; capture each result in the closure
      (for [rue [~@rules]] (rue))

      (setv results {"_id" ~set-id
                     "info" (.items results)})

      (.update db.results
               {"_id" ~set-id}
               results
               true))))
