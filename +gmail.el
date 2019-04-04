;;; ~/.doom.d/+gmail.el -*- lexical-binding: t; -*-
;;
;;set up queue for offline email
;;use mu mkdir  ~/Maildir/queue to set up first
(setq smtpmail-queue-mail nil  ;; start in normal mode
      smtpmail-queue-dir   "~/Maildir/queue/cur")

(setq user-mail-address-list '("alex@flux7.com" "aspringer@impact.com")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)
;;location of my maildir
(setq mu4e-maildir (expand-file-name "~/Maildir"))

(after! email

;;rename files when moving
;;NEEDED FOR MBSYNC
(setq mu4e-change-filenames-when-moving t)
;;command used to get mail
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-update-interval 30)

(setq message-citation-line-format "On %a, %b %d, %Y, %H:%M %p %f wrote:")
(setq message-citation-line-function 'message-insert-formatted-citation-line)
)

;; Call EWW to display HTML messages
(defun jcs-view-in-eww (msg)
  (eww-browse-url (concat "file://" (mu4e~write-body-to-html msg))))

;; Arrange to view messages in either the default browser or EWW
(add-to-list 'mu4e-view-actions '("eww view" . jcs-view-in-eww) t)

;; Contexts: One for each mail personality.
(setq mu4e-contexts
      `( ,(make-mu4e-context
           :name "a XXX@mac.com"
           :enter-func (lambda () (mu4e-message "Enter XXX@mac.com context"))
           :leave-func (lambda () (mu4e-message "Leave XXX@mac.com context"))
           ;; Match based on the contact-fields of the message (that we are replying to)
           :match-func (lambda (msg)
                         (when msg
                           (mu4e-message-contact-field-matches msg
                                                               :to "XXX@mac.com")))
           :vars '( ( user-mail-address      . "XXX@mac.com"  )
                    ( user-full-name         . "Jon Snader" )
                    ( smtpmail-smtp-server   . "smtp.mail.me.com" )
                    ( smtpmail-smtp-service  . 587)
                    ( smtpmail-stream-type   . starttls)))

         ,(make-mu4e-context
           :name "i YYY@irreal.org"
           :enter-func (lambda () (mu4e-message "Enter YYY@irreal.org context"))
           :leave-func (lambda () (mu4e-message "Leave YYY@irreal.org context"))
           ;; we match based on the contact-fields of the message
           :match-func (lambda (msg)
                         (when msg
                           (mu4e-message-contact-field-matches msg
                                                               :to "YYY@irreal.org")))
           :vars '( ( user-mail-address       . "YYY@irreal.org" )
                    ( user-full-name          . "Jon Snader" )
                    ( smtpmail-smtp-server    . "smtp-server.tampabay.rr.com" )
                    ( smtpmail-stream-type    . plain)
                    ( smtpmail-smtp-service   . 25)))))


;; start with the first (default) context;
(setq mu4e-context-policy 'pick-first)

;; compose with the current context if no context matches;
(setq mu4e-compose-context-policy nil)

;; every new email composition gets its own frame! (window)
;;(setq mu4e-compose-in-new-frame t)
