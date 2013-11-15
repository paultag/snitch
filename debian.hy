(require snitch.rules)
(import [snitch.informants [pingable httpable]])


(rules "debian"
  (rule "git.debian.org" pingable httpable)
  (rule "ftp-master.debian.org" pingable httpable)
  (rule "release.debian.org" pingable httpable)
  (rule "snapshot.debian.org" pingable httpable)
  (rule "wiki.debian.org" pingable httpable)
  (rule "lists.debian.org" pingable httpable)
  (rule "people.debian.org" pingable httpable)
  (rule "codesearch.debian.net" pingable httpable)
  (rule "sources.debian.net" pingable httpable)
  (rule "mentors.debian.net" pingable httpable)
  (rule "debian.org" pingable httpable))
