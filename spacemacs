;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(
     html
     yaml
     ruby
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     ;; auto-completion
     ;; better-defaults
     emacs-lisp
     ;; git
        markdown
        org
        osx
        pandoc
        bibtex
   ;     react
;        mu4e
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
        spell-checking
     ;; syntax-checking
        themes-megapack
        ;; version-control
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(
                                      org-beautify-theme
                                      faff-theme
                                      org-wc
                                      )
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '(
                                    vi-tilde-fringe
                                    firebelly-theme
                                    niflheim-theme
                                    pastels-on-dark-theme
                                    tronesque-theme
                                    zonokai-theme
                                    )
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'. (default t)
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. (default t)
   dotspacemacs-check-for-update t
   ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
   ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
   ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
   ;; unchanged. (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'.
   ;; (default '(recents projects))
   dotspacemacs-startup-lists '(recents projects)
   ;; Number of recent files to show in the startup buffer. Ignored if
   ;; `dotspacemacs-startup-lists' doesn't include `recents'. (default 5)
   dotspacemacs-startup-recent-list-size 5
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(dracula
                         spacegray
                         gruvbox
                         spacemacs-dark
                         faff
                         )
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 11
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; (Not implemented) dotspacemacs-distinguish-gui-ret nil
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; If non nil `Y' is remapped to `y$'. (default t)
   dotspacemacs-remap-Y-to-y$ t
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers t
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  (setq wttrin-default-cities '("Stockholm" "Tokyo" "Gothenburg"))

  ;; Org image width
  (setq org-image-actual-width 500)
  (setq-default org-download-image-dir "~/notes/img")

;; Open from terminal in same window
  (setq ns-pop-up-frames nil)
  
;; osx
 (setq-default dotspacemacs-configuration-layers '(
   (osx :variables osx-use-option-as-meta nil)))
  )
;; Escape with kj
(setq-default evil-escape-key-sequence "kj")

;; Right option not as meta
(setq-default mac-right-option-modifier nil)

(global-set-key "\C-l" 'helm-do-grep-ag)
(global-set-key "\C-ö" 'flyspell-correct-previous-word-generic)

;; Spell auto-dictionary
(setq-default dotspacemacs-configuration-layers
              '((spell-checking :variables spell-checking-enable-auto-dictionary t)))
(add-hook 'flyspell-mode-hook (lambda () (auto-dictionary-mode 1)))

;; Markdown mode for text files
(add-to-list 'auto-mode-alist '("\\.txt\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.md$" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\org.txt\\'" . org-mode))

;; Global mode defaults
(global-visual-line-mode 1)

;; overwrite selected text
(delete-selection-mode t)

(setq-default helm-buffer-max-length 60)

;;; Set up some common mu4e variables
;;; (with-eval-after-load 'mu4e
;;; (setq mu4e-maildir "~/.mail")
;;; (setq mu4e-headers-skip-duplicates t)
;;; (setq mu4e-sent-messages-behavior 'delete)
;;; (setq mu4e-change-filenames-when-moving t)
;;; (setq mu4e-attachments-dir "~/Downloads/Attachments")
;;; (add-to-list 'mu4e-bookmarks
;;;              '("size:5M..500M"       "Big messages"     ?b))
;;; 
;;; (setq mu4e-get-mail-command "/usr/local/bin/mbsync -a")
;;; (setq mu4e-html2text-command "/usr/local/bin/w3m -T text/html")
;;; (add-to-list 'mu4e-view-actions
;;;              '("ViewInBrowser" . mu4e-action-view-in-browser) t)
;;; 
;;; (setq mu4e-show-images t)
;;; (when (fboundp 'imagemagick-register-types)
;;;   (imagemagick-register-types))
;;; 
;;; (setq message-send-mail-function 'message-send-mail-with-sendmail)
;;; (setq sendmail-program "/usr/local/bin/msmtp")
;;; (setq smtpmail-queue-mail t  ;; start in queuing mode
;;;       smtpmail-queue-dir   "~/.mail/queue/cur")
;;; (setq message-sendmail-extra-arguments '("--read-envelope-from"))
;;; (setq message-sendmail-f-is-evil 't)
;;; (setq message-kill-buffer-on-exit t)
;;; (setq smtpmail-debug-info t)
;;; 
;;; ;;store link to message if in header view, not to header query
;;; (setq org-mu4e-link-query-in-headers-mode nil)
;;; 
;;; (setq mu4e-maildir-shortcuts
;;;       '( ("/tii/inbox"               . ?i)
;;;          ))
;;; )

;; Bibtex

(setq org-ref-default-bibliography '("~/Dropbox/bibtex/lib.bib")
      org-ref-pdf-directory "~/Documents/library/papers/"
      org-ref-bibliography-notes "~/notes/org/notes.org")

(setq bibtex-completion-pdf-field "file")

;; Org-mode setup
(with-eval-after-load 'org

(setq org-agenda-files (quote ("~/notes/org")))

;; Move paragraphs
(global-set-key "\C-j" 'forward-paragraph)
(global-set-key "\C-k" 'backward-paragraph)

;; Nice Bullets
(setq-default org-bullets-bullet-list '("◉" "○" "▶" "▶" "▶" "▶" ))

; Depth level for refile
(setq org-refile-targets
      '((org-agenda-files . (:maxlevel . 6))))

(setq reftex-cite-format "[@%l]")

(setq org-agenda-skip-deadline-if-done t)
(setq org-deadline-warning-days 14)
(setq org-enforce-todo-dependencies t)

(setq org-todo-keywords
      '((sequence "TODO" "NEXT" "|" "DONE" )))

(setq org-agenda-exporter-settings
      '((ps-number-of-columns 2)
        (ps-landscape-mode t)
        (org-agenda-add-entry-text-maxlines 5)
        (htmlize-output-type 'css)))

; Custom Agenda Commands

;; Disable default stuck projects
(setq org-stuck-projects (quote ("" nil nil "")))

(setq org-agenda-custom-commands '(
                                   ("d" "Daily Schedule"
                                   (
                                    (agenda "" (
                                    (org-agenda-overriding-header "Scheduled Today") 
                                    (org-agenda-ndays 1)
                                    (org-agenda-span 'day)
                                    (org-agenda-entry-types '(:scheduled))
                                     ))
                                    (agenda "" (
                                     (org-agenda-overriding-header "Deadlines 7 Days") 
                                     (org-agenda-entry-types '(:deadline))
                                     (org-agenda-ndays 1)
                                     (org-agenda-span 'day)
                                     (org-deadline-warning-days 12)
                                     (org-agenda-time-grid nil)
                                     (org-agenda-dim-blocked-tasks t)
                                     ))
                                    (tags "PRIORITY=\"A\"\"" (
                                                   (org-agenda-overriding-header "Priority Tasks")
                                                   ))
                                    (tags-todo "-noagenda/!NEXT" (
                                                                  (org-agenda-overriding-header "Next Tasks")
                                                                  ))
                                     ))
                                   ("p" "Project Overview"
                                    (
                                     (agenda "" (
                                                 (org-agenda-overriding-header "Scheduled Today") 
                                                 (org-agenda-ndays 1)
                                                 (org-agenda-span 'week)
                                                 (org-agenda-entry-types '(:scheduled))
                                                 ))
                                     (agenda "" (
                                                 (org-agenda-overriding-header "Deadlines 30 Days")
                                                 (org-agenda-entry-types '(:deadline))
                                                 (org-agenda-ndays 1)
                                                 (org-agenda-start-on-weekday 0)  
                                                 (org-deadline-warning-days 30)
                                                 (org-agenda-time-grid nil)
                                                 (org-agenda-dim-blocked-tasks t)
                                                             ))
                                     (tags-todo "-DONE/!"
                                                ((org-agenda-overriding-header "Stuck Projects")
                                                 (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                                                 ))
                                     (tags-todo "-DONE/!"
                                                  ((org-agenda-overriding-header "Projects")
                                                   (org-agenda-skip-function 'bh/skip-non-projects)
                                                   (org-tags-match-list-sublevels 'indented)
                                                   (org-agenda-sorting-strategy
                                                   '(category-keep))))
                                     ))
                                   ))

;; Define Projects
(defun bh/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task has-subtask))))


(defun bh/skip-non-projects ()
  "Skip trees that are not projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (if (save-excursion (bh/skip-non-stuck-projects))
      (save-restriction
        (widen)
        (let ((subtree-end (save-excursion (org-end-of-subtree t))))
          (cond
           ((bh/is-project-p)
            nil)
           ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
            nil)
           (t
            subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun bh/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                              (point))))
    (save-excursion
      (bh/find-project-task)
      (if (equal (point) task)
          nil
        t))))

(defun bh/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun bh/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun bh/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next ))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                next-headline
              nil)) ; a stuck project, has subtasks but no next task
        next-headline))))



)
;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#5f5f5f" "#ff4b4b" "#a1db00" "#fce94f" "#5fafd7" "#d18aff" "#afd7ff" "#ffffff"])
 '(compilation-message-face (quote default))
 '(evil-want-Y-yank-to-eol t)
 '(fci-rule-color "#343d46" t)
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-tail-colors
   (quote
    (("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100))))
 '(magit-diff-use-overlays nil)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages
   (quote
    (darkroom olivetti writeroom-mode visual-fill-column org-beautify-theme alert autothemer bind-key powerline spinner org hydra projectile anzu iedit smartparens bind-map highlight undo-tree helm helm-core async markdown-mode ht dash s uuidgen request pug-mode osx-dictionary org-ref key-chord ivy org-projectile org-download mu4e-maildirs-extension mu4e-alert livid-mode skewer-mode simple-httpd link-hint hide-comnt helm-bibtex parsebib flyspell-correct-helm flyspell-correct eyebrowse evil-visual-mark-mode evil-unimpaired evil-ediff dumb-jump f darkokai-theme column-enforce-mode biblio biblio-core vi-tilde-fringe zonokai-theme zenburn-theme zen-and-art-theme wttrin ws-butler window-numbering which-key web-mode web-beautify volatile-highlights use-package underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tronesque-theme toxi-theme toc-org tern tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit sunny-day-theme sublime-themes subatomic256-theme subatomic-theme stekene-theme spacemacs-theme spaceline spacegray-theme soothe-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smooth-scrolling slim-mode seti-theme scss-mode sass-mode reverse-theme reveal-in-osx-finder restart-emacs rainbow-delimiters railscasts-theme quelpa purple-haze-theme professional-theme popwin planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme persp-mode pcre2el pbcopy pastels-on-dark-theme paradox pandoc-mode page-break-lines ox-pandoc osx-trash organic-green-theme org-repo-todo org-present org-pomodoro org-plus-contrib org-bullets open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme niflheim-theme neotree naquadah-theme mustang-theme move-text monokai-theme monochrome-theme molokai-theme moe-theme mmm-mode minimal-theme material-theme markdown-toc majapahit-theme macrostep lush-theme lorem-ipsum linum-relative light-soap-theme leuven-theme less-css-mode launchctl json-mode js2-refactor js-doc jbeans-theme jazz-theme jade-mode ir-black-theme inkpot-theme info+ indent-guide ido-vertical-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation heroku-theme hemisu-theme help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make helm-flyspell helm-flx helm-descbinds helm-css-scss helm-ag hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme google-translate golden-ratio gnuplot gh-md gandalf-theme flx-ido flatui-theme flatland-theme firebelly-theme fill-column-indicator farmhouse-theme fancy-battery expand-region exec-path-from-shell evil-visualstar evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-args evil-anzu eval-sexp-fu espresso-theme emmet-mode elisp-slime-nav dracula-theme django-theme define-word darktooth-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme colorsarenice-theme color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized coffee-mode clues-theme clean-aindent-mode cherry-blossom-theme busybee-theme buffer-move bubbleberry-theme bracketed-paste birds-of-paradise-plus-theme badwolf-theme auto-highlight-symbol auto-dictionary auto-compile apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes aggressive-indent afternoon-theme adaptive-wrap ace-window ace-link ace-jump-helm-line)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(pos-tip-background-color "#A6E22E")
 '(pos-tip-foreground-color "#272822")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#bf616a")
     (40 . "#DCA432")
     (60 . "#ebcb8b")
     (80 . "#B4EB89")
     (100 . "#89EBCA")
     (120 . "#89AAEB")
     (140 . "#C189EB")
     (160 . "#bf616a")
     (180 . "#DCA432")
     (200 . "#ebcb8b")
     (220 . "#B4EB89")
     (240 . "#89EBCA")
     (260 . "#89AAEB")
     (280 . "#C189EB")
     (300 . "#bf616a")
     (320 . "#DCA432")
     (340 . "#ebcb8b")
     (360 . "#B4EB89"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((type nil)) (:background "#000000" :foreground "#f8f8f2")) (((class color) (min-colors 89)) (:background "#282a36" :foreground "#f8f8f2")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Linum-format "%7i ")
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(evil-want-Y-yank-to-eol t)
 '(fci-rule-character-color "#202020")
 '(fci-rule-color "#343d46" t)
 '(fringe-mode 4 nil (fringe))
 '(hl-paren-background-colors (quote ("#2492db" "#95a5a6" nil)))
 '(hl-paren-colors (quote ("#ecf0f1" "#ecf0f1" "#c0392b")))
 '(hl-sexp-background-color "#efebe9")
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style (quote chamfer))
 '(package-selected-packages
   (quote
    (darkroom olivetti org-wc kanban org-trello dash-functional request-deferred deferred spinner parent-mode pkg-info epl flx goto-chg bind-map popup ht gntp biblio-core iedit org-category-capture undo-tree powerline faff-theme web-mode tagedit slim-mode scss-mode sass-mode pug-mode less-css-mode helm-css-scss haml-mode emmet-mode yaml-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rbenv rake minitest chruby bundler inf-ruby deft pdf-tools tablist s winum solarized-theme markdown-mode madhat2r-theme highlight f alert log4e projectile hydra evil flyspell-correct avy dash ws-butler use-package ujelly-theme toc-org request persp-mode organic-green-theme org-ref ivy org-plus-contrib org-download neotree mu4e-maildirs-extension moe-theme jazz-theme inkpot-theme hide-comnt helm-projectile helm-make helm-bibtex helm-ag grandshell-theme expand-region evil-surround evil-nerd-commenter evil-mc evil-matchit evil-escape evil-anzu auto-compile packed apropospriate-theme alect-themes smartparens autothemer helm helm-core tao-theme spacemacs-theme zonokai-theme zenburn-theme zen-and-art-theme window-numbering which-key volatile-highlights uuidgen underwater-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tronesque-theme toxi-theme tangotango-theme tango-plus-theme tango-2-theme sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spaceline spacegray-theme soothe-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme seti-theme reverse-theme reveal-in-osx-finder restart-emacs rainbow-delimiters railscasts-theme quelpa purple-haze-theme professional-theme popwin planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme pcre2el pbcopy pastels-on-dark-theme parsebib paradox pandoc-mode ox-pandoc osx-trash osx-dictionary org-projectile org-present org-pomodoro org-bullets org-beautify-theme open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme niflheim-theme naquadah-theme mustang-theme mu4e-alert move-text monokai-theme monochrome-theme molokai-theme mmm-mode minimal-theme material-theme markdown-toc majapahit-theme macrostep lush-theme lorem-ipsum linum-relative link-hint light-soap-theme launchctl key-chord jbeans-theme ir-black-theme info+ indent-guide ido-vertical-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation heroku-theme hemisu-theme help-fns+ helm-themes helm-swoop helm-mode-manager helm-flx helm-descbinds hc-zenburn-theme gruvbox-theme gruber-darker-theme gotham-theme google-translate golden-ratio gnuplot gh-md gandalf-theme flyspell-correct-helm flx-ido flatui-theme flatland-theme firebelly-theme fill-column-indicator farmhouse-theme fancy-battery eyebrowse exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-search-highlight-persist evil-numbers evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-ediff evil-args eval-sexp-fu espresso-theme elisp-slime-nav dumb-jump dracula-theme django-theme diminish darktooth-theme darkokai-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized clues-theme clean-aindent-mode cherry-blossom-theme busybee-theme bubbleberry-theme birds-of-paradise-plus-theme bind-key biblio badwolf-theme auto-highlight-symbol auto-dictionary async anzu anti-zenburn-theme ample-zen-theme ample-theme aggressive-indent afternoon-theme adaptive-wrap ace-window ace-link ace-jump-helm-line)))
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(sml/active-background-color "#34495e")
 '(sml/active-foreground-color "#ecf0f1")
 '(sml/inactive-background-color "#dfe4ea")
 '(sml/inactive-foreground-color "#34495e")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#bf616a")
     (40 . "#DCA432")
     (60 . "#ebcb8b")
     (80 . "#B4EB89")
     (100 . "#89EBCA")
     (120 . "#89AAEB")
     (140 . "#C189EB")
     (160 . "#bf616a")
     (180 . "#DCA432")
     (200 . "#ebcb8b")
     (220 . "#B4EB89")
     (240 . "#89EBCA")
     (260 . "#89AAEB")
     (280 . "#C189EB")
     (300 . "#bf616a")
     (320 . "#DCA432")
     (340 . "#ebcb8b")
     (360 . "#B4EB89"))))
 '(vc-annotate-very-old-color nil))
