;;; ~/.doom.d/+gmail.el -*- lexical-binding: t; -*-
;;
;;set up queue for offline email
;;use mu mkdir  ~/Maildir/queue to set up first
(setq smtpmail-queue-mail nil  ;; start in normal mode
      smtpmail-queue-dir   "~/Maildir/queue/cur")

(setq user-mail-address "alex@flux7.com"
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)
;;location of my maildir
(setq mu4e-maildir (expand-file-name "~/Maildir"))

(after! email

;;command used to get mail
;; use this for testing
;; (setq mu4e-get-mail-command "true")
;; use this to sync with mbsync

;;rename files when moving
;;NEEDED FOR MBSYNC
(setq mu4e-change-filenames-when-moving t)
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-update-interval 30)

(setq message-citation-line-format "On %a, %b %d, %Y, %H:%M %p %f wrote:")
(setq message-citation-line-function 'message-insert-formatted-citation-line)

;; (add-to-list 'mu4e-bookmarks
;;   (make-mu4e-bookmark
;;     :name  "Flux Inbox"
;;     :query "maildir:/flux/Inbox"
;;     :key ?f))
)
