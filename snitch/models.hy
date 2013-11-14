(import [snitch.core [db]]
        datetime)


(defclass Deposition [dict] [
  [--init-- (fn [self what]
              (.refresh self (.find-one db.results {"_id" what})))]

  [refresh (fn [self what]
              (for [(, k v) (.items what)]
                (assoc self k v)))]

  [update (fn [self what]
            (setv result {"info" (.items what)
                          "updated_at" (.utcnow datetime.datetime)
                          "_id" (get self "_id")})
            (.update db.results {"_id" (get self "_id")} result true)
            (.refresh self result))]])
