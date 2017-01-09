;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el - Emacs main configurationi                                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Global config - Misc
(setq lexical-binding t)
(setq safe-local-variable-values (quote ((encoding . utf-8))))
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

(setq show-paren-delay 0)
(show-paren-mode 1)

;;; UI Setup
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)

;;; Packaging
(setq package-enable-at-startup nil)
(setq custom-file (concat user-emacs-directory "config.el"))
(load custom-file t)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;;; Ensure use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)

;;;; Packages to install
;;; Main packages

(use-package evil
    :config
    (evil-mode 1)
    (define-key evil-normal-state-map ",b" 'ibuffer)
    (define-key evil-normal-state-map ",w" 'toggle-truncate-lines)
)

(use-package org
    :config
    (setq initial-major-mode 'org-mode)
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((python . t)))
    (setq initial-scratch-message "\
# This buffer is for notes you don't want to save, and for Python code.
# keys: ...
")
)

(use-package neotree
    :config
    (setq neo-window-width 35)
    (define-key evil-normal-state-map ",o" 'neotree-toggle)
    (add-hook 'neotree-mode-hook
        (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter-vertical-split)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-quick-look)))
)

(use-package magit)

;;; Tools
(use-package ag)
(use-package yasnippet)

;;; Modes
(use-package yaml-mode)
(use-package python-mode
    :config
    (setq python-python-command "~/anaconda/bin/python")
)
(use-package markdown-mode)
(use-package dockerfile-mode)
(use-package anaconda-mode
    :config
    (add-hook 'python-mode-hook 'anaconda-mode)
)

;;; Extensions
(use-package ansible)
(use-package ansible-vault)
;(use-package ipython)

(use-package sr-speedbar
    :config
    (define-key evil-normal-state-map ",t" 'sr-speedbar-toggle)
)

;;; Evil extensions
(use-package evil-magit)
(use-package evil-org)

; Custom configurations / custom plugins


(load-file "~/.emacs.d/includes/relative-line-numbers.el")
(load-file "~/.emacs.d/includes/backup.el")

;(load-file "~/.emacs.d/plugins/highlight-indentation.el")
;(load-file "~/.emacs.d/plugins/extra-scratches.el")
;
(load-file "~/.emacs.d/themes.el")
