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
(setq enable-local-variables :all)
(setq enable-local-eval :all)
(setq show-paren-delay 0)
(show-paren-mode 1)
(setq column-number-mode t)
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)
(setq c-tab-always-indent nil)
(setq c-syntactic-indentation nil)
(setq csaba-mode-line-format "[%*] %f:(%l,%c %p)")
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq confirm-kill-emacs 'y-or-n-p)
;(setq-default tab-always-indent nil)
;(setq tab-always-indent nil)

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

(load-file "~/.emacs.d/themes.el")
(set-face-attribute 'default nil :height 150)

(add-to-list 'load-path "~/.emacs.d/config/")
;;;; Load configurations
(require 'load-all-config)


;;;; Packages to install
;;; Main packages


(use-package magit
    :bind (("C-x g" . magit-status)
           ("C-x M-g" . magit-dispatch-popup))
)

;;; Tools
(use-package ag)
(use-package yasnippet
    :diminish yasnippet
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
    :init
    (setq relative-line-numbers-max-count 100)
    (setq relative-line-numbers-delay 0.05)
    :config
    (global-relative-line-numbers-mode)
    (set-face-foreground 'linum "yellow")
)


;;; Modes
(use-package yaml-mode)
(use-package js2-mode
  :ensure t
  :diminish js2-mode
  :pin gnu
  :config
  (defun cp/js2-setup()
    (setq js2-basic-offset 2)
    (setq evil-shift-width 2)
    )

  (add-hook 'js2-mode-hook 'cp/js2-setup)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
)

(use-package rjsx-mode
    :diminish rjsx-mode
    :config
    (define-key rjsx-mode-map "<" nil)
    (define-key rjsx-mode-map (kbd "C-d") nil)
    (defun cp/rjsx-setup()
      (setq js2-basic-offset 2)
      (setq evil-shift-width 2)
      )
    (add-hook 'rjsx-mode-hook 'cp/rjsx-setup)
)
(use-package python-mode
    :diminish python-mode
    :config
    (setq python-python-command "~/anaconda/bin/python3")
    (setq python-shell-interpreter "~/anaconda/bin/python3")
)
(use-package dockerfile-mode)
(use-package anaconda-mode
    :diminish anaconda-mode
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
    (ido-mode)
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

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc")
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

(use-package ansi-color
    :init
    (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
    (defun colorize-compilation-buffer ()
    (toggle-read-only)
    (ansi-color-apply-on-region (point-min) (point-max))
    (toggle-read-only))
    (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
    (add-hook 'eshell-preoutput-filter-functions
           'ansi-color-filter-apply)
)

;(use-package auctex)
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
(setq whitespace-style '(face tabs spaces tab-mark trailing))
;; add lines-tail or lines to show too long lines
(global-whitespace-mode t)

(setq compilation-scroll-output t)

(defun cs/runner (cmd)
  (interactive
   (let ((string (read-string (concat "Command: ") nil 'runner-history)))
    (list  string)))
  (save-some-buffers t)
  (let* ((default-directory cs-project-root)
         )
    (compile (concat "wswrap " cs-workspace " " cmd))))

(defun cs/rerunner ()
  (interactive)
  (save-some-buffers t)
  (let* ((default-directory cs-project-root)
        )

    (recompile)))

(defun cs/interactive ()
  (interactive)
  (comint-mode)
  (read-only-mode)
)

;; Runner
(progn
  (define-prefix-command 'cs-runner-map)
  (define-key cs-runner-map (kbd "<f5>") 'cs/rerunner)
  (define-key cs-runner-map (kbd "r") 'cs/runner)
  (define-key cs-runner-map (kbd "i") 'cs/interactive)
)

(global-set-key (kbd "<f5>") cs-runner-map)

(defun cs/run-python()
  (interactive)
  (let* ((git-root (jjl/git-root))
         (default-directory git-root)
         (compilation-environment cs-run-env))
    (compile cs-python t)))
(global-set-key [f3] 'cs/run-python)

(defun cs/run (test-name)
  (interactive
   (let ((string (read-string (concat "Run that: " cs-run-prefix) nil 'run-history)))
    (list  string)))
  (let* ((default-directory cs-project-root)
         (cs-env (concat "PATH=" cs-run-path ":" (getenv "PATH")))
         (compilation-environment (list cs-run-env cs-env))
         )
    (compile (concat cs-run-prefix test-name))))

(defun cs/run-interactive (test-name interactive)
  (interactive
   (let ((string (read-string (concat "Run that interactive: " cs-run-prefix) nil 'run-history)))
    (list  string t)))
  (let* ((git-root (jjl/git-root))
         (default-directory git-root))
    (setq compilation-environment cs-run-env)
    (compile (concat cs-run-prefix test-name) interactive)))


(add-hook 'comint-mode
    (lambda ()
        (define-key evil-normal-state-local-map (kbd "q") 'quit-window)))


(defun cs/run-test (test-name)
  (interactive "sTest that (src/): ")
  (save-some-buffers t)
  (let* ((git-root (jjl/git-root))
         (default-directory git-root))
    (compile (concat "DEV_ENV=true ./run.sh unittests run-contexts -sv src/" test-name))))

(defun cs/run-debug (test-name)
  (interactive "sDebug that (src/): ")
  (save-some-buffers t)
  (let* ((git-root (jjl/git-root))
         (default-directory git-root))
    (pdb (concat "env DEV_ENV=true ./run.sh unittests run-contexts -sv src/" test-name))))

(setq directory-abbrev-alist '(("^/opt/procurement" . "/Users/csaba/work/made.com/procurement")))


(defun cs/run-all-test ()
  (interactive)
  (let* ((git-root (jjl/git-root))
         (default-directory git-root))
          (compile (concat "DEV_ENV=true ./run.sh unittests run-contexts -sv src/"))))

(defun jjl/current-path ()
    (or (buffer-file-name) default-directory))

(defun jjl/git-root ()
    (let ((dir-path (jjl/current-path)))
        (and dir-path
            (file-truename (locate-dominating-file dir-path ".git")))))
(add-hook 'c-mode-common-hook #'hs-minor-mode)

;(defun my-compilation-hook ()
;(when (not (get-buffer-window "*compilation*"))
;(save-selected-window
;(save-excursion
;(let* ((w (split-window-vertically))
;(h (window-height w)))
;(select-window w)
;(switch-to-buffer "*compilation*")
;)))))
;(add-hook 'compilation-mode-hook 'my-compilation-hook)

(progn
  (define-prefix-command 'cs-map)
  (define-key cs-map (kbd "§") 'hs-toggle-hiding)
  (define-key cs-map (kbd "1") 'hs-hide-all)
  (define-key cs-map (kbd "2") 'hs-show-block)
  (define-key cs-map (kbd "3") 'hs-hide-level)
  (define-key cs-map (kbd "4") 'hs-hide-block)
  (define-key cs-map (kbd "5") 'hs-show-all)
)

(global-set-key (kbd "M-§") cs-map)
(add-hook 'python-mode-hook #'hs-minor-mode)

(defun test-main-multi ()
  (interactive)
  (let ((choice (completing-read-multiple "Select: " '("item1" "item2" "item3"))))
    (message "%S" choice)))

(defun test-main ()
  (interactive)
  (let ((choice (completing-read "Select: " '("item1" "item2" "item3"))))
    (message "%S" choice)))

