;;; packages.el --- org-zotero layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  Samim Pezeshki <psamim@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst org-zotero-packages
  '(zotxt
    zotelo))

(defun org-zotero/init-zotxt ()
  (spacemacs|diminish org-zotxt-mode " Ⓩ" " z")
  (spacemacs/declare-prefix-for-mode 'org-mode "mz"  "zotero")
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "zi"    'zotxt-easykey-insert
    "iz"    'org-zotxt-insert-reference-link
    "zo"    'org-zotxt-open-attachment)
  (add-hook 'org-mode-hook 'org-zotxt-mode))

(defun org-zotero/init-zotelo ()
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "zu"    'zotelo-update-database
    "zs"    'zotelo-set-collection))
