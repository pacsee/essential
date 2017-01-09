(use-package solarized-theme
    :ensure t
    :if window-system
    :init
    (progn
        (setq solarized-use-less-bold t
            solarized-distinct-fringe-background nil
            solarized-emphasize-indicators nil
            solarized-height-minus-1 1
            solarized-height-plus-1 1
            solarized-height-plus-2 1
            solarized-height-plus-3 1
            solarized-height-plus-4 1
            solarized-high-contrast-mode-line nil
            solarized-scale-org-headlines nil
            solarized-use-more-italic t
            solarized-use-variable-pitch nil
        )
    )
    :config
    (progn
        (load "solarized-theme-autoloads" nil t)
        (setq theme-dark 'solarized-dark
            theme-bright 'solarized-light))
    (load-theme 'solarized-dark t)
)
