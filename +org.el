;;; ~/.doom.d/+org.el -*- lexical-binding: t; -*-

(setq org-clock-idle-time 10)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-directory (expand-file-name "~/org/")
      org-agenda-files (list org-directory)
      org-bullet-bullet-list '("#"))
(setq org-agenda-persistent-filter t)

(defvar +org-capture-todo-file "home.org"
  "Default target for todo entries.

Is relative to `org-directory', unless it is absolute. Is used in Doom's default
`org-capture-templates'.")

(defvar +org-capture-notes-file "notes.org"
  "Default target for storing notes.

Used as a fall back file for org-capture.el, for templates that do not specify a
target file.

Is relative to `org-directory', unless it is absolute. Is used in Doom's default
`org-capture-templates'.")

(setq org-refile-targets '((org-agenda-files . (:maxlevel . 3))))

(setq org-capture-templates
      '(("t" "Todo" entry
         (file+headline +org-capture-todo-file "Tasks")
         "* TODO %?%^g\n%i"
         :prepend t :kill-buffer t :clock-in t :clock-resume t)
        ;; ("f" "Flux7 todo" entry
        ;;  (file+headline +org-capture-todo-file "Flux Tasks")
        ;;  "* TODO %? :f7:\n%i" :prepend t :kill-buffer t)
        ;; ("i" "Impact todo" entry
        ;;  (file+headline +org-capture-todo-file "Impact Tasks")
        ;;  "* TODO %? :impact:\n%i" :prepend t :kill-buffer t)

        ("l" "Lik" entry
         (file+headline +org-capture-todo-file "Links")
         "*%^g %?\n%i" :prepend t :kill-buffer t)

        ("a" "Ar" entry
         (file+headline +org-capture-todo-file "Articles")
         "* TOREAD %?\n%i" :prepend t :kill-buffer t)

        ("c" "Ciet" entry
         (file+headline +org-capture-todo-file "Clients")
         (file "/home/jalexspringer/.doom.d/templates/client.orgcaptmpl")
         :prepend t :kill-buffer t :clock-in t :clock-resume t)
        ;; ("ci" "IClient" entry
        ;;  (file+headline +org-capture-todo-file "impact")
        ;;  (file "/home/jalexspringer/.doom.d/templates/iclient.orgcaptmpl") :prepend t :kill-buffer t)
        ;; ("cf" "FClient" entry
        ;;  (file+headline +org-capture-todo-file "flux7")
        ;;  (file "/home/jalexspringer/.doom.d/templates/fclient.orgcaptmpl") :prepend t :kill-buffer t)

        ("n" "Notes" entry
         (file+headline +org-capture-todo-file "Notes")
         "* %u %?\n%i" :prepend t :kill-buffer t :clock-in t :clock-resume t)))
;
;
;
; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("F7" . ?f)
                            ("IM" . ?i)
                            ("ME" . ?m)
                            (:endgroup)
                            ("WAITING" . ?w)
                            ("PERSONAL" . ?P)
                            ("WORK" . ?W)
                            ("CANCELLED" . ?c)
                            ("FLAGGED" . ??))))

; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

(add-hook 'org-load-hook #'+org-private|setup-keybinds t)

(defun +org-private|setup-keybinds ()
  (map!
   (:after evil-org
     (:map evil-org-mode-map
       :nm "t" #'org-todo
       :nm "r" #'org-refile
       :nm "s" #'org-schedule
       (:localleader
         :nm "SPC" #'org-set-tags
         )))
   (:after org-agenda
     (:map org-agenda-mode-map
       :nm "t" #'org-agenda-todo
       :nm "d" #'org-agenda-deadline
       :nm "s" #'org-agenda-schedule
       ))
   )
 )

