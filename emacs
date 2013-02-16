;;Checkout the latest version of org mode, if I don't already have it.
(unless (file-exists-p "~/.emacs.d/elisp/org-mode/")
  (let ((default-directory "~/.emacs.d/elisp/"))
    (shell-command "git clone git://orgmode.org/org-mode.git")
    (shell-command "cd org-mode && make && make doc && make install")
    (normal-top-level-add-subdirs-to-load-path)))
(add-to-list 'load-path "~/.emacs.d/elisp/org-mode/lisp/")
(add-to-list 'load-path "~/.emacs.d/elisp/org-mode/contrib/lisp/")
(add-to-list 'load-path "~/.emacs.d/elisp/packages/")
(add-to-list 'exec-path "/usr/local/bin/")
(add-to-list 'exec-path "/usr/bin/")

(require 'org-install)
(mouse-wheel-mode t)

(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
;; Either the Key ID or set to nil to use symmetric encryption.
(setq org-crypt-key nil)

(require 'deft)
(setq deft-extension "txt")
(setq deft-directory "~/Dropbox/notes/simplenotes")
(setq deft-text-mode 'markdown-mode)
(setq deft-use-filename-as-title t)
(global-set-key [f8] 'deft)

;; spellcheck in LaTex mode
(add-hook `latex-mode-hook `flyspell-mode)
(add-hook `tex-mode-hook `flyspell-mode)
(add-hook `bibtex-mode-hook `flyspell-mode)

;; Show line-number and column-number in the mode line
(line-number-mode 1)
(column-number-mode 1)


(load "pandoc-mode")
(add-hook 'markdown-mode-hook 'turn-on-pandoc)

(require 'yasnippet-bundle)
(require 'midnight)

(setq load-path (cons "~/.emacs.d/elisp/org2blog/" load-path))
(require 'org2blog)

(setq load-path (cons "~/.emacs.d/elisp/emacs-w3m/" load-path))
(require 'w3m-load)

(savehist-mode t)
(global-hl-line-mode t)

(add-to-list 'load-path "~/.emacs.d/elisp/color-theme/")
(require 'color-theme)
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme/themes")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme/themes/emacs-color-theme-solarized")
(require 'color-theme-solarized)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-calm-forest)))
(setq my-color-themes (list 'color-theme-tango-2 'color-theme-zen-and-art 
'color-theme-calm-forest 'color-theme-andreas 'color-theme-bharadwaj-slate 
'color-theme-subdued 'color-theme-gruber-darker 'color-theme-less 'color-theme-railscasts 
'color-theme-xp 'color-theme-xemacs 'color-theme-retro-orange 'color-theme-solarized-light 
'color-theme-solarized-dark))

(load "ebib.el")
(load "org-mac-iCal.el")
(load "word-count.el")
(load "org-wc.el")
(load "xml-rpc")
(load "write-or-die")
(load "copypaste.el")
(load "markdown-mode.el")
(load "org-export-generic.el")
(load "markdown.el")
(load "nyan-mode.el")
(load "pomodoro.el")

(load "jekyll_blay.el")
(load "jekyll_alt.el")

 (global-set-key (kbd "C-c j b n") 'jekyll-blay-draft-post)
 (global-set-key (kbd "C-c j b p") 'jekyll-blay-publish-post)
 (global-set-key (kbd "C-c j b l") (lambda ()
                                   (interactive)
                                   (find-file "~/notes/blog/_posts/")))
 (global-set-key (kbd "C-c j b d") (lambda ()
                                   (interactive)
                                   (find-file "~/notes/blog/_drafts/")))

 (global-set-key (kbd "C-c j a n") 'jekyll-alt-draft-post)
 (global-set-key (kbd "C-c j a p") 'jekyll-alt-publish-post)
 (global-set-key (kbd "C-c j a l") (lambda ()
                                   (interactive)
                                   (find-file "~/notes/alt/_posts/")))
 (global-set-key (kbd "C-c j a d") (lambda ()
                                   (interactive)
                                   (find-file "~/notes/alt/_drafts/")))



(setq org-agenda-include-diary t)

  ;; The following lines are always needed.  Choose your own keys.
     (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
     (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
     (add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
     (global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cb" 'org-iswitchb)

(define-key global-map "\C-cc" 'org-capture)
(define-key org-mode-map (kbd "C-c )") 'reftex-citation)

(global-set-key [f5] 'org-agenda)
(global-set-key [f6] 'org-capture)

(global-set-key [kp-ydelete] 'delete-char)
(defalias 'full 'ns-toggle-fullscreen)

(global-set-key "\C-f" 'forward-paragraph)
(global-set-key "\C-b" 'backward-paragraph)

(global-set-key "\C-\M-p" 'enlarge-window-horizontally)
(global-set-key "\C-\M-o" 'shrink-window-horizontally)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(diary-file "~/notes/calendar")
 '(fringe-mode 0 nil (fringe))
 '(org-agenda-file-regexp "\\`[^.].*\\.org\\'")
 '(org-agenda-files (quote ("~/notes/")))
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday 1)
 '(org-deadline-warning-days 9)
 '(org-default-notes-file "~/notes/notes.org")
 '(org-directory "~/notes")
 '(org-footnote-auto-adjust t)
 '(org-footnote-auto-label t)
 '(org-habit-graph-column 57)
 '(org-log-done (quote time))
 '(org-log-into-drawer t)
 '(org-log-refile (quote note))
 '(org-modules (quote (org-bbdb org-bibtex org-docview org-gnus org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m)))
 '(org-refile-allow-creating-parent-nodes (quote confirm))
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 3) (nil :maxlevel . 3))))
 '(org-refile-use-outline-path (quote file))
 '(org-return-follows-link t)
 '(org2blog-confirm-post t)
 '(reftex-cite-format "[@%l]")
 '(reftex-default-bibliography (quote ("~/Dropbox/mendeley_mac/library.bib")))
 '(scroll-bar-mode nil)
 '(sentence-end-double-space nil)
 '(tool-bar-mode nil)
 '(transient-mark-mode (quote (only . t)))
 '(write-or-die-grace-period 10)
 '(x-select-enable-clipboard t))

(setq visible-bell 1)
(menu-bar-mode 0)

(require 'framemove)
    (windmove-default-keybindings 'shift)
    (setq framemove-hook-into-windmove t)

	(global-set-key [\C-\M-left] 'windmove-left)
	(global-set-key [\C-\M-right] 'windmove-right)
	(global-set-key [\C-\M-up] 'windmove-up)
	(global-set-key [\C-\M-down] 'windmove-down)


(when (locate-library "no-word")
  (require 'no-word)
  (add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word)))


(setq org-todo-keywords
'(
  (sequence "TODO(t)" "NEXT(n)" "STARTED(s@/!)" "|" "DONE(d!)" )
  (sequence "WAITING(w@/!)" "DELEGATED(e@/!)" "|" "SOMEDAY(x)" "CANCELED(c@/!)" )
  (sequence "INBOX")
 )
)


(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")


(setq mac-option-modifier 'none)
(setq mac-command-modifier 'meta)
(setq default-directory "~/notes/" )

(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

(eval-after-load "org"
  '(progn
     (define-prefix-command 'org-todo-state-map)

     (define-key org-mode-map "\C-cx" 'org-todo-state-map)

     
 
     (define-key org-todo-state-map "c"
       #'(lambda nil (interactive) (org-todo "CANCELED")))
     (define-key org-todo-state-map "n"
       #'(lambda nil (interactive) (org-todo "NEXT")))
     (define-key org-todo-state-map "s"
       #'(lambda nil (interactive) (org-todo "STARTED")))
     (define-key org-todo-state-map "w"
       #'(lambda nil (interactive) (org-todo "WAITING")))
     (define-key org-todo-state-map "l"
       #'(lambda nil (interactive) (org-todo "DELEGATED")))
     (define-key org-todo-state-map "d"
       #'(lambda nil (interactive) (org-todo "DONE")))
     (define-key org-todo-state-map "x"
       #'(lambda nil (interactive) (org-todo "SOMEDAY")))
							))	
							
							
(setq org-agenda-custom-commands '(

 ("d" "Daily schedule" agenda ""
        			 ((org-agenda-ndays 1)
    				 ))  
        	
 ("x" "Unprocessed"
 	(
    (tags-todo "inbox" nil)

    (tags-todo "FLAGGED" nil)
    
    (todo "STARTED" 
     				 ((org-agenda-overriding-header "STARTED ACTION (UNSCHEDULED)") 
     				 (org-agenda-skip-function (quote (org-agenda-skip-subtree-if (quote scheduled))))
     				 ))
     (todo "NEXT" 
     				 ((org-agenda-overriding-header "NEXT ACTION (UNSCHEDULED)") 
     				 (org-agenda-skip-function (quote (org-agenda-skip-subtree-if (quote scheduled))))
     				 ))
     (todo "WAITING" 
     				 ((org-agenda-overriding-header "WAITING TASKS")
     				 ))
	 (alltodo "" 
	 				 ((org-agenda-overriding-header "STUCK WITH DEADLINE") 
	 				 (org-agenda-skip-function (quote (org-agenda-skip-entry-if (quote scheduled) (quote notdeadline))))
	 				 ))

	 (tags-todo "-#hold"
                     ((org-agenda-skip-function 'bh/skip-non-stuck-projects)
                     (org-agenda-overriding-header "STUCK PROJECTS")
                     ))
     (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)))
				))
 ("v" "Birds eye view" 
 	(
 	 (alltodo ""
                     ((org-agenda-skip-function 'bh/skip-non-projects)
                     (org-agenda-overriding-header "PROJECTS")
                     ))
 	 (agenda "" 
	 				 ((org-agenda-time-grid nil)
                  	 (org-deadline-warning-days 365)        
                   	 (org-agenda-entry-types '(:deadline))
                   	 (org-agenda-include-diary nil)
                   	 (org-agenda-ndays 1) 
     			   	 (org-agenda-start-on-weekday 1)
     			  	 (org-agenda-overriding-header "DEADLINES")       
                   	 ))	
	 (agenda "" 
 					 ((org-agenda-span 21)
 					 (org-agenda-overriding-header "21 DAYS") 
 					 ))
 					                
 				)) 
 ("c" "Tasks to be archived" todo "DONE|SOMEDAY|CANCELED" nil)  

  ))

							
(defun bh/is-project-p ()
  "Any task with a todo keyword subtask"
  (let ((has-subtask)
        (subtree-end (save-excursion (org-end-of-subtree t))))
    (save-excursion
      (forward-line 1)
      (while (and (not has-subtask)
                  (< (point) subtree-end)
                  (re-search-forward "^\*+ " subtree-end t))
        (when (member (org-get-todo-state) org-todo-keywords-1)
          (setq has-subtask t))))
    has-subtask))

(defun bh/is-project-p-with-open-subtasks ()
  "Any task with a todo keyword subtask"
  (let ((has-subtask)
        (subtree-end (save-excursion (org-end-of-subtree t))))
    (save-excursion
      (forward-line 1)
      (while (and (not has-subtask)
                  (< (point) subtree-end)
                  (re-search-forward "^\*+ " subtree-end t))
        (when (and
               (member (org-get-todo-state) org-todo-keywords-1)
               (not (member (org-get-todo-state) org-done-keywords)))
          (setq has-subtask t))))
    has-subtask))
							
(defun bh/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
         
         (has-next (save-excursion
                     (forward-line 1)
                     (and (< (point) subtree-end)
                          (re-search-forward "^\\*+ \\(NEXT\\|STARTED\\) "
                                             subtree-end t))))
          
                                             
                                             )
    (if (and (bh/is-project-p) (not has-next))
        nil ; a stuck project, has subtasks but no next task
      subtree-end)))						
					
(defun bh/skip-non-projects ()
  "Skip trees that are not projects"
  (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (bh/is-project-p)
        nil
      subtree-end)))

(defun bh/skip-projects ()
  "Skip trees that are projects"
  (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (bh/is-project-p)
        subtree-end
      nil)))


(defun bh/skip-non-archivable-tasks ()
  "Skip trees that are not available for archiving"
  (let ((next-headline (save-excursion (outline-next-heading))))
    ;; Consider only tasks with done todo headings as archivable candidates
    (if (member (org-get-todo-state) org-done-keywords)
        (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
               (daynr (string-to-int (format-time-string "%d" (current-time))))
               (a-month-ago (* 60 60 24 (+ daynr 1)))
               (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
               (this-month (format-time-string "%Y-%m-" (current-time)))
               (subtree-is-current (save-excursion
                                     (forward-line 1)
                                     (and (< (point) subtree-end)
                                          (re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
          (if subtree-is-current
              subtree-end ; Has a date in this month or last month, skip it
            nil))  ; available to archive
      (or next-headline (point-max)))))  



							
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/notes/gtd.org" "INBOX")
         "* TODO %?\n  %i\n" :prepend t)
        ("n" "Note" entry (file+datetree "~/notes/notes.org")
         "* %? :NOTE:  \n\n\#\#\#\n%i\n\nEntered on %U\n  \n  Why do I note this?\n  \"\"\n" :prepend t)))




(setq org-enforce-todo-dependencies t)
(setq org-agenda-dim-blocked-tasks t)


    (defun my-theme-set-default () ; Set the first row
      (interactive)
      (setq theme-current my-color-themes)
      (funcall (car theme-current)))
     
    (defun my-describe-theme () ; Show the current theme
      (interactive)
      (message "%s" (car theme-current)))
     
   ; Set the next theme (fixed by Chris Webber - tanks)
    (defun my-theme-cycle ()		
      (interactive)
      (setq theme-current (cdr theme-current))
      (if (null theme-current)
      (setq theme-current my-color-themes))
      (funcall (car theme-current))
      (message "%S" (car theme-current)))
    
    (setq theme-current my-color-themes)
    (setq color-theme-is-global t) ; Initialization
    (my-theme-set-default)
    (global-set-key (kbd "C-c t") 'my-theme-cycle)


;; Turn off the annoying default backup behaviour
(if (file-directory-p "~/.emacs.d/backups")
    (setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
  (message "Directory does not exist: ~/.emacs.d/backups"))


;;; Don't quit unless you mean it!
(defun maybe-save-buffers-kill-emacs (really)
"If REALLY is 'yes', call save-buffers-kill-emacs."
 (interactive "sAre you REALLY sure you want to quit Emacs? ")
  (if (equal really "yes")
   (save-buffers-kill-emacs)
  )
)
(global-set-key [(control x)(control c)] 'maybe-save-buffers-kill-emacs) 

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(set-face-attribute 'default nil :font "monospace-11")


