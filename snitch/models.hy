(import [snitch.core [db]]
        datetime)


(defclass Exhibit [] [
  [--init-- (fn [self what]
              (setattr self "name" (first what))
              (setattr self "info" (second what)))]

  [down (fn [self] (not (empty? (list (filter (lambda [x] (not (none? x)))
                                              (getattr self "info"))))))]])


(defclass Deposition [dict] [
  [--init-- (fn [self what]
              (setv result (.find-one db.results {"_id" what}))
              (if (none? result)
                (throw (KeyError "Ain't no such thing"))
                (.refresh self result)))]

  [create (with-decorator classmethod
            (fn [cls set-id what]
              (setv obj (.make-object* Deposition set-id what))
              (.update db.results {"_id" set-id} obj true)))]


  [refresh (fn [self what]
              (for [(, k v) (.items what)]
                (assoc self k v))
             (.set-sites* self))]

  [down-sites (fn [self] (filter (lambda [x] (.down x))
                                 (get self "sites")))]


  [has-outage (fn [self] (any (list-comp (.down x) [x (get self "sites")])))]
  [is-down (fn [self] (all (list-comp (.down x) [x (get self "sites")])))]
  ;; xxx: precomp this, this sucks to hit twice.

  [set-sites* (fn [self]
                (assoc self "sites"
                       (list-comp (Exhibit x) [x (get self "info")])))]

  [make-object* (with-decorator classmethod
                                (fn [self set-id items]
                                  {"info" (.items items)
                                   "updated_at" (.utcnow datetime.datetime)
                                   "_id" set-id}))]

  [update (fn [self what]
            (setv result (.make-object* Deposition (get self "_id") what))
            (.update db.results {"_id" (get self "_id")} result true)
            (.refresh self result))]])
