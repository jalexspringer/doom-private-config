;;; ~/.doom.d/+org.el -*- lexical-binding: t; -*-

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
