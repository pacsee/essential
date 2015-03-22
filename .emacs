;; Aquamacs settings
;; Author: Csaba Palankai <csaba.palankai@gmail.com>

(setq package-user-dir "~/.emacs.d/elpa")
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(color-theme-initialize)
(color-theme-dark-blue2)

; Default scripts folder
(add-to-list 'load-path "~/.emacs.d/scripts")


(global-linum-mode 1) ; display line numbers in margin.
(global-show-newlines-mode)

;; Set column indicator and it's color
(require 'fill-column-indicator)
(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)
(setq fci-rule-column 79)
(setq fci-rule-color "red")
(tool-bar-mode 0)

;; python-mode
(setq py-install-directory "~/.emacs.d/python-mode.el-6.2.0")
(add-to-list 'load-path py-install-directory)
(require 'python-mode)

; use IPython
(setq-default py-shell-name "python")
(setq-default py-which-bufname "Python")
; use the wx backend, for both mayavi and matplotlib
;(setq py-python-command-args
;  '("--gui=wx" "--pylab=wx" "-colors" "Linux"))
;(setq py-force-py-shell-name-p t)

; switch to the interpreter after executing code
(setq py-shell-switch-buffers-on-execute-p t)
(setq py-switch-buffers-on-execute-p t)
; don't split windows
;(setq py-split-windows-on-execute-p nil)
; try to automagically figure out indentation
(setq py-smart-indentation t)

(require 'virtualenvwrapper)
(venv-initialize-interactive-shells) ;; if you want interactive shell support
(venv-initialize-eshell) ;; if you want eshell support
(setq venv-location "~/.envs/")

; Switching windows better
(require 'ibs)

(global-set-key "\M-," 'codesearch-search)
