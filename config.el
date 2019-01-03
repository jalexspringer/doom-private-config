;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq-default
  user-full-name "Alex Springer"
  user-email-address "jalexspringer@gmail.com")

;; lang/org
(setq org-directory (expand-file-name "~/org/")
      org-agenda-files (list org-directory)
      org-bullet-bullet-list '("#"))

(load! "+bindings")
(load! "+org")

(setq confirm-kill-emacs nil)
