;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el - Emacs main configurationi                                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Global config - Misc
(setq lexical-binding t)
(setq safe-local-variable-values (quote ((encoding . utf-8))))
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

;(add-to-list 'load-path "~/.emacs.d/plugins/")
;(progn (cd "~/.emacs.d/plugins/")
;       (normal-top-level-add-subdirs-to-load-path))

(setq show-paren-delay 0)
(show-paren-mode 1)
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")

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
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ;;("melpa" . "https://melpa.org/packages/")
))

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
    (evil-set-initial-state 'term-mode 'emacs)
)

(use-package org
    :init
    (setq org-src-fontify-natively t)
    (setq org-babel-python-command "~/anaconda/bin/python3")
    (load-file "~/.emacs.d/includes/org-babel-errors.el")
    :config
    (setq initial-major-mode 'org-mode)
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((python . t)))
    (setq initial-scratch-message "\
# This buffer is for notes you don't want to save, and for Python code.
# keys: 
#   python_ + TAB for python yasnipet
#   C-c C-x C-v: M-x org-toggle-inline-images
#   C-c C-v C-b: M-x org-babel-excute-buffer
#   C-c ': edit block - C-c C-c: execute code block

#+BEGIN_SRC python :result value
  import sys
  return sys.version
#+END_SRC
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

(use-package magit
    :bind (("C-x g" . magit-status)
           ("C-x M-g" . magit-dispatch-popup))
)

;;; Tools
(use-package ag)
(use-package yasnippet
    :config
    (yas-global-mode 1)
)

;;; Modes
(use-package yaml-mode)
(use-package python-mode
    :config
    (setq python-python-command "~/anaconda/bin/python3")
    (setq python-shell-interpreter "~/anaconda/bin/python3")
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


(use-package osx-clipboard
    :config
    (osx-clipboard-mode +1)
)
(use-package exec-path-from-shell
    :config
    (when (memq window-system '(mac ns))
      (exec-path-from-shell-initialize))
)

(use-package projectile
    :config
    (projectile-global-mode)
    (setq projectile-enable-caching t)
)

(use-package helm-projectile)
;(use-package ivy)
;(use-package swiper)
;(use-package counsel
;    :defer
;    :init
;    (setq projectile-completion-system 'ivy)
;)
; (use-package counsel-projectile)
; Custom configurations / custom plugins

(load-file "~/.emacs.d/includes/relative-line-numbers.el")
(load-file "~/.emacs.d/includes/backup.el")

;(load-file "~/.emacs.d/plugins/highlight-indentation.el")
;(load-file "~/.emacs.d/plugins/extra-scratches.el")
;
(load-file "~/.emacs.d/themes.el")
