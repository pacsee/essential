(provide 'config-evil)


(use-package evil
    :config
    (evil-mode 1)
    (define-key evil-normal-state-map ",b" 'ido-switch-buffer)
    (define-key evil-normal-state-map ",w" 'toggle-truncate-lines)
    (define-key evil-normal-state-map ",s" 'whitespace-cleanup)
    (evil-set-initial-state 'term-mode 'emacs)
    ;(define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
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
    (define-key evil-normal-state-map (kbd "C-§") (lambda() (interactive) (elscreen-goto 0)))
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
