(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
;(menu-bar-mode -1)
(setq x-select-enable-clipboard nil)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yaml-mode yasnippet magit sr-speedbar markdown-mode neotree evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; Custom configurations

(defvar required-packages
  '(
    magit
    yasnippet
    yaml-mode
    sr-speedbar
    markdown-mode
    neotree
    evil
  ) "a list of packages to ensure are installed at launch.")

(load-file "~/.emacs.d/plugins/packages.el")

(require 'evil)
(evil-mode 1)

(load-file "~/.emacs.d/neotree-config.el")
(load-file "~/.emacs.d/relative-line-numbers.el")
(load-file "~/.emacs.d/paren-mode.el")
(load-file "~/.emacs.d/plugins/highlight-indentation.el")
(load-file "~/.emacs.d/plugins/copy-paste.el")

(require 'sr-speedbar)
(require 'yaml-mode)

(load-file "~/.emacs.d/keybindings.el")
