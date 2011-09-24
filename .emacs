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
(setq auto-save-file-name-transforms `((".*" "~/.saves" t)))

;; Enable php-mode
(autoload 'php-mode "php-mode.el" "Php mode." t)
(setq auto-mode-alist (append '(("/*.\.php[345]?$" . php-mode)) auto-mode-alist))

;; Enable mmm-mode
(require 'mmm-mode)
;;(require 'mmm-auto)
(setq load-path (cons "/usr/share/emacs/site-lisp/mmm-mode" load-path))

(load "/usr/share/emacs/site-lisp/haskell-mode/haskell-site-file.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
