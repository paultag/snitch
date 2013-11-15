(require snitch.rules)
(import [snitch.informants [pingable httpable has-open-port]])


(rules "bads" (rule "foobar.example" pingable))
(rules "google" (rule "google.com" pingable httpable))
(rules "personal" (rule "pault.ag"
                        pingable
                        httpable
                        (has-open-port 22)))
