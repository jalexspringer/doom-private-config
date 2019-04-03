;;; ~/.doom.d/+slack.el -*- lexical-binding: t; -*-

(add-hook 'slack-mode-hook #'emojify-mode)
(setq slack-buffer-create-on-notify t)

;;; Channels
(setq slack-message-notification-title-format-function
      (lambda (_team room threadp)
        (concat (if threadp "Thread in #%s") room)))

(defun endless/-cleanup-room-name (room-name)
  "Make group-chat names a bit more human-readable."
  (replace-regexp-in-string
   "--" " "
   (replace-regexp-in-string "#mpdm-" "" room-name)))

;;; Private messages and group chats
(setq slack-message-im-notification-title-format-function
 (lambda (_team room threadp)
   (concat (if threadp "Thread in %s")
           (endless/-cleanup-room-name room))))
