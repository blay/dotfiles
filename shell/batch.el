;;; batch.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Magnus Eriksson
;;
;; Author: Magnus Eriksson <https://github.com/svartfax>
;; Maintainer: Magnus Eriksson <ok@blay.se>
;; Created: December 02, 2021
;; Modified: December 02, 2021
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/svartfax/batch
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:



(provide 'batch)

(require 'org)


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

;;; batch.el ends here
