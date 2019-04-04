;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(setq-default
  user-full-name "Alex Springer"
  user-email-address "jalexspringer@gmail.com")

(set-face-attribute 'default nil :height 120)
(setq confirm-kill-emacs nil)

(setq doome-theme 'doom-solarized-light)

(load! "+bindings")
(load! "+org")
(load! "+gmail")
(load! "+slack")
(load! "+secrets")

(setq mu4e-maildir-shortcuts
  '( ("/flux/Inbox"     . ?i)
     ("/archive"   . ?a)
     ("/lists"     . ?l)
     ("/work"      . ?w)
     ("/sent"      . ?s)))

(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)

(setq doom-modeline-env-enable-python t)
(setq doom-modeline-env-python-executable "python3.7")
(setq doom-modeline-mu4e t)
(setq find-file-visit-truename t)

(setq mu4e-use-fancy-chars t)
(setq mu4e-alert-mode-line t)
(mu4e-alert-set-default-style 'libnotify)
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
(alert-add-rule :category "mu4e-alert" :style 'fringe :predicate (lambda (_) (string-match-p "^mu4e-" (symbol-name major-mode))) :continue t)
(setq mu4e-alert-email-notification-types '(subjects))
(setq mu4e-alert-interesting-mail-query
      (concat
       "flag:unread"
       " AND NOT flag:trashed"
       " AND NOT maildir:"
       "\"/flux/All Mail\""))

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


;;(find-file "~/org/home.org")
;;(evil-window-vsplit)
;;(mu4e)

