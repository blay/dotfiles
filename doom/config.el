;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Magnus Eriksson"
      user-mail-address "ok@blay.se")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;(setq doom-theme 'doom-one)
(setq doom-theme
      (if (string-equal (format-time-string "%A") "Monday")
'doom-gruvbox
'doom-molokai))
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/notes/org/")
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq evil-want-fine-undo nil)
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented
;;
;; Custom Package Settings

;;;; Spelling
(set-company-backend!
  '(text-mode
    markdown-mode
    gfm-mode)
  '(:seperate
;    company-ispell
    company-files
    company-yasnippet))
;;;;;; Multiple dictionaries
(with-eval-after-load "ispell"
  ;; Configure `LANG`, otherwise ispell.el cannot find a 'default
  ;; dictionary' even though multiple dictionaries will be configured
  ;; in next line.
  (setenv "LANG" "en_US.UTF-8")
  (setq ispell-program-name "hunspell")
  ;; Configure Swedish and English.
  ;(setq ispell-dictionary "sv_SE,en_US")
  (setq ispell-dictionary "sv_SE,en_US")
  ;; ispell-set-spellchecker-params has to be called
  ;; before ispell-hunspell-add-multi-dic will work
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "sv_SE,en_US")
  ;; For saving words to the personal dictionary, don't infer it from
  ;; the locale, otherwise it would save to ~/.hunspell_de_DE.
  (setq ispell-personal-dictionary "~/.hunspell_personal"))
  ;; The personal dictionary file has to exist, otherwise hunspell will
  ;; silently not use it.
(unless (file-exists-p ispell-personal-dictionary)
  (write-region "" nil ispell-personal-dictionary nil 0))

