(import [pymongo [Connection]])

(setv db (getattr (Connection "localhost" 27017) "snitch"))
; mutable as fuck


(defmacro rule [host &rest conds]
  `(fn [] (setv ret null)
      ; (print ~host)
      (assoc results ~host [])  ;; do the list thang.
      (for [x [~@conds]]
        (setv ret (x ~host))
        (if ret (.append (get results ~host) ret)))))


(defmacro rule-set [set-id &rest rules]
  `((fn []
      (setv results {})  ; capture each result in the closure
      (for [rue [~@rules]] (rue))
      (print results))))
