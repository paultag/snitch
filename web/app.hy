(import [snitch.models [Deposition]]
        [pymongo [Connection]]
        [flask [Flask render-template]]
        datetime humanize)


(setv app (Flask "__main__"))
(setv db (getattr (Connection "localhost" 27017) "snitch"))


(with-decorator (.template-filter app "time")
  (fn [dt] (.naturaltime humanize (- (.utcnow datetime.datetime) dt))))


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
