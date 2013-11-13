(require snitch.rules)


(rule-set "google"
  (rule "google.com"
        pingable httpable (has-in-title "http://google.com" "Googles")))

(rule-set "personal"
  (rule "pault.ag" pingable httpable))

(rule-set "debian"
  (rule "git.debian.org" pingable httpable)
  (rule "debian.org" pingable httpable))
