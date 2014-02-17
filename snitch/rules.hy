(require acid.language)


(defmacro/g! rule [host &rest my-checks]
  `((fn []
    (for [~g!check [~@my-checks]]
      (emit :start-checking {:site ~host :check ~g!check})))))


(defmacro rules [set-id &rest my-rules]
  `((fn []
    (import [snitch.informants [pingable httpable]]
            [snitch.core [db]] random datetime)

    (trip
      (let [[*min-ping-length* (acid-time 1 minute)]
            [*max-ping-length* (acid-time 10 minutes)]]
        (on :startup (print "snitch daemon for" ~set-id "online"))

        (on :update  ;; This is debug information
          (print (:site event) (:failed event) (:info event)
            "(done in" (:runtime event) "seconds)"
            "next check is in" (:retry-delay event) "seconds"))

    (on :update  ;; store the event in memory
      (let [[oid (.insert (get db "snitch")
              {"checked_at" (:checked-at event)
               "failed"     (:failed event)
               "site"       (:site event)
               "check"      (. (:check event) --name--)
               "info"       (:info event)
               "value"      (.total-seconds (:runtime event))})]]
        (print "stored report as" oid)))

        (on :start-checking
          (schedule-in-seconds (.randint random 0 60)
            (defns [wait]
              (let [[start (.utcnow datetime.datetime)]
                    [(, is-up info) ((:check event) (:site event))]
                    [end (.utcnow datetime.datetime)]
                    [response-time (- end start)]
                    [time (if is-up (* wait 2) (/ wait 2))]
                    [retry-time (cond [(< time *min-ping-length*) *min-ping-length*]
                                      [(> time *max-ping-length*) *max-ping-length*]
                                      [true time])]]

                (emit :update {:site (:site event)
                               :checked-at start
                               :check (:check event)
                               :runtime (- end start)
                               :failed (not is-up)
                               :retry-delay retry-time
                               :info info})

                (reschedule-in-seconds retry-time retry-time))) 0))

        ~@my-rules)))))
