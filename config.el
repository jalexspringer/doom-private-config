;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq-default
  user-full-name "Alex Springer"
  user-email-address "jalexspringer@gmail.com")

(set-face-attribute 'default nil :height 120)

(load! "+bindings")
(load! "+org")
(setq confirm-kill-emacs nil)
