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
    (ag ansible ansible-vault evil-magit ipython anaconda-mode python-mode evil-org org yaml-mode yasnippet magit sr-speedbar markdown-mode neotree evil)))
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
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
(load-file "~/.emacs.d/plugins/extra-scratches.el")

(require 'sr-speedbar)
(require 'yaml-mode)

(load-file "~/.emacs.d/config/backup.el")
(load-file "~/.emacs.d/keybindings.el")
(setq initial-major-mode 'org-mode)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))
(add-hook 'python-mode-hook 'anaconda-mode)
(setq initial-scratch-message "\
# This buffer is for notes you don't want to save, and for Python code.
# keys: ...
")
(setq inhibit-startup-screen t)
(setq python-python-command "~/anaconda/bin/python")

