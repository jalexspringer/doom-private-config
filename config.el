;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(setq-default
  user-full-name "Alex Springer"
  user-email-address "jalexspringer@gmail.com")

(set-face-attribute 'default nil :height 120)
(setq confirm-kill-emacs nil)

(setq doom-theme 'doom-solarized-light)

(load! "+bindings")
(load! "+org")
(load! "+gmail")
(load! "+slack")
(load! "+secrets")
(load! "+trello")
(load! "+sx")

(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)

(setq doom-modeline-env-enable-python t)
(setq doom-modeline-env-python-executable "python3.7")
(setq doom-modeline-mu4e t)
(setq find-file-visit-truename t)

(setq rmh-elfeed-org-files (list "~/.doom.d/elfeed.org"))
(setq-default elfeed-search-filter "@1-week-ago +unread ")

(defun as/setup-windows ()
  "Organize a series of windows for ultimate distraction."
  (interactive)
  (delete-other-windows)

  ;; Start slack and email
  (slack-start)
  (mu4e)

  ;; Move to home.org
  (split-window-horizontally)
  (other-window 1)
  (find-file "~/org/home.org")

  ;; My RSS Feed goes on top:
  (split-window-vertically)
  (elfeed)

  (window-configuration-to-register ?w))


;; (as/setup-windows)
