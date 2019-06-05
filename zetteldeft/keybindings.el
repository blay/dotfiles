;; Prefix
(spacemacs/declare-prefix "d" "deft")
;; Launch deft
(spacemacs/set-leader-keys "dd" 'spacemacs/helm-project-do-ag)
(spacemacs/set-leader-keys "dD" 'deft)
;; SEARCH
 ; Search thing at point
   (spacemacs/set-leader-keys "ds" 'zd-search-at-point)
 ; Search current file id
;   (spacemacs/set-leader-keys "dc" 'zd-search-current-id)
    (spacemacs/set-leader-keys "dc" 'helm-bibtex)
    ; Jump & search with avy
 ;  search link as filename
    (spacemacs/set-leader-keys "df" 'zd-avy-file-search)
    (spacemacs/set-leader-keys "dF" 'zd-avy-file-search-ace-window)
 ;  search link as contents
    (spacemacs/set-leader-keys "dl" 'zd-avy-link-search)
 ;  search tag as contents
    (spacemacs/set-leader-keys "dt" 'zd-avy-tag-search)
 ;  find all tags
    (spacemacs/set-leader-keys "dT" 'zd-tag-buffer)
;; LINKS
 ; Insert link from filename
   (spacemacs/set-leader-keys "di" 'zd-find-file-id-insert)
 ; Insert link with full filename
   (spacemacs/set-leader-keys "dI" 'zd-find-file-full-title-insert)
;; FILES
 ; Open file
   (spacemacs/set-leader-keys "do" 'zd-find-file)
 ; Create new file
   (spacemacs/set-leader-keys "dn" 'zd-new-file)
   (spacemacs/set-leader-keys "dN" 'zd-new-file-and-link)
 ; Rename file
   (spacemacs/set-leader-keys "dr" 'org-recoll-search)
;; UTILITIES
(spacemacs/set-leader-keys "dR" 'deft-refresh)
