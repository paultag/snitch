(defmacro rule [host &rest conds]
  `(fn [] (setv ret nil)
      (print ~host)
      (assoc results ~host [])  ;; do the list thang.
      (for [x [~@conds]]
        (print (+ "   -> " (getattr x "__name__")))
        (.append (get results ~host) (x ~host)))))


(defmacro rules [set-id &rest my-rules]
  `((fn []
      (import futures [snitch.models [Deposition]])

      (setv results {})  ; capture each result in the closure
      (with [[executor (apply futures.ThreadPoolExecutor
                        [] {"max_workers" 15})]]
             (for [future
                   (.as-completed futures
                     (list-comp (.submit executor rue) [rue [~@my-rules]]))]
               (print future))
             (.create Deposition ~set-id results)))))


; with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
;     future_to_url = {executor.submit(load_url, url, 60): url for url in URLS}
;         for future in concurrent.futures.as_completed(future_to_url):
