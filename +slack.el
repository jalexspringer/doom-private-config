;;; ~/.doom.d/+slack.el -*- lexical-binding: t; -*-

(def-package! slack
  :commands (slack-start)
  :init
  (setq slack-buffer-emojify t) ;; if you want to enable emoji, default nil
  (setq slack-prefer-current-team t)

  (evil-define-key 'normal slack-info-mode-map
    ",u" 'slack-room-update-messages)
  (evil-define-key 'normal slack-mode-map
    "\C-n" 'slack-buffer-goto-next-message
    "\C-p" 'slack-buffer-goto-prev-message)
   (evil-define-key 'normal slack-edit-message-mode-map
    ",k" 'slack-message-cancel-edit
    ",s" 'slack-message-send-from-buffer
    ",e" 'slack-message-send-from-buffer
    ",2" 'slack-message-embed-mention
    ",3" 'slack-message-embed-channel)
   (map!
    :map slack-mode-map
    :leader
    (:prefix ("m" . "slack stuff")
      :desc "Kill buffer"                      "c"    #'slack-buffer-kill
      (:prefix ("r" . "react")
        :desc "Add reaction"                   "a" #'slack-message-add-reaction
        :desc "Remove reaction"                "r" #'slack-message-remove-reaction
        :desc "Show reaction users"            "s" #'slack-message-show-reaction-users)
      (:prefix ("p" . "pin")
        :desc "Pins list"                      "l" #'slack-room-pins-list
        :desc "Pin add"                        "a" #'slack-message-pins-add
        :desc "Pin remove"                     "r" #'slack-message-pins-remove)
      :desc "Write message in new buffer"    "m" #'slack-message-write-another-buffer
      :desc "Edit message"                   "e" #'slack-message-edit
      :desc "Message delete"                 "d" #'slack-message-delete
      :desc "Updae messages"                   "u" #'slack-room-update-messages
      :desc "Insert emoji"                     "e" #'slack-insert-emoji
      :desc "Embed mention"                    "2" #'slack-message-embed-mention
      :desc "Embed channel"                    "3" #'slack-message-embed-channel)))

(use-package alert
 :commands (alert)
 :init
  (setq alert-default-style 'libnotify))


(setq slack-buffer-create-on-notify nil)

; ;;; Channels
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


(defun jb/decorate-text (text)
  (let* ((decorators '(("None" . (lambda (text) text))
                       ("Code"  . (lambda (text) (concat "```" text "```")))))
         (decoration (completing-read "Select decoration: "
                                      decorators
                                      nil
                                      t)))
    (funcall (cdr (assoc decoration decorators)) text)))

(defun as/send-region-to-slack ()
  (interactive)
  (let* ((team (slack-team-select))
         (room (slack-room-select
                (cl-loop for team in (list team)
                         append (with-slots (groups ims channels) team
                                  (append ims groups channels)))
                team)))
    (slack-message-send-internal (jb/decorate-text (filter-buffer-substring
                                                    (region-beginning) (region-end)))
                                 room
                                 team)))

(defun as/slack-select-unread-mentions ()
  (interactive)
  (let* ((team (slack-team-select))
         (room (slack-room-select
                (cl-loop for team in (list team)
                         append (with-slots (groups ims) team
                                  (cl-remove-if
                                   #'(lambda (room)
                                       (not (slack-room-has-unread-p room team)))
                                   (append ims groups))))
                team)))
    (slack-room-display room team)))


;; Control where slack drops its new window

(defun as/slack-switch-to-buffer
  (treemacs--setup-buffer)
  (switch-to-buffer))


(setq slack-buffer-function #'switch-to-buffer)
