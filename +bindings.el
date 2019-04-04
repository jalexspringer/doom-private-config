;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(setq doom-local-leader-key ",")

(map!
 :gnime "<f12>" #'org-agenda
 :gnime "M-<f9>" #'org-capture-refile
 :gnime "M-<f8>" #'org-capture-kill
 :gnime "M-<f11>" #'jump-to-register
 :gnime "<f7>" #'mu4e
 :gnime "M-<f7>" #'compose-mail

 :leader
 (:prefix ("a" . "alex")
   :desc "Go home"                         "h"   (λ! (find-file "~/org/home.org"))
   :desc "Mu4e"                            "m"   #'mu4e
   :desc "Mu4e Bookmarks search"           "b"   #'mu4e-headers-search-bookmark
   :desc "Mu4e view actions"               "v"   #'mu4e-view-action
   :desc "compose-mail"                    "c"   #'compose-mail
   :desc "Insert signature"                "S"   #'my-mu4e-choose-signature
   :desc "Insert Screenshot"               "s"   #'jas/insert-screenshot
   :desc "Insert Google Photo"             "p"   #'jas/insert-google-image
   :desc "Toggle link display"             "l"   #'org-toggle-link-display)
 (:prefix ("o" . "open")
   (:prefix ("s" . "slack")
     :desc "Select slack rooms"            "a"   #'slack-select-rooms
     :desc "Select slack channel"          "c"   #'slack-channel-select
     :desc "Send regions to slack"         "s"   #'as/send-region-to-slack
     :desc "Select slack group"            "g"   #'slack-im-select
     :desc "Select slack im"               "m"   #'slack-group-select
     :desc "All unread rooms"              "U"   #'slack-select-unread-rooms
     :desc "Unread privates"               "u"   #'as/slack-select-unread-mentions)
 ))
