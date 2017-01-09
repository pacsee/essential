(use-package solarized-theme
  :ensure t
  :if window-system
  :init
  (progn
    (setq solarized-use-less-bold t
          solarized-use-more-italic t
          solarized-emphasize-indicators nil
          solarized-distinct-fringe-background nil
          solarized-high-contrast-mode-line nil))
  :config
  (progn
    (load "solarized-theme-autoloads" nil t)
    (setq theme-dark 'solarized-dark
          theme-bright 'solarized-light))
    (load-theme 'solarized-dark t)
  )
