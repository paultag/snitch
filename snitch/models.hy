(import [snitch.core [db]] datetime)



(defclass
  Exhibit
  [dict] [

  [--init-- (fn [self site status]

              (assoc self "up" [])
              (assoc self "down" [])
              (assoc self "site" site)
              (assoc self "status" status)

              (for [(, up msg) status]
                (.append (if up (get self "up") (get self "down")) msg)))]

  [exhibit->list (fn [self] (get self "status"))]
  [is-online (fn [self] (empty? (get self "down")))]
  [is-offline (fn [self] (and (not (empty? (get self "down")))
                              (empty? (get self "up"))))]
  [is-mixed (fn [self]
              ; This is True if we've got some up and some down.
              (and (not (empty? (get self "down")))
                   (not (empty? (get self "up")))))]])


(defn create-deposition [set-id result]
  {"updated_at" (.utcnow datetime.datetime)
   "_id" set-id
   "info" (.items result)})


(defclass
  Deposition
  [dict] [

  [--init-- (fn [self set-id]
              (setv obj (.find-one db.results {"_id" set-id}))
              (if (none? obj)
                (raise (KeyError (+ "No such entry: " set-id)))
                (for [(, k v) (.items obj)] (assoc self k v)))
              (.refresh self))]

  [refresh (fn [self]
             (assoc self "sites" [])

             (for [(, site status) (get self "info")]
               (.append (get self "sites") (Exhibit site status)))

             (assoc self "mixed" [])
             (assoc self "down" [])
             (assoc self "up" [])

             (for [site (get self "sites")]
               (.append
                 (cond
                   [(.is-online site) (get self "up")]
                   [(.is-offline site) (get self "down")]
                   [true (get self "mixed")])  ; don't waste cycles.
                 site)))]

  [is-online (fn [self] (empty? (get self "down")))]

  [is-offline (fn [self] (and (not (empty? (get self "down")))
                              (empty? (get self "up"))))]
  [is-mixed (fn [self]
              ; This is True if we've got some up and some down.
              (or (not (empty? (get self "mixed")))
                (and (not (empty? (get self "down")))
                     (not (empty? (get self "up"))))))]

  [create (with-decorator classmethod (fn [self set-id result]
            (.update db.results
                     {"_id" set-id}
                     (create-deposition set-id result)
                     true)
            (Deposition set-id)))]])