;; Default and per-save backups go here:
(setq backup-directory-alist '(("" . "~/.emacs.d/backup/per-save")))
;;;; Org

(after! org
(setq org-todo-keywords
        '((sequence "TODO(t)" "SOME(s)" "|" "DONE(d!)" "CANC(c@)")))
  )
;;;;;; Org-agenda

(setq org-agenda-custom-commands '(
                                   ("d" "Daily Schedule"
                                   (
                                    (agenda "" (
                                    (org-agenda-overriding-header "Scheduled Today")
                                    (org-agenda-ndays 1)
                                    (org-agenda-start-day "+0")
                                    (org-agenda-span 'day)
                                    (org-agenda-entry-types '(:scheduled))
                                     ))
                                    (agenda "" (
                                     (org-agenda-overriding-header "Deadlines 7 Days")
                                     (org-agenda-entry-types '(:deadline))
                                     (org-agenda-ndays 7)
                                     (org-agenda-start-day "+0")
                                     (org-agenda-span 'day)
                                     (org-deadline-warning-days 8)
                                     (org-agenda-time-grid nil)
                                     (org-agenda-dim-blocked-tasks t)
                                     (org-agenda-skip-deadline-prewarning-if-scheduled t)
                                     ))
                                    (todo "TODO"
                                           ((org-agenda-overriding-header "\nUnscheduled TODO")
                                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp))))
                                    (tags "PRIORITY=\"A\"\"" (
                                                   (org-agenda-overriding-header "Priority Tasks")
                                                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp))
                                                   ))

                                    ))
                                ("f" "Future Deadlines"
                                   (
                                    (agenda "" (
                                     (org-agenda-overriding-header "Deadlines next 30 days")
                                     (org-agenda-entry-types '(:deadline))
                                     (org-agenda-ndays 30)
                                     (org-agenda-start-day "+0")
                                     (org-agenda-span 'day)
                                     (org-deadline-warning-days 29)
                                     (org-agenda-time-grid nil)
                                     (org-agenda-dim-blocked-tasks t)
                                     (org-agenda-skip-deadline-prewarning-if-scheduled nil)
                                     ))
                                    ))
                                ("x" "Someday"
                                   (
                                     (todo "SOME"
                                     ((org-agenda-overriding-header "\nThings to do someday")

                                     ))
                                    ))

                                ))

;;;;;; Citation
(after! citar
(setq! citar-bibliography '("~/notes/lib.bib"))
  )
;;;;;; Org-journal
(use-package org-journal
  :custom
  (org-journal-dir "~/notes/org/jott")
  (org-journal-file-type 'monthly "#+TITLE: Monthly Journal %B %Y\n")
  (org-journal-file-format "%Y%m000000-M-gt-%B.org")
  (org-journal-date-prefix "* ")
  (org-journal-date-format "%A, %d %B")
  (org-journal-time-format "")
  (org-journal-time-prefix "")
  )
;;;;;; Org-agenda

(setq org-agenda-skip-deadline-prewarning-if-scheduled t)

;;;;;; id-timestampe
(setq org-id-ts-format "%Y%m%d%H%M")
(setq org-id-method 'ts)

;; Org Roam Config

(use-package! org-roam
  :hook
  (after-init . org-roam-mode)
   :custom
  (org-roam-directory "~/Dropbox/notes/org")
  ;(org-roam-db-location "~/Dropbox/notes/org-roam.db")
  (org-roam-db-location (file-truename (concat "~/Dropbox/notes/" system-name ".roam.db")))
;;;;;; Default template
(org-roam-capture-templates
'(("d" "default" plain "%?" :target
  (file+head "%<%Y%m%d%H%M>-${slug}.org" "#+title: %<%Y%m%d%H%M>-${title}.org
        ")
  :unnarrowed t))
)
;;;;;; Dailies
(org-roam-dailies-directory "daily")
(org-roam-dailies-capture-templates
     '(("d" "default" entry
       "* %?"
         :target (file+head "%<%Y%m%d>0000.org"
                            "#+title: %<%Y%m%d>0000\n"))))
:config
(cl-defmethod org-roam-node-slug ((node org-roam-node))
  "Return the slug of NODE."
  (let ((title (org-roam-node-title node))
        (slug-trim-chars '(;; Combining Diacritical Marks https://www.unicode.org/charts/PDF/U0300.pdf
                           768 ; U+0300 COMBINING GRAVE ACCENT
                           769 ; U+0301 COMBINING ACUTE ACCENT
                           770 ; U+0302 COMBINING CIRCUMFLEX ACCENT
                           771 ; U+0303 COMBINING TILDE
                           772 ; U+0304 COMBINING MACRON
                           774 ; U+0306 COMBINING BREVE
                           775 ; U+0307 COMBINING DOT ABOVE
                           776 ; U+0308 COMBINING DIAERESIS
                           777 ; U+0309 COMBINING HOOK ABOVE
                           778 ; U+030A COMBINING RING ABOVE
                           780 ; U+030C COMBINING CARON
                           795 ; U+031B COMBINING HORN
                           803 ; U+0323 COMBINING DOT BELOW
                           804 ; U+0324 COMBINING DIAERESIS BELOW
                           805 ; U+0325 COMBINING RING BELOW
                           807 ; U+0327 COMBINING CEDILLA
                           813 ; U+032D COMBINING CIRCUMFLEX ACCENT BELOW
                           814 ; U+032E COMBINING BREVE BELOW
                           816 ; U+0330 COMBINING TILDE BELOW
                           817 ; U+0331 COMBINING MACRON BELOW
                           )))
    (cl-flet* ((nonspacing-mark-p (char)
                                  (memq char slug-trim-chars))
               (strip-nonspacing-marks (s)
                                       (ucs-normalize-NFC-string
                                        (apply #'string (seq-remove #'nonspacing-mark-p
                                                                    (ucs-normalize-NFD-string s)))))
               (cl-replace (title pair)
                           (replace-regexp-in-string (car pair) (cdr pair) title)))
      (let* ((pairs `(("[^[:alnum:][:digit:]]" . "-") ;; convert anything not alphanumeric
                      ("--*" . "-")                   ;; remove sequential underscores
                      ("^-" . "")                     ;; remove starting underscore
                      ("-$" . "")))                   ;; remove ending underscore
             (slug (-reduce-from #'cl-replace (strip-nonspacing-marks title) pairs)))
        (downcase slug)))))

)
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; for org-roam-buffer-toggle
;; Recommendation in the official manual
(add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                  (display-buffer-in-direction)
                  (direction . right)
                  (window-width . 0.25)
                  (window-height . fit-window-to-buffer)))

;; Custom Keymaps
;;
(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)
(define-key evil-motion-state-map "\C-g" 'flyspell-correct-previous)
(define-key evil-insert-state-map "\C-e" 'end-of-line)
(define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
(define-key evil-motion-state-map "\C-e" 'evil-end-of-line)
(map! :leader
        :desc "Correct previous error" "e" #'flyspell-correct-previous
        :desc "Insert Citation" "r" #'citar-insert-citation
        :desc "today's note" "D" #'org-journal-new-entry
        :desc "today's tasks" "d" #'org-agenda
        :desc "grep in project" "j" #'consult-ripgrep
        :desc "last buffer" "k" #'evil-switch-to-windows-last-buffer
        :desc "Open link hint" "l" #'link-hint-open-link
        :desc "Show only current header" "y" #'org-show-current-heading
        )
;; Fold previous header level
(global-set-key (kbd "C-c k") (lambda () (interactive)
  (outline-up-heading 1)
  (org-cycle)))

;; Mark Paragraph as list
;;
(global-set-key (kbd "C-c i") (lambda () (interactive) (mark-paragraph) (org-ctrl-c-minus)))

;; Fix org-tree-slide
(after! org-tree-slide
  (advice-remove 'org-tree-slide--display-tree-with-narrow
                 #'+org-present--hide-first-heading-maybe-a)
  )
(setq org-tree-slide-cursor-init nil)
;; Native Power
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (progn
    (setq native-comp-async-report-warnings-errors nil)
    (setq comp-deferred-compilation t)
    (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))
    (setq package-native-compile t)
    ))
;; Custom Functions
;;

(defun copy-uid ()
  "Copy the uid of the file in buffer"
  (interactive)
  (kill-new
   (substring
    (file-name-nondirectory buffer-file-name)
    0 12)))

(defun copy-filename ()
  "Copy the filename of buffer"
  (interactive)
  (kill-new
   (file-name-nondirectory buffer-file-name)))

(defun id-uid ()
(interactive)
    (org-entry-put 0 "id" (copy-uid))
)

(defun insert-beginning ()
(interactive)
    (goto-char (point-min))
    (insert-before-markers "#+TITLE: ")
    (insert-before-markers (copy-filename))
    (newline)
    (id-uid)
    (newline)
    )

(defun contain-prop ()
(interactive)
(unless
      (save-excursion
    (goto-char (point-min))
    (search-forward ":PROPERTIES:" nil t))
(insert-beginning)
)
)

;; Dynamic Agenda
;;
;;
(defun vulpea-project-p ()
  "Return non-nil if current buffer has any todo entry.

TODO entries marked as done are ignored, meaning the this
function returns nil if current buffer contains only completed
tasks."
  (seq-find                                 ; (3)
   (lambda (type)
     (eq type 'todo))
   (org-element-map                         ; (2)
       (org-element-parse-buffer 'headline) ; (1)
       'headline
     (lambda (h)
       (org-element-property :todo-type h)))))

(defun vulpea-project-update-tag ()
    "Update PROJECT tag in the current buffer."
    (when (and (not (active-minibuffer-window))
               (vulpea-buffer-p))
      (save-excursion
        (goto-char (point-min))
        (let* ((tags (vulpea-buffer-tags-get))
               (original-tags tags))
          (if (vulpea-project-p)
              (setq tags (cons "project" tags))
            (setq tags (remove "project" tags)))

          ;; cleanup duplicates
          (setq tags (seq-uniq tags))

          ;; update tags if changed
          (when (or (seq-difference tags original-tags)
                    (seq-difference original-tags tags))
            (apply #'vulpea-buffer-tags-set tags))))))

(defun vulpea-buffer-p ()
  "Return non-nil if the currently visited buffer is a note."
  (and buffer-file-name
       (string-prefix-p
        (expand-file-name (file-name-as-directory org-roam-directory))
        (file-name-directory buffer-file-name))))

(defun vulpea-project-files ()
    "Return a list of note files containing 'project' tag." ;
    (seq-uniq
     (seq-map
      #'car
      (org-roam-db-query
       [:select [nodes:file]
        :from tags
        :left-join nodes
        :on (= tags:node-id nodes:id)
        :where (like tag (quote "%\"project\"%"))]))))

(defun vulpea-agenda-files-update (&rest _)
  "Update the value of `org-agenda-files'."
  (setq org-agenda-files (vulpea-project-files)))

(add-hook 'find-file-hook #'vulpea-project-update-tag)
(add-hook 'before-save-hook #'vulpea-project-update-tag)

(advice-add 'org-agenda :before #'vulpea-agenda-files-update)

;; functions borrowed from `vulpea' library
;; https://github.com/d12frosted/vulpea/blob/6a735c34f1f64e1f70da77989e9ce8da7864e5ff/vulpea-buffer.el

(defun vulpea-buffer-tags-get ()
  "Return filetags value in current buffer."
  (vulpea-buffer-prop-get-list "filetags" "[ :]"))

(defun vulpea-buffer-tags-set (&rest tags)
  "Set TAGS in current buffer.

If filetags value is already set, replace it."
  (if tags
      (vulpea-buffer-prop-set
       "filetags" (concat ":" (string-join tags ":") ":"))
    (vulpea-buffer-prop-remove "filetags")))

(defun vulpea-buffer-tags-add (tag)
  "Add a TAG to filetags in current buffer."
  (let* ((tags (vulpea-buffer-tags-get))
         (tags (append tags (list tag))))
    (apply #'vulpea-buffer-tags-set tags)))

(defun vulpea-buffer-tags-remove (tag)
  "Remove a TAG from filetags in current buffer."
  (let* ((tags (vulpea-buffer-tags-get))
         (tags (delete tag tags)))
    (apply #'vulpea-buffer-tags-set tags)))

(defun vulpea-buffer-prop-set (name value)
  "Set a file property called NAME to VALUE in buffer file.
If the property is already set, replace its value."
  (setq name (downcase name))
  (org-with-point-at 1
    (let ((case-fold-search t))
      (if (re-search-forward (concat "^#\\+" name ":\\(.*\\)")
                             (point-max) t)
          (replace-match (concat "#+" name ": " value) 'fixedcase)
        (while (and (not (eobp))
                    (looking-at "^[#:]"))
          (if (save-excursion (end-of-line) (eobp))
              (progn
                (end-of-line)
                (insert "\n"))
            (forward-line)
            (beginning-of-line)))
        (insert "#+" name ": " value "\n")))))

(defun vulpea-buffer-prop-set-list (name values &optional separators)
  "Set a file property called NAME to VALUES in current buffer.
VALUES are quoted and combined into single string using
`combine-and-quote-strings'.
If SEPARATORS is non-nil, it should be a regular expression
matching text that separates, but is not part of, the substrings.
If nil it defaults to `split-string-default-separators', normally
\"[ \f\t\n\r\v]+\", and OMIT-NULLS is forced to t.
If the property is already set, replace its value."
  (vulpea-buffer-prop-set
   name (combine-and-quote-strings values separators)))

(defun vulpea-buffer-prop-get (name)
  "Get a buffer property called NAME as a string."
  (org-with-point-at 1
    (when (re-search-forward (concat "^#\\+" name ": \\(.*\\)")
                             (point-max) t)
      (buffer-substring-no-properties
       (match-beginning 1)
       (match-end 1)))))

(defun vulpea-buffer-prop-get-list (name &optional separators)
  "Get a buffer property NAME as a list using SEPARATORS.
If SEPARATORS is non-nil, it should be a regular expression
matching text that separates, but is not part of, the substrings.
If nil it defaults to `split-string-default-separators', normally
\"[ \f\t\n\r\v]+\", and OMIT-NULLS is forced to t."
  (let ((value (vulpea-buffer-prop-get name)))
    (when (and value (not (string-empty-p value)))
      (split-string-and-unquote value separators))))

(defun vulpea-buffer-prop-remove (name)
  "Remove a buffer property called NAME."
  (org-with-point-at 1
    (when (re-search-forward (concat "\\(^#\\+" name ":.*\n?\\)")
                             (point-max) t)
      (replace-match ""))))

(defun org-show-current-heading ()
  (interactive)  ;Inteactive
  "Show next entry, keeping other entries closed."
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (show-children))
    (outline-back-to-heading)
    (unless (and (bolp) (org-on-heading-p))
      (org-up-heading-safe)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))
