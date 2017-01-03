(define-key evil-normal-state-map ",t" 'sr-speedbar-toggle)
(define-key evil-normal-state-map ",b" 'ibuffer)
(define-key evil-normal-state-map ",w" 'toggle-truncate-lines)
(define-key evil-normal-state-map ",o" 'neotree-toggle)

(add-hook 'neotree-mode-hook
            (lambda ()
              (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter-vertical-split)
              (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
              (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
              (define-key evil-normal-state-local-map (kbd "RET") 'neotree-quick-look)))

(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))
