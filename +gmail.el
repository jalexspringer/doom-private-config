;;; ~/.doom.d/+gmail.el -*- lexical-binding: t; -*-
;;
;;set up queue for offline email
;;use mu mkdir  ~/Maildir/queue to set up first
(setq smtpmail-queue-mail nil  ;; start in normal mode
      smtpmail-queue-dir   "~/Maildir/queue/cur")
;;
;;location of my maildir
(setq mu4e-maildir (expand-file-name "~/Maildir"))


;; Call EWW to display HTML messages
(defun jcs-view-in-eww (msg)
  (eww-browse-url (concat "file://" (mu4e~write-body-to-html msg))))

;; Contexts: One for each mail personality.
;; First, check the folder the email is in
;; https://www.reddit.com/r/emacs/comments/47t9ec/share_your_mu4econtext_configs/
(defun mu4e-message-maildir-matches (msg rx)
  (when rx
    (if (listp rx)
        ;; if rx is a list, try each one for a match
        (or (mu4e-message-maildir-matches msg (car rx))
            (mu4e-message-maildir-matches msg (cdr rx)))
      ;; not a list, check rx
      (string-match rx (mu4e-message-field msg :maildir)))))


(after! mu4e
    (setq mu4e-contexts
        `( ,(make-mu4e-context
            :name "f alex@flux7.com"
            :enter-func (lambda () (mu4e-message "Enter alex@flux7.com context"))
            :leave-func (lambda () (mu4e-message "Leave alex@flux7.com context"))
            :match-func (lambda (msg)
                          (when msg
                            (mu4e-message-contact-field-matches msg :to "flux7\.com$")))
            ;; Match based the folder of the message replying to
            ;; :match-func (lambda (msg)
            ;;                 (when msg
            ;;                 (mu4e-message-maildir-matches msg "^/flux")))
            :vars '( ( user-mail-address      . "alex@flux7.com"  )
                        ( user-full-name         . "Alex Springer" )
                        ( smtpmail-smtp-user . "alex@flux7.com")))

            ,(make-mu4e-context
            :name "i aspringer@impact.com"
            :enter-func (lambda () (mu4e-message "Enter aspringer@impact.com context"))
            :leave-func (lambda () (mu4e-message "Leave aspringer@impact.com context"))
            :match-func (lambda (msg)
                          (when msg
                            (mu4e-message-contact-field-matches msg :to "impact\.com$")))
            ;; ;; Match based the folder of the message replying to
            ;; :match-func (lambda (msg)
            ;;                 (when msg
            ;;                 (mu4e-message-maildir-matches msg "^/impact")))
            :vars '( ( user-mail-address      . "aspringer@impact.com"  )
                        ( user-full-name         . "Alex Springer" )
                        ( smtpmail-smtp-user . "aspringer@impact.com")))))
    ;;rename files when moving
    ;;NEEDED FOR MBSYNC
    (setq mu4e-change-filenames-when-moving t)
    ;;command used to get mail
    (setq mu4e-get-mail-command "mbsync -a")
    (setq mu4e-update-interval 120)

    (setq message-citation-line-format "On %a, %b %d, %Y, %H:%M %p %f wrote:")
    (setq message-citation-line-function 'message-insert-formatted-citation-line)
    ;; Arrange to view messages in either the default browser or EWW
    (add-to-list 'mu4e-view-actions '("eww view" . jcs-view-in-eww) t)
)


;; start with the first (default) context;
(setq mu4e-context-policy 'pick-first)

;; compose with the current context if no context matches;
(setq mu4e-compose-context-policy nil)

;; every new email composition gets its own frame! (window)
(setq mu4e-compose-in-new-frame t)

(setq mu4e-use-fancy-chars t)
(setq mu4e-alert-mode-line t)
(mu4e-alert-set-default-style 'libnotify)
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
(alert-add-rule :category "mu4e-alert" :style 'fringe :predicate (lambda (_) (string-match-p "^mu4e-" (symbol-name major-mode))) :continue t)
(setq mu4e-alert-email-notification-types '(subjects))
(setq mu4e-alert-interesting-mail-query
      (concat
       "maildir:"
       "\"/flux/Inbox\""
       " OR maildir:"
       "\"/impact/Inbox\""
       "AND flag:unread"))

(setq mu4e-maildir-shortcuts
  '( ("/flux/Inbox"     . ?f)
     ("/impact/Inbox"   . ?i)
     ("/sent"      . ?s)))

(setq mu4e-update-interval 30)
(defun my-mu4e-choose-signature ()
    "Insert one of a number of sigs"
      (interactive)
        (let ((message-signature
	  (mu4e-read-option "Signature:"
	   '(("formal" .
             (concat
		    "Alex Springer\n"
		    "Solutions Architect\n"
		    "[[https://flux7.com][Flux7]]"))
			 ("informal" .
			  "Alex\n")))))
	      (message-insert-signature)))
