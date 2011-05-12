;; Disable emacs splash screen
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Indentation
(setq standart-indent 4)
(setq-default indent-tabs-mode nil)

;; Create the autosave dir if necessary, since emacs won't.
;;(make-directory "~/.emacs.d/autosaves/" t)

;; Auto-save settings
;;(setq auto-save-file-name-transforms '(("." "~/.emacs.d/autosaves/\\1" t)))

;; Backup settings
(setq backup-directory-alist '(("." . "~/.emacs.d/backups/")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; PHP mode
(autoload 'php-mode "php-mode.el" "Php mode." t)
(setq auto-mode-alist (append '(("/*.\.php[345]?$" . php-mode)) auto-mode-alist))

;; Truncate long lines
(setq-default truncate-lines t)

;; Put the scrollbar to the right side of the window
;;(set-scroll-bar-mode 'right)
