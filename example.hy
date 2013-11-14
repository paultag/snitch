(require snitch.rules)
(import [snitch.informants [pingable httpable]])


(rules "bads" (rule "foobar.example" pingable))

(rules "google" (rule "google.com" pingable httpable))
(rules "personal" (rule "pault.ag" pingable httpable))

(rules "debian"
  (rule "git.debian.org" pingable httpable)
  (rule "debian.org" pingable httpable))
