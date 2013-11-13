(require snitch.rules)
(import [snitch.informants [pingable httpable]])


(rule-set "google" (rule "google.com" pingable httpable))
(rule-set "personal" (rule "pault.ag" pingable httpable))

; (rule-set "debian"
;   (rule "git.debian.org" pingable httpable)
;   (rule "debian.org" pingable httpable))
