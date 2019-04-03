;;; ~/.doom.d/+org.el -*- lexical-binding: t; -*-
(after! org
(set-register ?o (cons 'file "~/org/home.org"))
(setq org-image-actual-width '(650))
(setq org-clock-idle-time 10)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-directory (expand-file-name "~/org/")
      org-agenda-files (list org-directory)
      org-bullet-bullet-list '("#"))
(setq org-agenda-persistent-filter t)
(setq org-archive-location "archives/%s_archive::")


;; EXPORT SETTINGS
(setq org-export-preserve-breaks nil)
(setq org-export-with-toc nil)
(setq org-export-with-section-numbers nil)

(defvar +jas/org-capture-todo-file "home.org"
  "Default target for todo entries.

Is relative to `org-directory', unless it is absolute. Is used in Doom's default
`org-capture-templates'.")

(defvar +jas/org-capture-notes-file "notes.org"
  "Default target for storing notes.

Used as a fall back file for org-capture.el, for templates that do not specify a
target file.

Is relative to `org-directory', unless it is absolute. Is used in Doom's default
`org-capture-templates'.")

(setq org-refile-targets '((org-agenda-files . (:maxlevel . 3))))

(setq org-capture-templates
      '(("t" "Todo" entry
         (file+headline +jas/org-capture-todo-file "Tasks")
         "* TODO %?\n%i\n%a"
         :prepend t :clock-in t :clock-resume t)

        ("l" "Lik" entry
         (file+headline +jas/org-capture-todo-file "Links")
         "* %?\n%i" :prepend t)

        ("a" "Ar" entry
         (file+headline +jas/org-capture-todo-file "Articles")
         "* TOREAD %?\n%i" :prepend t)

        ("c" "Ciet" entry
         (file+headline +jas/org-capture-todo-file "Clients")
         (file "/home/jalexspringer/.doom.d/templates/client.orgcaptmpl")
         :prepend t :clock-in t :clock-resume t)

        ("n" "Notes" entry
         (file+headline +jas/org-capture-todo-file "Notes")
         "* %u %?\n%i" :prepend t :clock-in t :clock-resume t)))
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

;; start directory
;;
(defvar jas/google-image-dir (expand-file-name "/mnt/chromeos/GoogleDrive/MyDrive/Google Photos/2019"))
(defvar jas/screenshot-image-dir (expand-file-name "/mnt/chromeos/GoogleDrive/MyDrive/Screenshots"))
;; (defvar jas/screenshot-image-dir (expand-file-name "/mnt/chromeos/MyFiles/Screenshots"))

(defun jas/insert-google-image ()
  "Insert image from conference directory, rename and add link in current file.

The file is taken from a start directory set by `jas/google-image-dir' and moved to the current directory, renamed and embedded at the point as an org-mode link. The user is presented with a list of files in the start directory, from which to select the file to move, sorted by most recent first."
  (interactive)
  (let (file-list target-dir file-list-sorted start-file start-file-full file-ext end-file end-file-base end-file-full file-number)
    ;; clean directories from list but keep times
    (setq file-list
          (-remove (lambda (x) (nth 1 x))
                   (directory-files-and-attributes jas/google-image-dir)))

    ;; get target directory
    (setq target-dir (file-name-directory (buffer-file-name)))

    ;; sort list by most recent
  ;; http://stackoverflow.com/questions/26514437/emacs-sort-list-of-directories-files-by-modification-date
  (setq file-list-sorted
        (mapcar #'car
                (sort file-list
                      #'(lambda (x y) (time-less-p (nth 6 y) (nth 6 x))))))

  ;; use ivy to select start-file
  (setq start-file (ivy-read
                    (concat "Move selected file to " target-dir ":")
                    file-list-sorted
                    :re-builder #'ivy--regex
                    :sort nil
                    :initial-input nil))

  ;; add full path to start file and end-file
  (setq start-file-full
        (expand-file-name start-file jas/google-image-dir))
  ;; generate target file name from current org section
  ;; (setq file-ext (file-name-extension start-file t))

  ;; my phone app doesn't add an extension to the image so I do it
  ;; here. If you want to keep the existing extension then use the
  ;; line above
  (setq file-ext ".jpg")
  ;; get section heading and clean it up
  (setq end-file-base (s-downcase (s-dashed-words (nth 4 (org-heading-components)))))
  ;; shorten to first 40 chars to avoid long file names
  (setq end-file-base (s-left 40 end-file-base))
  ;; set nexted folder for attachments
  (setq end-file-folder ".attach/")
  ;; number to append to ensure unique name
  (setq file-number 1)
  (setq end-file (concat
                  end-file-base
                  (format "-%s" file-number)
                  file-ext))

  ;; increment number at end of name if file exists
  (while (file-exists-p end-file)
    ;; increment
    (setq file-number (+ file-number 1))
    (setq end-file (concat
                    end-file-folder
                    end-file-base
                    (format "-%s" file-number)
                    file-ext))
    (setq end-attach-file (concat
                    end-file-base
                    (format "-%s" file-number)
                    file-ext))
    )

  ;; final file name including path
  (setq end-file-full
        (expand-file-name end-file target-dir))
  ;; rename file
  (rename-file start-file-full end-file-full)
  (message "moved %s to %s" start-file-full end-file)
  ;; insert link
  (insert (org-make-link-string (format "attach:%s" end-attach-file)))
  ;; display image
  (org-display-inline-images t t)))


;; screenshots from downloads folder
;;

(defun jas/insert-screenshot ()
  "Insert image from conference directory, rename and add link in current file.

The file is taken from a start directory set by `jas/screenshot-image-dir' and moved to the current directory, renamed and embedded at the point as an org-mode link. The user is presented with a list of files in the start directory, from which to select the file to move, sorted by most recent first."
  (interactive)
  (let (file-list target-dir file-list-sorted start-file start-file-full file-ext end-file end-file-base end-file-full file-number)
    ;; clean directories from list but keep times
    (setq file-list
          (-remove (lambda (x) (nth 1 x))
                   (directory-files-and-attributes jas/screenshot-image-dir)))

    ;; get target directory
    (setq target-dir (file-name-directory (buffer-file-name)))

    ;; sort list by most recent
  ;; http://stackoverflow.com/questions/26514437/emacs-sort-list-of-directories-files-by-modification-date
  (setq file-list-sorted
        (mapcar #'car
                (sort file-list
                      #'(lambda (x y) (time-less-p (nth 6 y) (nth 6 x))))))

  ;; use ivy to select start-file
  (setq start-file (ivy-read
                    (concat "Move selected file to " target-dir ":")
                    file-list-sorted
                    :re-builder #'ivy--regex
                    :sort nil
                    :initial-input nil))

  ;; add full path to start file and end-file
  (setq start-file-full
        (expand-file-name start-file jas/screenshot-image-dir))
  ;; generate target file name from current org section
  ;; (setq file-ext (file-name-extension start-file t))

  ;; my phone app doesn't add an extension to the image so I do it
  ;; here. If you want to keep the existing extension then use the
  ;; line above
  (setq file-ext ".jpg")
  ;; get section heading and clean it up
  (setq end-file-base (s-downcase (s-dashed-words (nth 4 (org-heading-components)))))
  ;; shorten to first 40 chars to avoid long file names
  (setq end-file-base (s-left 40 end-file-base))
  ;; set nexted folder for attachments
  (setq end-file-folder ".attach/")
  ;; number to append to ensure unique name
  (setq file-number 1)
  (setq end-file (concat
                  end-file-base
                  (format "-%s" file-number)
                  file-ext))

  ;; increment number at end of name if file exists
  (while (file-exists-p end-file)
    ;; increment
    (setq file-number (+ file-number 1))
    (setq end-file (concat
                    end-file-folder
                    end-file-base
                    (format "-%s" file-number)
                    file-ext))
    (setq end-attach-file (concat
                    end-file-base
                    (format "-%s" file-number)
                    file-ext))
    )

  ;; final file name including path
  (setq end-file-full
        (expand-file-name end-file target-dir))
  ;; rename file
  (rename-file start-file-full end-file-full)
  (message "moved %s to %s" start-file-full end-file)
  ;; insert link
  (insert (org-make-link-string (format "attach:%s" end-attach-file)))
  ;; display image
  (org-display-inline-images t t)))
)
