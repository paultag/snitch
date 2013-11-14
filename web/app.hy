(import [snitch.models [Deposition]]
        [pymongo [Connection]]
        [flask [Flask render-template]])


(setv app (Flask "__main__"))
(setv db (getattr (Connection "localhost" 27017) "snitch"))


(with-decorator (.route app "/")
  (defn index [] (kwapply (render-template "index.html")
                          {"sets" (.find db.results)})))

(with-decorator (.route app "/status/<setid>")
  (defn set-view [setid]
    (try
      (kwapply (render-template "status.html")
               {"set" setid
                "deposition" (Deposition setid)})
    (catch [e KeyError]
      (, (render-template "404.html") 404)))))
