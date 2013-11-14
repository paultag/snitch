(defmacro rule [host &rest conds]
  `(fn [] (setv ret null)
      (print ~host)
      (assoc results ~host [])  ;; do the list thang.
      (for [x [~@conds]]
        (print (+ "   -> " (getattr x "__name__")))
        (.append (get results ~host) (x ~host)))))


(defmacro rules [set-id &rest my-rules]
  `((fn []
      (import [snitch.models [Deposition]])

      (setv results {})  ; capture each result in the closure
      (for [rue [~@my-rules]] (rue))

      (.update (Deposition ~set-id) results))))
