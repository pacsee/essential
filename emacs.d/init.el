(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
;(menu-bar-mode -1)

(require 'evil)
(evil-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (neotree evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; Custom configurations

(load-file "~/.emacs.d/neotree-config.el")
(load-file "~/.emacs.d/relative-line-numbers.el")
(load-file "~/.emacs.d/paren-mode.el")
(load-file "~/.emacs.d/plugins/highlight-indentation.el")
(load-file "~/.emacs.d/plugins/yaml-mode.el")
