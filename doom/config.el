;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(add-hook 'text-mode-hook #'auto-fill-mode) ;automatically wrap lines when certain number line reached
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 16)
      display-line-numbers-type 'relative)
;; unset a bunch of not useful bindings

(map! :leader "h C" nil) ; describe coding system
(map! :leader "h g" nil) ; describe gnu project
(map! :leader "h I" nil) ; describe input method
(map! :leader "h I" nil) ; describe input method
;; (map! :map "C-h C-f" nil) ; emacs FAQ
;; ------------------------------------------------
;; -------------- package configs -----------------
;; ------------------------------------------------

;; org-mode

(setq org-fontify-emphasized-text t
      org-directory "~/org/"
      org-tag-faces
      '(("WARN" . org-warning)
        ("NOTE" . org-list-dt))
      ; roam
      org-roam-directory "~/org/roam/"
      ; journal
      org-journal-date-prefix "#+TITLE: "
      org-journal-time-prefix "* "
      org-journal-date-format "%a, %Y-%m-%d"
      org-journal-file-format "%Y-%m-%d.org"
      )
;; auth

(setq auth-sources '("~/.authinfo")
      user-full-name "Gerson Gallo"
      user-mail-address "ggallovalle@gmail.com")
;; projectile

(setq projectile-project-search-path '("~/ghq/github.com/ggallovalle/"))
(put 'projectile-project-test-cmd 'safe-local-variable #'stringp)
(put 'projectile-project-run-cmd 'safe-local-variable #'stringp)

;; flyspell
(setq flyspell-lazy-idle-seconds 2)
