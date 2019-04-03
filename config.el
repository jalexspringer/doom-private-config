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

(setq mu4e-maildir-shortcuts
  '( ("/flux/Inbox"     . ?i)
     ("/archive"   . ?a)
     ("/lists"     . ?l)
     ("/work"      . ?w)
     ("/sent"      . ?s)))
