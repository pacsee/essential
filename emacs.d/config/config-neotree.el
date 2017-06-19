(provide 'config-neotree)

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
    :init
    (global-set-key (kbd "C-c o") 'neotree-toggle)
    :config
    (setq neo-window-width 35)
    (setq projectile-switch-project-action 'neotree-projectile-action)
    ;(define-key evil-normal-state-map ",o" 'neotree-toggle)
    (add-hook 'neotree-mode-hook
        (lambda ()
          (local-set-key (kbd "RET") 'neotree-enter-hide)
        )
    )
    ;        (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter-vertical-split)
    ;        (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter-hide)
    ;        (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
    ;        (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)))
)

