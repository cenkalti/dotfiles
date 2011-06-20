;; Disable emacs splash screen
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Indentation
(setq standart-indent 4)
(setq-default indent-tabs-mode nil)

;; Truncate long lines
(setq-default truncate-lines t)

;; Reload file on change
(global-auto-revert-mode t)

;; Save backups in one place
(setq backup-directory-alist `(("." . "~/.saves")))
