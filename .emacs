(toggle-truncate-lines)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
;;(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
;; )

(setq standard-indent 4)
(setq-default indent-tabs-mode nil) 
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;(global-set-key [up] (lambda () (interactive) (scroll-down 1)))
;;(global-set-key [down] (lambda () (interactive) (scroll-up 1)))

;;(global-set-key [left] (lambda () (interactive) (scroll-right tab-width t)))
;;(global-set-key [right] (lambda () (interactive) (scroll-left tab-width t)))

(autoload 'php-mode "php-mode.el" "Php mode." t)
(setq auto-mode-alist (append '(("/*.\.php[345]?$" . php-mode)) auto-mode-alist))
