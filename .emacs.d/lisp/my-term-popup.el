
(defun read-fmt-content (filepath)
  (interactive)
  (let ((file-content (f-read-text filepath)))
    (with-temp-buffer
      (emacs-lisp-mode)
      ;; (rename-buffer "tmp.el" t)
      ;; (set-auto-mode)
      ;; (message "%s" (buffer-mode))
      (insert file-content)
      (font-lock-ensure)
      (buffer-string))))

(defun my-show-bellow-point()           ;
  (interactive)
  (message "%s" (- (window-width) 10))
  (corfu--popup-show
   (posn-at-point)
   (save-excursion
     (goto-char (point))
     (current-column))
   (- (window-width) 8)
   (split-string (read-fmt-content "~/Downloads/example.el") "\n"))
  )
