
;; (use-package
;;   flymake-posframe
;;   :load-path "~/.emacs.d/lisp/flymake-posframe.el"
;;   :hook (flymake-mode . flymake-posframe-mode))


(setq should-i-enable-flymake t)

(defun please-enable-flymake() (message "set flag") (setq should-i-enable-flymake t))
(defun please-disable-flymake() (message "clear flag") (setq should-i-enable-flymake nil))
(defun i-should-enable-flymake() (message "check flag") (eq should-i-enable-flymake t))


(setq-default backup-eglot--current-flymake-report-fn nil)


(defun try-stop-flymake (&rest _)
  (please-disable-flymake)
  (flymake-mode 0)
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
                                (set backup-eglot--current-flymake-report-fn nil))
                              (flymake-mode 1)
                              (flymake-start)
                              )
                            )))


(use-package flymake-diagnostic-at-point
  :load-path "~/.emacs.d/lisp/flymake-diagnostic-at-point.el"
  :after flymake
  :config
  (setq flymake-start-syntax-check-on-find-file nil)
  (setq flymake-diagnostic-at-point-error-prefix " > ")
  (setq flymake-diagnostic-at-point-display-diagnostic-function
    'flymake-diagnostic-at-point-display-posframe)
  (unless (display-graphic-p)
    (setq flymake-diagnostic-at-point-display-diagnostic-function
      'flymake-diagnostic-at-point-display-minibuffer))
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode)

  ;; set faces
  (set-face-attribute 'flymake-diagnostic-at-point-posframe-background-face nil :background "dark magenta")
  (set-face-attribute 'flymake-error nil :foreground "DeepPink" :underline t)
  (set-face-attribute 'flymake-error-echo nil)
  (set-face-attribute 'flymake-warning nil :weight 'normal)
  (set-face-attribute 'flymake-warning-echo nil)
  )






;;
;; deprecated, use flymake-posframe.
;;
;; (use-package flymake-diagnostic-at-point
;;   :after flymake
;;   :config
;;   (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))





(provide 'init-flymake)
