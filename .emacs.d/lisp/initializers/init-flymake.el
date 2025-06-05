(use-package flymake
  :hook
  ;; 在支持的语言模式中启用 flymake
  ((prog-mode text-mode) . flymake-mode)

  :custom
  ;; 禁用 fringe indicator 显示
  (flymake-indicator-type nil)
  (flymake-fringe-indicator-position nil)
  ;; 自定义不同类型的显示样式
  (flymake-error-bitmap '(error))
  (flymake-warning-bitmap '(warning))
  (flymake-note-bitmap '(note))

  :config
  ;; 如果你想完全移除 fringe icons 并仅依赖于波浪线或其他方式展示错误信息
  (setq flymake-fringe-indicators '((error . nil)
                                     (warning . nil)
                                     (note . nil)))

  ;; 可选：修改错误提示样式，去掉讨厌的红色波浪线
  (set-face-attribute 'flymake-error nil :foreground "DeepPink" :underline nil)
  (set-face-attribute 'flymake-warning nil :underline nil)
  (set-face-attribute 'flymake-note nil :underline nil)

  ;; 添加一个快捷键来手动触发 flymake 检查
  (define-key flymake-mode-map (kbd "C-c f") #'flymake-start)

  ;; 如果你想要在保存文件时自动运行 flymake 检查
  (add-hook 'before-save-hook #'flymake-start nil t)
)


(setq should-i-enable-flymake t)
(defun please-enable-flymake() (setq should-i-enable-flymake t))
(defun please-disable-flymake() (setq should-i-enable-flymake nil))
(defun i-should-enable-flymake() (eq should-i-enable-flymake t))

(setq-default backup-eglot--current-flymake-report-fn nil)



(defun try-stop-flymake (&rest _)
  (please-disable-flymake)
  (flymake-mode 1)
  (when (boundp 'eglot--current-flymake-report-fn)
    (setq backup-eglot--current-flymake-report-fn eglot--current-flymake-report-fn)
    (setq eglot--current-flymake-report-fn nil)
    )
  )

(defun try-start-flymake (&rest _)
  (please-enable-flymake)
  (run-with-timer 0.3 nil #'(lambda()
                              (when (i-should-enable-flymake)
                                (when backup-eglot--current-flymake-report-fn
                                  (setq eglot--current-flymake-report-fn backup-eglot--current-flymake-report-fn)
                                  (setq backup-eglot--current-flymake-report-fn nil))
                                (flymake-mode 1)
                                (flymake-start)
                                )
                              )))



;;
;; deprecated, use sideline to display flymake messages
;;
;; (use-package flymake-diagnostic-at-point
;;   :load-path "~/.emacs.d/lisp/flymake-diagnostic-at-point.el"
;;   :after flymake
;;   :config
;;   (setq flymake-start-syntax-check-on-find-file nil)
;;   (setq flymake-diagnostic-at-point-error-prefix " > ")
;;   (setq flymake-diagnostic-at-point-display-diagnostic-function
;;     'flymake-diagnostic-at-point-display-posframe)
;;   (unless (display-graphic-p)
;;     (setq flymake-diagnostic-at-point-display-diagnostic-function
;;       'flymake-diagnostic-at-point-display-minibuffer))
;;   (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode)
;;
;;   ;; set faces
;;   (set-face-attribute 'flymake-diagnostic-at-point-posframe-background-face nil :background "dark magenta")
;;   (set-face-attribute 'flymake-error nil :foreground "DeepPink" :underline t)
;;   (set-face-attribute 'flymake-error-echo nil)
;;   (set-face-attribute 'flymake-warning nil :weight 'normal)
;;   (set-face-attribute 'flymake-warning-echo nil)
;;   )






;;
;; deprecated, use flymake-posframe.
;;
;; (use-package flymake-diagnostic-at-point
;;   :after flymake
;;   :config
;;   (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))





(provide 'init-flymake)
