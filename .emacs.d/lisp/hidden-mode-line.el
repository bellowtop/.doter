(defvar-local hidden-mode-line-mode nil)

(define-minor-mode hidden-mode-line-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global t
  :variable hidden-mode-line-mode
  :group 'editing-basics
  (if hidden-mode-line-mode
      (setq hide-mode-line mode-line-format
            mode-line-format nil)
    (setq mode-line-format hide-mode-line
          hide-mode-line nil))
  (force-mode-line-update)
  (redraw-display)
  (when (and (called-interactively-p 'interactive)
             hidden-mode-line-mode)
    (run-with-idle-timer
     0 nil 'message
     (concat "Hidden Mode Line Mode enabled.  "
             "Use M-x hidden-mode-line-mode to make the mode-line appear."))))

(defvar my-hidden-mode-enabled-p nil
  "Non-nil if Hidden Mode Line is currently globally enabled.")

(defun my-hidden-mode--apply-to-all-buffers (fn)
  "Apply FN to all live buffers."
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (funcall fn))))

(defun my-hidden-mode-toggle-global (&optional arg)
  "Toggle Hidden Mode Line globally.
With optional ARG, enable if ARG is positive, disable otherwise."
  (interactive "P")
  (let ((enable (if arg (> (prefix-numeric-value arg) 0)
                 (not my-hidden-mode-enabled-p))))
    (if enable
        (progn
          ;; Enable: add hooks and apply to existing buffers
          (add-hook 'text-mode-hook #'hidden-mode-line-mode)
          (add-hook 'prog-mode-hook #'hidden-mode-line-mode)
          (add-hook 'conf-mode-hook #'hidden-mode-line-mode)
          (add-hook 'org-mode-hook  #'hidden-mode-line-mode)
          (my-hidden-mode--apply-to-all-buffers #'hidden-mode-line-mode)
          (setq my-hidden-mode-enabled-p t)
          (message "Hidden Mode Line Mode: Globally enabled for new and existing buffers."))
      ;; Disable: remove hooks and revert existing buffers
      (remove-hook 'text-mode-hook #'hidden-mode-line-mode)
      (remove-hook 'prog-mode-hook #'hidden-mode-line-mode)
      (remove-hook 'conf-mode-hook #'hidden-mode-line-mode)
      (remove-hook 'org-mode-hook  #'hidden-mode-line-mode)
      (my-hidden-mode--apply-to-all-buffers (lambda ()
                                             (when hidden-mode-line-mode
                                               (hidden-mode-line-mode -1))))
      (setq my-hidden-mode-enabled-p nil)
      (message "Hidden Mode Line Mode: Globally disabled."))))

(provide 'hidden-mode-line)


