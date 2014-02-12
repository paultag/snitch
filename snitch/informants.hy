(import [sh [ping ErrorReturnCode]]
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


(defn get-ml-subjects [url]
(.xpath
  (->> (getattr (.get requests url) "text")
       (.fromstring lxml.html)) "//a[contains(@href, 'msg')]/text()"))


(defn is-discussing [&rest topics]
  (fn [dev-list]
    (let [[subjects (get-ml-subjects
                      (.format "https://lists.debian.org/{0}/recent" dev-list))]
          [strings (genexpr (.lower x) [x subjects])]
          [bad-subjects (set (genexpr
                          topic
                          [string strings topic topics]
                          (is true (in topic string))))]]

    (if (= bad-subjects (set []))
      (, true "Looks good!")
      (, false (.format "naughty people talking about {0}"
                 (.join ", " bad-subjects)))))))


(defn has-open-port [port]
  (fn [host]
    (try
      (do
        (.connect (.socket socket) (, host port))
        (, true (+ host " has an open port at port " (str port))))
    (catch [e socket.error]
      (, false (+ host " has a closed port at port " (str port)))))))

(defn has-in-title [url what]
  (fn [host]
    (try
      (if (in what (get-html-title url))
        (, true (+ host " contains " what " in the title at " url))
        (, false (+ host " doesn't contain " what " in the title at " url)))
    (catch [e ConnectionError]
      (+ host " host is down, can't check title")))))

(defn httpable [host]
  (try
    (do
      (.get requests (+ "http://" host))
      (, true (+ host " appears to respond to http requests")))
  (catch [e ConnectionError] (, false (+ host " appears to not ack http requests")))
  (catch [e socket.error] (, false (+ host " appears to not ack http requests")))))

(defn pingable [host]
  (try
    (do
      (ping host "-c" 4)
      (, true (+ host " responded to ping")))
  (catch [e ErrorReturnCode]
    (, false (+ host " appears unpingable")))))
