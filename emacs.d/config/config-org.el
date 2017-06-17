(provide 'config-org)

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

