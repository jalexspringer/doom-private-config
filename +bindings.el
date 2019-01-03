;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(setq doom-local-leader-key ",")

(map!

 :gnime "<f12>" #'org-agenda
 :gnime "<f9>" #'org-capture
 :gnime "<f8>" #'org-capture-finalize
 :gnime "<f5>" #'org-refile
 :gnime "M-<f9>" #'org-capture-refile
 :gnime "M-<f8>" #'org-capture-kill
 )
