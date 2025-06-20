(defvar-local hide-mode-line nil
  "Store the original mode-line-format when hidden-mode-line-mode is active.")

(define-minor-mode hidden-mode-line-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global nil  ; 改为buffer-local模式
  :group 'editing-basics
  (if hidden-mode-line-mode
      ;; 启用时：保存当前mode-line并隐藏
      (unless hide-mode-line  ; 防止重复保存
        (setq hide-mode-line mode-line-format
              mode-line-format nil))
    ;; 禁用时：恢复原来的mode-line
    (when hide-mode-line
      (setq mode-line-format hide-mode-line
            hide-mode-line nil)))
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

(defun my-hidden-mode--apply-to-all-buffers (enable)
  "Apply hidden-mode-line-mode to all live buffers.
If ENABLE is non-nil, enable the mode; otherwise disable it."
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      ;; 跳过特殊buffer（如minibuffer、echo area等）
      (if enable
            (unless hidden-mode-line-mode
              (hidden-mode-line-mode 1))
          (when hidden-mode-line-mode
            (hidden-mode-line-mode -1))))))

(defun my-hidden-mode-toggle-global (&optional arg)
  "Toggle Hidden Mode Line globally.
With optional ARG, enable if ARG is positive, disable otherwise."
  (interactive "P")
  (let ((enable (if arg (> (prefix-numeric-value arg) 0)
                 (not my-hidden-mode-enabled-p))))
    (if enable
        (progn
          ;; 启用：添加hooks并应用到现有buffers
          (add-hook 'text-mode-hook #'hidden-mode-line-mode)
          (add-hook 'prog-mode-hook #'hidden-mode-line-mode)
          (add-hook 'conf-mode-hook #'hidden-mode-line-mode)
          (add-hook 'org-mode-hook  #'hidden-mode-line-mode)
          (my-hidden-mode--apply-to-all-buffers t)
          (setq my-hidden-mode-enabled-p t)
          (message "Hidden Mode Line Mode: Globally enabled for new and existing buffers."))
      ;; 禁用：移除hooks并恢复现有buffers
      (remove-hook 'text-mode-hook #'hidden-mode-line-mode)
      (remove-hook 'prog-mode-hook #'hidden-mode-line-mode)
      (remove-hook 'conf-mode-hook #'hidden-mode-line-mode)
      (remove-hook 'org-mode-hook  #'hidden-mode-line-mode)
      (my-hidden-mode--apply-to-all-buffers nil)
      (setq my-hidden-mode-enabled-p nil)
      (message "Hidden Mode Line Mode: Globally disabled."))))

;; 添加一个安全的重置函数
(defun my-hidden-mode-reset-all ()
  "Reset all buffers to show mode-line, useful for recovery."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (local-variable-p 'hide-mode-line)
        (when hide-mode-line
          (setq mode-line-format hide-mode-line))
        (kill-local-variable 'hide-mode-line))
      (when (local-variable-p 'hidden-mode-line-mode)
        (setq hidden-mode-line-mode nil))
      (force-mode-line-update)))
  (setq my-hidden-mode-enabled-p nil)
  (message "All mode-lines restored."))

(provide 'hidden-mode-line)


