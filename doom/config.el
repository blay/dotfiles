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
'doom-ayu-mirage))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/notes/org/")
(setq org-roam-directory "~/notes/org/")
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

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
;;;; Org-Roam

;;;;;; Citation
(after! citar
  bind (("C-c b" . citar-insert-citation)
         :map minibuffer-local-map
         ("M-b" . citar-insert-preset))
  :custom
  (setq citar-bibliography '("~/notes/lib.bib")))

;;;;;; id-timestampe
(setq org-id-ts-format "%Y%m%d%H%M")
(setq org-id-method 'ts)

;;;;;; Default template

(setq org-roam-capture-templates
'(("d" "default" plain "%?" :target
  (file+head "%<%Y%m%d%H%M>-${slug}.org" "#+title: %<%Y%m%d%H%M>-${title}.org
        ")
  :unnarrowed t))
)


;;;;;; Dailies
(setq org-roam-dailies-directory "")

(setq org-roam-dailies-capture-templates
     '(("d" "default" entry
       "* %?"
         :target (file+head "%<%Y%m%d>0000.org"
                            "#+title: %<%Y%m%d>0000\n"))))

;; Custom Keymaps
;;
(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)
(define-key evil-motion-state-map "\C-g" 'flyspell-correct-previous)
(define-key evil-insert-state-map "\C-e" 'end-of-line)
(define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
(define-key evil-motion-state-map "\C-e" 'evil-end-of-line)
(map! :leader
        :desc "Correct previous error" "r" #'flyspell-correct-previous
        :desc "today's note" "d" #'org-roam-dailies-goto-today
        :desc "grep in project" "j" #'affe-grep
        :desc "last buffer" "k" #'evil-switch-to-windows-last-buffer
        :desc "recent files" "l" #'consult-recent-file
        )
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
