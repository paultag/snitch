(import [snitch.models [Deposition]]
        [local-config [*snitch-landing-sites*]]
        [pymongo [Connection]]
        [flask [Flask render-template request]]
        datetime humanize)


(setv app (Flask "__main__"))
(setv db (getattr (Connection "localhost" 27017) "snitch"))


(with-decorator (.template-filter app "time")
  (fn [dt] (.naturaltime humanize (- (.utcnow datetime.datetime) dt))))


(with-decorator (.route app "/about")
  (defn about [] (kwapply (render-template "index.html")
                          {"sets" (.find db.results)})))

(with-decorator (.route app "/status/<setid>")
  (defn set-view [setid]
    (try
      (kwapply (render-template "status.html")
               {"set" setid
                "deposition" (Deposition setid)})
    (catch [e KeyError]
      (, (render-template "404.html") 404)))))


(defn get-hostname [hostname]
  (if (in ":" hostname) (first (.split hostname ":" 1)) hostname))

; look up hostname in fqdn list; redirect according to.
(with-decorator (.route app "/")
  (defn index []
    (setv hostname (get-hostname (getattr request "host")))
    (if (in hostname *snitch-landing-sites*)
      (set-view (get *snitch-landing-sites* hostname))
      (about))))
