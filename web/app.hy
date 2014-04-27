(import [local-config [*snitch-landing-sites*]]
        [pymongo [Connection]]
        [flask [Flask render-template request]]
        [snitch.utils [get-sets get-set-information]]
        datetime humanize)


(setv app (Flask "__main__"))
(setv db (getattr (Connection
  (.get os.environ "SNITCH_MONGO_DB_HOST" "localhost")
  (int 27017)) "snitch"))


(with-decorator (.template-filter app "time")
  (fn [dt] (.naturaltime humanize (- (.utcnow datetime.datetime) dt))))


(with-decorator (.route app "/about")
  (defn about [] (apply render-template ["index.html"]
                        {"sets" (get-sets)})))


(with-decorator (.route app "/status/<setid>")
  (defn set-view [setid]
    (apply render-template ["status.html"]
      {"set" setid
       "status" (get-set-information setid)})))

(defn get-hostname [hostname]
  (if (in ":" hostname) (first (.split hostname ":" 1)) hostname))

; look up hostname in fqdn list; redirect according to.
(with-decorator (.route app "/")
  (defn index []
    (setv hostname (get-hostname (getattr request "host")))
    (if (in hostname *snitch-landing-sites*)
      (set-view (get *snitch-landing-sites* hostname))
      (about))))
