

;; (use-package
;;   flymake-posframe
;;   :load-path "~/.emacs.d/lisp/flymake-posframe.el"
;;   :hook (flymake-mode . flymake-posframe-mode))



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
