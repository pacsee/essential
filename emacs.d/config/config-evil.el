(provide 'config-evil)


(use-package evil
    :config
    (evil-mode 1)
    ;(define-key evil-normal-state-map ",b" 'ido-switch-buffer)
    ;(define-key evil-normal-state-map ",w" 'toggle-truncate-lines)
    ;(define-key evil-normal-state-map ",s" 'whitespace-cleanup)
    ;(evil-set-initial-state 'term-mode 'emacs)
    (setq evil-want-fine-undo 'fine)
    ;(define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
)

(use-package evil-leader
    :config
    (evil-leader/set-leader ",")
    (global-evil-leader-mode)
)
