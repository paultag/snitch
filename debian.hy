(require snitch.rules)
(import [snitch.informants [pingable httpable has-open-port is-discussing]])


(rules "debian"

  (rule "git.debian.org"
        pingable
        httpable
        (has-open-port 22)  ; ssh
        (has-open-port 9418))  ; git

  (rule "ftp-master.debian.org" pingable httpable)
  (rule "ftp.upload.debian.org" pingable (has-open-port 21))  ; ftp
  (rule "ssh.upload.debian.org" pingable (has-open-port 22))  ; ssh
  (rule "release.debian.org" pingable)  ; httpable)  ; https check next
  (rule "snapshot.debian.org" pingable httpable)
  (rule "wiki.debian.org" pingable httpable)
  (rule "lists.debian.org" pingable httpable)
  (rule "people.debian.org" pingable httpable)
  (rule "codesearch.debian.net" pingable httpable)
  (rule "sources.debian.net" pingable httpable)
  (rule "mentors.debian.net" pingable httpable)
  (rule "debian.org" pingable httpable))


(let [[init-flamewars ["systemd" "upstart" "sysvinit" "init"]]
      [is-flaming (apply is-discussing init-flamewars)]]
  (rules "debian-lists"
    (rule "debian-devel" is-flaming)
    (rule "debian-ctte" is-flaming)
    (rule "debian-vote" is-flaming)
    (rule "debian-project" is-flaming)))
