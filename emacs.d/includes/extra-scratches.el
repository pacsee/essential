(defun lisp-scratch ()
"Create a new scratch buffer -- \*scratch-lisp\*"
(interactive)
  (let* (
      bufname
      buffer
      (n 0) )
    (catch 'done
      (while t
        (setq bufname (concat "*scratch-lisp"
          (if (= n 0) "" (int-to-string n))
            "*"))
        (setq n (1+ n))
        (when (not (get-buffer bufname))
          (setq buffer (get-buffer-create bufname))
          (with-current-buffer buffer
            (lisp-interaction-mode)
	    (insert "; This is a lisp scratch\n; use :eval-buffer to execute\n")
	  )
          ;; When called non-interactively, the `t` targets the other window (if it exists).
          (throw 'done (display-buffer buffer t))) ))))
