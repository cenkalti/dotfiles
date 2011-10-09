;; Disable emacs splash screen
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Indentation
(setq standart-indent 4)
(setq indent-tabs-mode nil)

;; Truncate long lines
(setq truncate-lines t)

;; Reload file on change
(global-auto-revert-mode t)

;; Save backups in one place
(setq backup-directory-alist `(("." . "~/.emacs.d/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; Add your library directory to the front of your load-path
(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;; Enable php-mode
(autoload 'php-mode "php-mode.el" "PHP mode" t)
(setq auto-mode-alist (append '(("\\.php$" . php-mode)) auto-mode-alist))
