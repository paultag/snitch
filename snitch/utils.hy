(import [snitch.core [db]])


(defn get-sets []
  (db.sites.distinct "set"))

(defn get-sites []
  (db.sites.distinct "site"))

(defn get-sites-in-set [setid]
  (let [[sites (db.sites.find {"set" setid})]]
    (if (= sites [])
      (raise (KeyError "No such set"))
      (dict-comp (get x "_id") x [x sites]))))

(defn get-check-information [setid site check]
  (let [[dbs (get db (% "snitch.%s" setid))]
        [info (-> dbs
                  (.find {"set" setid
                          "site" site
                          "check" check})
                  (.sort "checked_at" -1)
                  (.limit 1)
                  (get 0))]]
      {"check" info
       "status" (if (get info "failed") "down" "ok")}))


(defn get-site-information [setid site]
  (let [[info (db.sites.find-one {"set" setid "_id" site})]
        [checks (list-comp
                  (get-check-information setid site check)
                  [check (get info "checks")])]
        [statuses (set (list-comp (get x "status") [x checks]))]
        [status (cond [(= statuses (set ["ok"])) "ok"]
                      [(= statuses (set ["down"])) "down"]
                      [true "out"])]]

      {"checks" checks
       "status" status
       "statuses" statuses
       "site" site}))


(defn get-set-information [setid]
  ; db.snitch.debian.find({"site": "", "set": "debian"}).sort(
  ;                          {"checked_at": -1}).limit(1)

  (let [[site-names (get-sites-in-set setid)]
        [sites (list-comp (get-site-information setid x) [x site-names])]
        [statuses (set (list-comp (get x "status") [x sites]))]
        [status (cond [(= statuses (set ["ok"])) "ok"]
                      [(= statuses (set ["down"])) "down"]
                      [true "out"])]]

      {"sites" sites
       "status" status
       "statuses" statuses
       "set" setid}))
