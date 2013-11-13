(import [sh [ping ErrorReturnCode-1]]
        [requests.exceptions [ConnectionError]]
        lxml.html
        requests
        socket)

(def results {})

(defn get-html-title [url]
  (.text-content (get
    (.xpath
      (->> (getattr (.get requests url) "text")
           (.fromstring lxml.html)) "//title") 0)))

(defn has-in-title [url what]
  (fn [host]
    (try
      (if (in what (get-html-title url))
        null
        (+ host " doesn't contain " what " in the title at " url))
    (catch [e ConnectionError]
      (+ host " host is down, can't check title")))))

(defn httpable [host]
  (try
    (do (.get requests (+ "http://" host)) null)
  (catch [e ConnectionError] (+ host " appears to not ack http requests"))
  (catch [e socket.error] (+ host " appears to not ack http requests"))))

(defn pingable [host]
  (try
    (do (ping host "-c" 1) null)
;       (, true (+ host " responded to ping")))
  (catch [e ErrorReturnCode-1]
    (+ host " appears unpingable"))))


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
