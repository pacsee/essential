;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el - Emacs main configurationi                                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; OSX config
(when (string-equal system-type "darwin")
  (setq exec-path (append exec-path '("/usr/local/bin")))
)


;;; Global config - Misc
(setq lexical-binding t)
(setq safe-local-variable-values (quote ((encoding . utf-8))))
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

;(add-to-list 'load-path "~/.emacs.d/plugins/")
;(progn (cd "~/.emacs.d/plugins/")
;       (normal-top-level-add-subdirs-to-load-path))

(setq show-paren-delay 0)
(show-paren-mode 1)
(setq column-number-mode t)
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
                         ("melpa" . "https://melpa.org/packages/")
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
(use-package evil-leader
    :config
    (evil-leader/set-leader ",")
    (global-evil-leader-mode)
)

;; Check this
;; https://github.com/dholm/tabbar
(use-package evil-tabs
    :config
    :disabled
    (global-evil-tabs-mode t)
    (define-key evil-normal-state-map (kbd "C-0") (lambda() (interactive) (elscreen-goto 0)))
    ;(define-key evil-normal-state-map (kbd "C- ") (lambda() (interactive) (elscreen-goto 0)))
    (define-key evil-normal-state-map (kbd "C-1") (lambda() (interactive) (elscreen-goto 1)))
    (define-key evil-normal-state-map (kbd "C-2") (lambda() (interactive) (elscreen-goto 2)))
    (define-key evil-normal-state-map (kbd "C-3") (lambda() (interactive) (elscreen-goto 3)))
    (define-key evil-normal-state-map (kbd "C-4") (lambda() (interactive) (elscreen-goto 4)))
    (define-key evil-normal-state-map (kbd "C-5") (lambda() (interactive) (elscreen-goto 5)))
    (define-key evil-normal-state-map (kbd "C-6") (lambda() (interactive) (elscreen-goto 6)))
    (define-key evil-normal-state-map (kbd "C-7") (lambda() (interactive) (elscreen-goto 7)))
    (define-key evil-normal-state-map (kbd "C-8") (lambda() (interactive) (elscreen-goto 8)))
    (define-key evil-normal-state-map (kbd "C-9") (lambda() (interactive) (elscreen-goto 9)))
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

(defun neo-open-file-hide (full-path &optional arg)
  "Open a file node and hides tree."
  (neo-global--select-mru-window arg)
  (find-file full-path)
  (neotree-hide))

(defun neotree-enter-hide (&optional arg)
  "Enters file and hides neotree directly"
  (interactive "P")
  (neo-buffer--execute arg 'neo-open-file-hide 'neo-open-dir))

(use-package neotree
    :config
    (setq neo-window-width 35)
    (define-key evil-normal-state-map ",o" 'neotree-toggle)
    (add-hook 'neotree-mode-hook
        (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter-vertical-split)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter-hide)
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

(use-package general
    :demand
)

(use-package zoom-frm
    :commands zoom-in/out
    :general
    (:prefix "C-x"
        "C-=" 'zoom-in/out
        "C-+" 'zoom-in/out
        "C--" 'zoom-in/out
        "C-0" 'zoom-in/out))

(use-package relative-line-numbers
    :config
    (global-relative-line-numbers-mode)
    (set-face-foreground 'linum "yellow")
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
    ;(define-key evil-normal-state-map ",t" 'sr-speedbar-toggle)
)

;;; Evil extensions
(use-package evil-magit)
(use-package evil-org
    :disabled
)

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
    (define-key evil-normal-state-map ",," 'projectile-project-buffers-other-buffer)
    :init
    (unless (file-exists-p "~/.emacs.d/cache/")
      (make-directory "~/.emacs.d/cache")
    )
    (setq projectile-cache-file "~/.emacs.d/cache/projectile.cache")
    (setq projectile-known-projects-file "~/.emacs.d/cache/projectile-bookmarks.eld")
)
(use-package ido
    :init
    (setq
        ido-default-buffer-method 'selected-window
        ido-enable-flex-matching t
        ido-use-virtual-buffers t)
    :config
    (ido-everywhere)
)
(use-package ido-vertical-mode
    :demand
    :init
    (ido-vertical-mode)
)
(use-package helm
    :config
    (define-key evil-normal-state-map ",t" 'helm-imenu)
)

(use-package helm-projectile)
(use-package helm-swoop)
(use-package flx-ido
    :config
    ;:disabled ;; due to haveing grizzl
    (flx-ido-mode 1)
    ;; disable ido faces to see flx highlights.
    (setq ido-enable-flex-matching t)
    (setq ido-use-faces nil)
)

(use-package indent-guide
    :disabled
    :config
    (setq indent-guide-recursive t)
    ;(setq indent-guide-threshold 1)
    (indent-guide-global-mode)
)

(use-package fill-column-indicator
    :init
    (setq fci-rule-column 79)
    (add-hook 'org-mode-hook 'fci-mode)
    (add-hook 'python-mode-hook 'fci-mode)
    (add-hook 'markdown-mode-hook 'fci-mode)
    ;:config
    ;(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
    ;(global-fci-mode 1)
)
;(use-package ivy)
;(use-package swiper)
;(use-package counsel
;    :defer
;    :init
;    (setq projectile-completion-system 'ivy)
;)
; (use-package counsel-projectile)
; Custom configurations / custom plugins

;(load-file "~/.emacs.d/plugins/highlight-indentation.el")
;(load-file "~/.emacs.d/plugins/extra-scratches.el")



(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(unless (file-exists-p autosave-dir)
  (make-directory autosave-dir)
)
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))


(defvar backup-dir (expand-file-name "~/.emacs.d/backup/"))
(unless (file-exists-p backup-dir)
  (make-directory backup-dir)
)

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/backup/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)
;


(require 'whitespace)
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Useless-Whitespace.html
(setq whitespace-style '(face empty tabs spaces newline empty big-indent trailing tab-mark))
;; add lines-tail or lines to show too long lines
(global-whitespace-mode t)


(load-file "~/.emacs.d/themes.el")
